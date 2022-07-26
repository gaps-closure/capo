#!/bin/bash  

minizinc --solver Gecode ./*.mzn ./constraints/*.mzn > result.txt
cat result.txt
if [ $# -ge 1 ] ;
then
minizinc --solver Findmus -a --depth 200 --output-json ./constraints/*.mzn ./*.mzn > result.txt
cat result.txt
./parseUnsat.py
fi
