#!/bin/bash

filename=$1
extension="${filename##*.}"
filename="${filename%.*}"

rm ./instance/*

python3.7 ../../mules/cle-preprocessor/src/qd_cle_preprocessor.py -o ./tests/  -L -P -f $1

clang -c -emit-llvm -g $filename.mod.$extension -o "./temp.bc"

if [[ ! -e "./temp.bc" ]]; then
    echo "Compilation Failed"
    exit 1
fi



opt -load ~/program-dependence-graph/build/libpdg.so -minizinc  < temp.bc

if [[ ! -e "./pdg_instance.mzn" ]]; then
    echo "Pdg Model Construction Failed!"
    exit 1
fi

python3.7 ./scripts/CLEJson2zinc.py -f $filename.clemap.json

if [[ ! -e "./cle_instance.mzn" ]]; then
    echo "CLE Model Construction Failed!"
    exit 1
fi

mv *.mzn ./instance/
mv *.csv ./instance/
# opt -load ~/program-dependence-graph/build/libpdg.so -minizinc -zinc-debug  < temp.bc 2> /dev/null 

minizinc --solver Gecode ./constraints/*.mzn ./instance/*.mzn  > result.txt
cat result.txt
minizinc --solver findmus --subsolver Gecode --depth 3 --output-json --no-stats --no-progress ./constraints/*.mzn ./instance/*.mzn > ./output/findmus.txt

mv *.txt ./output/
cp $1*.pkl ./output

# rm out.c
# rm *.bc