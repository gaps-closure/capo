# Compliant Partition Feasibility Checker

Given LLVM IR from CLE-annotated C code, this checker looks for conflicts and determines whether a cross-domain paritioning of 
the code is feasible.  If so, an assignment of level to each function and global variable that satisfies the 

This is intended to run after Andrzej's heuristics have been applied to find and report conflicts (and advise on resolution) 
until developer resolves them by refactoring.

Then this formally confirms there are no conflcits and prepaes the code for refactoring.

## Install prerequisites
```
sudo snap install minizinc

# Python bindings to MiniZinc constraint solver
sudo -H pip3 install minizinc

# Simple finite domain cosntraint solver in Python
sudo -H pip3 install python-constraint  
```

## Prepare sample input and run conflict analyzer

```
bash prep_sample.sh
python3 conflict_free_partition.py -c ./scratch/*.clemap.json
```
