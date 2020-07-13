ODIR := ./build
EDIR := ./example/EnclaveSplit
PROG := Closure
HEURISTICS_DIR:= ./heuristics
SCHEMA_PATH:= ../gedl-schema/gedl-schema.json
CLE_PRE=/home/mnorris/gaps/build/src/mules/cle-preprocessor/src
HAL_PATH=/home/mnorris/gaps/build/src/hal
IPC_MODE=Multithreaded

INURI="ipc:///tmp/test1sub"
OUTURI="ipc:///tmp/test1pub"
XDCONF_FILE="xdconf.ini"


build_folder := $(shell mkdir -p $(ODIR))
autogen_folder := $(shell mkdir -p $(ODIR)/autogen)
encSet := $(foreach enclave,$(sort $(dir $(wildcard $(EDIR)//*/))), $(eval ENCLAVES+=$(notdir $(enclave:%/=%))))
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
	@cd $(ODIR) && mv libpdg.so libgedl.so

# Hard clean cleans whole build directory and compiled files in example directory
clean: eclean
	@rm -rf $(ODIR)
	rm -rf $(EDIR)/*/*.mod.c $(EDIR)/*/*.ll

# 
#	* Rules for running the EDL pass on the project
# #########################################################################

# Do GEDL generation pass
gedl: compile gen $(ODIR)/gedl.ll
	cd $(ODIR) && opt -disable-output -load libgedl.so -accinfo-track -d 1  -prog $(PROG) -schema $(SCHEMA_PATH) -he $(HEURISTICS_DIR)< gedl.ll

#Do IDL generation script
idl: gedl
	python IDLGenerator.py -g "$(ODIR)/$(PROG).gedl" -o "$(ODIR)/autogen/$(PROG).idl" -i $(IPC_MODE)
	
#Do autogeneration
autogen: idl
	cd $(autogen_dir) && python3 $(HAL_PATH)/autogen/autogen.py -i "$(PROG).idl" -g bw_v1 -d $(PROG)_bw.dfdl -e codec
	cd $(autogen_dir) && $(HAL_PATH)/autogen/autogen.py -i "$(PROG).idl" -g be_v1 -d $(PROG)_be.dfdl -e codec

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
compilePartitioned: rpc
	cd $(ODIR) && $(foreach enclave,$(ENCLAVES), cd $(enclave); gcc -c *.c ${INCLUDES}; cd ../;)
	cd $(ODIR) && $(foreach enclave,$(ENCLAVES), cd $(enclave); gcc -o $(enclave) *.o  ${LDLIBS} ${LIBS} -lxdcomms;cd ../;)
	
	
$(ODIR)/$(enclave)/%.o:	%.c
	gcc -c $< -o $@
	


#Do RPC Generation
rpc: autogen libraries
	@rm -f $(ODIR)/$(XDCONF_FILE) 
	$(foreach enclave,$(ENCLAVES), $(eval ENCLAVEFL += $(EDIR)/$(enclave)/*.mod.c ))
	python RPCGenerator.py -o $(ODIR) -g $(ODIR)/$(PROG).gedl -i $(IPC_MODE) -a $(HAL_PATH)/api -n $(INURI) -t $(OUTURI) -x $(XDCONF_FILE) -f $(ENCLAVEFL)

	
#Generates the defined_func and imported_func files for each enclave
gen: plugin
	$(foreach enclave,$(ENCLAVES), opt -disable-output -load libgedl.so -llvm-test -prefix $(ODIR)/$(enclave)/ < $(EDIR)/$(enclave)/$(enclave).ll;)


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