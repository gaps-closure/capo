ODIR := ./build
EDIR := ./example
ENCLAVES := Orange Purple
build_folder := $(shell mkdir -p $(ODIR))
enclave_folders := $(foreach enclave,$(ENCLAVES), $(shell mkdir -p $(ODIR)/$(enclave)))
CC := clang-9
CC_FLAGS := -emit-llvm -S -g

plugin:
	@cd $(ODIR) && cmake ..
	@$(MAKE) -C $(ODIR)

# Hard clean cleans whole build directory and compiled files in example directory
clean: eclean
	@rm -rf $(ODIR)

# 
#	* Rules for running the EDL pass on the project
# #########################################################################

# Do GEDL generation pass
gedl: compile gen $(ODIR)/gedl.ll
	cd $(ODIR) && opt -disable-output -load libpdg.so -accinfo-track -d 1 -u "untrusted/" -t "trusted/" < ../$(ODIR)/gedl.ll

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
	$(foreach enclave,$(ENCLAVES), $(CC) $(CC_FLAGS) $(EDIR)/$(enclave)/$(enclave).c -o $(EDIR)/$(enclave)/$(enclave).ll;)

# Example clean cleans the ll files from the example.
eclean:
	@rm -rf $(EDIR)/*.ll

# *************************************************************************