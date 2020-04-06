# Compiler and Partitioner Optimizer (CAPO)
This repository hosts the open source components of CAPO. The `master` branch contains the most recent public release software while `develop` contains bleeding-edge updates and work-in-progress features for use by beta testers and early adopters.

This repository is maintained by Perspecta Labs.

## Contents
- [Build](#build)
- [Partitioner](partitioner/README.md)
- [PDG](pdg/README.md)
- [Quala](quala/README.md)
- [Running the Partitioner](#running-the-partitioner)
- [Viewing the Dependency Graph](#viewing-the-dependency-graph)

## Build
CAPO has been developed, deployed, and tested using Ubuntu 19.10 x86_64 Linux. We recommend this distribution to simplify installation of external dependencies. Upon cloning the CAPO repository, follow these steps to install required packages (assumes sudo permissions enabled for calling `apt`):

```
./build.sh -h
#Usage: ./build.sh [ -hcdl]
#                  [ -l BRANCH ]
#-h        Help
#-b BRANCH Build LLVM from the BRANCH branch of the source 
#-c        Clean up
#-d        Dry run
#-l        Install LLVM, after build or after downloading the pre-built binary.
```

This script builds the following
* pdg
* quala
* partitioner

Optionally, with the specified options, it also downloads, builds or install the LLVM binaries.


## Running the Partitioner
To run the partitioner in command line, following the steps [here](partitioner/README.md). To run the partitioner in Visual Studio Code, follow the instructions in [CVI](https://github.com/gaps-closure/cvi/blob/master/README.md) to build and install Code, if it has not been installed. Then follow the steps below.

Start VS Code as follows, if it is not already running.

```
cd $CAPO/partitioner
code .
```
The following tasks, listed in order of dependency, are defined in the partitioner project.
* Partitioner Compile - build partitioner library src/libxdcomms.a
* Partitioner Clang - Run a simple example ex1.c with CLE markings through the CLE preprocessor to generate annotations (ex1.mod.c) and an annotation map file (ex1.c.clemap.json). Then compile them using clang.
* Partitioner LLVM IR and Bitcode Gen - Run the ex1.mod.c through LLVM IR and bytecode generation, resulting ex1.mod.bc and ex1.mod.ll.
* Partitioner Dependency Graph - Build the program dependency graph. Serveral .dot files are generated. Only pdgraph.main.dot is actually used at this time.
* Partitioner Partition - Finally, run the partitioner and display the analysis of the program and the actions needed to be undertaken to partition it into independent security enclaves.

Each task depends on its immediate predecessor. All predecessors of a task will be run before the task itself is run.
To run all tasks, choose the Partiion task. The "Partitioner Clean" task cleans up all intermediate files.

To run a task,
* Select Run Task from the Terminal menu.
* A list of Partitioner tasks will be displayed.
* Select the desired task from the list.
* Select 'Continue with scanning the task output'

## Viewing the Dependency Graph
To view the dependency graph in command line, following the steps [here](partitioner/README.md). To view it in Visual Studio Code, follow the instructions in [CVI](https://github.com/gaps-closure/cvi/blob/master/README.md) to build and install Code, if it has not been installed. Then following the steps below.
Start VS Code as follows, if it is not already running.

```
cd $MULES/partitioner
code .
```
* Run the Partitioner Partition task as described above.
* Select the top icon (two pieces of paper) on the left task bar.
* Expand the example directory
* Click on the pdgraph.main.dot file to open it in the editor panel.
* Click on the ... button in the upper right corner and select Open Preview ti the Side.
* Expand the panel that appears on the right to see the graph. Use the buttons at the bottom to zoom or pan the graph.

Use the same procedure on the enclaves.dot file to see a colored graph.
