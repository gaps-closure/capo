#!/bin/bash

count=0
for var in "$@"
do
count=$((count+1))
python3.7 cle2zinc.py  -L -f $var
clang -c -emit-llvm -g $var -o "./temp_"$count".bc"
done

llvm-link temp_*.bc -o temp.bc

# opt -load ~/program-dependence-graph/build/libpdg.so -minizinc -zinc-debug  < ~/program-dependence-graph/test/example1.mod.bc

minizinc conflict_analyzer.mzn init_cle.mzn pdg_data.dzn conflict_analyzer_decs.mzn cle-data.dzn

rm *.bc