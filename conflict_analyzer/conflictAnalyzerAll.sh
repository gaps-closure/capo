#!/bin/bash

filename=$1
extension="${filename##*.}"
filename="${filename%.*}"

python3.7 ./scripts/qd_cle_preprocessor.py  -L -f $1

clang -c -emit-llvm -g $filename.mod.$extension -o "./temp.bc"



opt -load ~/program-dependence-graph/build/libpdg.so -minizinc  < temp.bc

python3.7 ./scripts/CLEJson2zinc.py -f $1.clemap.json

mv *.mzn ./instance/
mv *.csv ./instance/
# opt -load ~/program-dependence-graph/build/libpdg.so -minizinc -zinc-debug  < temp.bc 2> /dev/null 

minizinc --solver Gecode ./constraints/*.mzn ./instance/*.mzn  > result.txt
cat result.txt
minizinc --solver findmus --subsolver Gecode --depth 3 --output-json --no-stats --no-progress ./constraints/*.mzn ./instance/*.mzn > findmus.txt

mv *.txt ./output/

# rm out.c
# rm *.bc