#!/bin/bash

opt -load ~/program-dependence-graph/build/libpdg.so -minizinc -zinc-debug  < ~/program-dependence-graph/test/example1.mod.bc

minizinc check-inputs.mzn init_cle.mzn pdg_data.dzn conflict_analyzer_decs.mzn cle-data.dzn