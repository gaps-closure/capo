# Phase 3 CAPO Conflict Analyzer

This directory contains the CAPO phase 3 constraint documentation, test cases, and test scripts, as present on the `capo/phase-3-develop` branch.

The parent directory `README.md` details the phase 2 conflict analyzer and constraints, but the Python code and `.mzn` constraints are updated for phase 3.

## Running the conflict analyzer

**KNOWN ISSUE**: Library functions (`printf`, `malloc`, `free`, etc.) are given SVF points-to edges with no associated LLID from the PDG. These edges must be ignored by manually disabling these functions in `unify_pdg_svf.py` (see the comments in the script for guidance). This will have to be done on a per-program basis.

Within the `phase-3` directory, the conflict analyzer can be run on a program with the following command:

```
   export PYTHONPATH="${PYTHONPATH}:../.." \
&& mkdir tmp 
&& python3 -m conflict_analyzer \
   --temp-dir tmp \
   --pdg-lib ../../pdg2/build/libpdg.so \
   --dump-ptg ../../pdg2/svf/Release-build/bin/dump-ptg \
   --pts-to-algo ander \
   tests/infeasible/leak-glob-thru-heap/prog.c # path to program
```

The `-h` flag gives optional arguments and descriptions.

## Adding nodes/edges to the conflict analyzer

1. Modify `pdg2` or `svf` to export the new node/edge to `pdg_data.csv` or `svf_edges.csv` respectively.
2. Add the new node/edge name to the exporter `pdg2zinc.py`, following the guidance in the comments.
3. Add the new node/edge name to `constraints/conflict_variable_declarations.mzn`. This entails (a) adding the start and end indices for the new node/edge, (b) adding the set which ranges from the start to the end variables, and (c) optionally adding the set to the constrained unions of sets (e.g. if adding a new intra-enclave data dependency edge, it should be included in `DataEdgeEnclaveSafe`).
4. Add any desired constraints on the new node/edge to `constraints/conflict_analyzer_constraints.md` (if just adding a new constraint, this is the only step needed).
5. Run any desired test cases.

## Running the tests

There are two relevant scripts, `phase-3/test-p3`, and `phase-3/pdg_csv_viewer`.

### test-p3

`./test-p3 ander all` will run conflict analysis on all of the tests in `tests/infeasible` and `tests/feasible`, using `ander` as the points-to algorithm, and will output their success or failure (failure of a feasible example indicates the minizinc instance is unsatisfiable, while failure of an infeasible example indicates that the minizinc instance is satisfiable).

`./test-p3 ander infeasible leak-glob-thru-heap` will run conflict analysis on the example program contained in `tests/infeasible/leak-glob-thru-heap`, using `ander` as the points-to algorithm, and will fill the corresponding `artifacts` directory with all of the conflict analyzer output.

On success, the topology will be written to `ca-output.txt`. Note that `test-p3` disables findMUS, so in order to get the findMUS output, findMUS should be run manually on the corresponding `artifacts/instance.mzn`.

### pdg_csv_viewer

After running a test case with `test-p3`, running, e.g. `./pdg_csv_viewer infeasible leak-glob-thru-heap` will start a web application that renders the corresponding `artifacts/pdg_svf_data.csv` in a readable form that can be filtered and examined. It is useful for debugging the presence or absence of expected edges for a given program.

## Adding test cases

1. Write and annotate an example program `prog.c`.
2. Create a directory with a unique descriptive name, and place `prog.c` inside of it. Create an empty directory called `artifacts` in the new directory.
3. Place the directory in `phase-3/tests/feasible` if the example should pass conflict analysis, and `phase-3/tests/infeasible` if the example should fail conflict analysis.
4. The test script `phase-3/test-p3` will automatically pick up the new test case, and it can be run individually or with all of the other tests.