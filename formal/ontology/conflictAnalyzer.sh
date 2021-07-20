#!/bin/bash

count=0
for var in "$@"
do
count=$((count+1))
python3.7 cle2zinc.py  -L -f $var
python3.7 qd_cle_preprocessor.py  -L -f $var
clang -c -emit-llvm -g "out.c" -o "./temp_"$count".bc"
done

llvm-link temp_*.bc -o temp.bc

# opt -load ~/program-dependence-graph/build/libpdg.so -minizinc  < temp.bc
opt -load ~/program-dependence-graph/build/libpdg.so -minizinc -zinc-debug  < temp.bc

minizinc conflict_analyzer_constraints.mzn conflict_variable_declerations.mzn pdg_instance.mzn cle_instance.mzn enclave_instance.mzn > result.txt
cat result.txt

# rm *.bc 
