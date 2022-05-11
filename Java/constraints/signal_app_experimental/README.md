# Experiemntal proof-of-concept CLOSURE partitioner for Android Signal App

## Input data

Before starting, we need the program model file (e.g., `test/test1/signal.json`) and CLE JSON file (e.g.,
`test\test1\signal-cle.json`) for the CLE-Annotated Signal App to be partitioned.

To obtain these, the application sources are CLE-annotated by the developer. The APK is built and
disassembled using BakSmali; from the disassembed Smali files, the program model is extracted.
The CLE annotations are also extracted from the annotated sources into a single CLE JSON file.
(XXX: pointer to Ta's utility).

We then prepare the input data for constraint solving using Minizinc:

```
$ python3 dataprep/gen_mzninstance.py -i test/test1/signal.json.gz -c test/test1/signal-cle.json -o test/test1/instance
```

Three files, namely, `test/test1/instance/pdg_instance.mzn`,
`test/test1/instance/cle_instance.mzn`, and
`test/test1/instance/enclave_instance.mzn` are created. The
`test/test1/instance/` directory is created if needed. These files conform to
the variable type declarations specified in
`constraints/conflict_variable_declarations.mzn`.  A debug helper file
`test/test1/instance/pdg.csv.gz` is also produced.

## Running the conflict analyzer

We rely on MiniZinc verion 2.5.5

```
$ /opt/minizinc/bin/minizinc --version
MiniZinc to FlatZinc converter, version 2.5.5, build 273041792
Copyright (C) 2014-2021 Monash University, NICTA, Data61
```

To run the conflict analyzer on the Signal app model data:

```
$ /opt/minizinc/bin/minizinc --solver Gecode constraints/*.mzn test/test1/instance/*.mzn
```


