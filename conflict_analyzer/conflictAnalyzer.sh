#!/bin/bash


opt -load ~/program-dependence-graph/build/libpdg.so -minizinc  < $1

python3.7 ./scripts/CLEJson2zinc.py -f $2

mv *.mzn ./instance/
mv *.csv ./instance/

# opt -load ~/program-dependence-graph/build/libpdg.so -minizinc -zinc-debug  < temp.bc 2> /dev/null 

minizinc --solver Gecode ./constraints/*.mzn ./instance/*.mzn  > result.txt
cat result.txt

mv *.txt ./output/

# rm *.bc