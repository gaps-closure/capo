# Compiler and Partitioner Optimizer (CAPO)
This repository hosts the open source components of CAPO. The `master` branch contains the most recent public release software while `develop` contains bleeding-edge updates and work-in-progress features for use by beta testers and early adopters.

This repository is maintained by Perspecta Labs.

## Contents
- [Build](#build)
- [Partitioner](partitioner/README.md)
- [PDG](pdg/README.md)
- [Quala](quala/README.md)

## Build
CAPO has been developed, deployed, and tested using Ubuntu 19.10 x86_64 Linux. We recommend this distribution to simplify installation of external dependencies. Upon cloning the CAPO repository, follow these steps to install required packages (assumes sudo permissions enabled for calling `apt`):

```
./build.sh 
```

This script downloads, installs or builds the following
* LLVM binaries
* pdg
* quala
* partitioner

