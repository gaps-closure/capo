ODIR := ./build
EDIR := ./example
ENCLAVES := orange2 purple2
CLE_PRE=/home/mnorris/gaps/build/src/mules/cle-preprocessor/src
HAL_PATH=/home/mnorris/gaps/build/src/hal
IPC_MODE=Multithreaded


build_folder := $(shell mkdir -p $(ODIR))
autogen_folder := $(shell mkdir -p $(ODIR)/autogen)
enclave_folders := $(foreach enclave,$(ENCLAVES), $(shell mkdir -p $(ODIR)/$(enclave)))
CC_FLAGS := -emit-llvm -S -g
CFLAGS = -O2 -Wall -Wstrict-prototypes
autogen_dir := $(ODIR)/autogen
LIB_OBJ= $(autogen_dir)/float754.o $(autogen_dir)/codec.o 
INCLUDES=-I$(HAL_PATH)/api -I../autogen
LDLIBS=-L$(HAL_PATH)/api
LIBS=../autogen/libcodecs.a -lpthread


plugin:
	@cd $(ODIR) && cmake ..
	@$(MAKE) -C $(ODIR)

# Hard clean cleans whole build directory and compiled files in example directory
clean: eclean
	@rm -rf $(ODIR)
	rm -rf $(EDIR)/*/*.mod.c $(EDIR)/*/*.ll

# 
#	* Rules for running the EDL pass on the project
# #########################################################################

# Do GEDL generation pass
gedl: compile gen $(ODIR)/gedl.ll
	cd $(ODIR) && opt -disable-output -load libpdg.so -accinfo-track -d 1 -u "untrusted/" -t "trusted/" < ../$(ODIR)/gedl.ll

#Do IDL generation script
idl: gedl
	python IDLGenerator.py -g "$(ODIR)/Closure.gedl" -o "$(ODIR)/autogen" -i $(IPC_MODE)
	
#Do autogeneration
autogen: idl
	cd $(autogen_dir) && python3 $(HAL_PATH)/autogen/autogen.py -i "Closure.idl" -g Closurebw_v1 -d Closure_bw.dfdl -e codec
	cd $(autogen_dir) && $(HAL_PATH)/autogen/autogen.py -i "Closure.idl" -g be_v1 -d Closure_be.dfdl -e codec

#Do autogen libraries
libraries: slibs libs

$(autogen_dir)/libcodecs.a: $(LIB_OBJ)
	ar rcs $@ $^

$(autogen_dir)/libcodecs.so: $(LIB_OBJ)
	gcc $(CFLAGS) -fPIC -shared -o $@ $<

libs: $(autogen_dir)/libcodecs.a 

slibs: $(autogen_dir)/libcodecs.so 

$(autogen_dir)/%.o:	%.c
	gcc $(CFLAGS) -fPIC -c $< -o $@

#Compile partitioned code	
compilePartitioned: 
	cd $(ODIR) && $(foreach enclave,$(ENCLAVES), cd $(enclave); gcc -c *.c ${INCLUDES}; cd ../;)
	cd $(ODIR) && $(foreach enclave,$(ENCLAVES), cd $(enclave); gcc -o $(enclave) *.o  ${LDLIBS} ${LIBS} -lxdcomms;cd ../;)
	
#cd $(ODIR) && $(foreach enclave,$(ENCLAVES), gcc -c $(enclave)/*.c ${INCLUDES};)
#cd $(ODIR) && $(foreach enclave,$(ENCLAVES), gcc -o $(enclave)/$(enclave) $(enclave)/*.o  ${LDLIBS} ${LIBS} -lxdcomms;)
	
$(ODIR)/$(enclave)/%.o:	%.c
	gcc -c $< -o $@
	
#gcc -c test1_orange.c test1_orange_rpc.c ${INCLUDES}
#gcc -o test1_orange test1_orange.o test1_orange_rpc.o ${LDLIBS} ${LIBS} -lxdcomms


#Do RPC Generation
rpc: autogen libraries
	$(foreach enclave,$(ENCLAVES), $(eval ENCLAVEFL += $(EDIR)/$(enclave)/*.mod.c ))
	python RPCGenerator.py -o $(ODIR) -g $(ODIR)/Closure.gedl -i $(IPC_MODE) -a $(HAL_PATH)/api -n "ipc:///tmp/test1suborange" -t "ipc:///tmp/test1puborange" -f $(ENCLAVEFL)

	
#Generates the defined_func and imported_func files for each enclave
gen: plugin
	$(foreach enclave,$(ENCLAVES), opt -disable-output -load libpdg.so -llvm-test -prefix $(ODIR)/$(enclave)/ < $(EDIR)/$(enclave)/$(enclave).ll;)


# Build clean cleans the files generated from passes in build directory
bclean: eclean
	@rm -rf $(ODIR)/Enclave.edl $(TRUSTED_DIR) $(UNTRUSTED_DIR) $(ODIR)/*.c* $(ODIR)/*.h


.PHONY: compile
compile: compEncs
	$(foreach enclave,$(ENCLAVES), $(eval ENCLAVELL += $(EDIR)/$(enclave)/$(enclave).ll ))
	llvm-link $(ENCLAVELL) -S -o $(ODIR)/gedl.ll

compEncs:
	rm -rf $(EDIR)/*/*.mod.c $(EDIR)/*/*.ll $(EDIR)/*/*.json
	$(foreach enclave,$(ENCLAVES),	$(CLE_PRE)/qd_cle_preprocessor.py -L -f $(EDIR)/$(enclave)/*.c;)
	$(foreach enclave,$(ENCLAVES),	clang-9 $(CC_FLAGS) $(EDIR)/$(enclave)/*.mod.c -o $(EDIR)/$(enclave)/$(enclave).ll;)


# Example clean cleans the ll files from the example.
eclean:
	@rm -rf $(EDIR)/*.ll

# *************************************************************************