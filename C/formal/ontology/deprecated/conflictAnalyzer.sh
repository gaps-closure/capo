#!/bin/bash


opt -load ~/program-dependence-graph/build/libpdg.so -minizinc  < $1

python3.7 CLEJson2zinc.py -f $2
# opt -load ~/program-dependence-graph/build/libpdg.so -minizinc -zinc-debug  < temp.bc 2> /dev/null 

minizinc conflict_analyzer_constraints.mzn conflict_variable_declerations.mzn pdg_instance.mzn cle_instance.mzn enclave_instance.mzn > result.txt
cat result.txt

# rm *.bc