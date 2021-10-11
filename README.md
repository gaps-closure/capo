# Compiler and Partitioner Optimizer (CAPO)
This repository hosts the open source components of CAPO. The `master` branch contains the most recent public release software while `develop` contains bleeding-edge updates and work-in-progress features for use by beta testers and early adopters.

This repository is maintained by Perspecta Labs.

<b> CAPO has been fully integrated with our CVI and is invoked during project builds. Please refer to CVI build tasks for examples 1-3 and Security Desk applications.</b>

## Conflict Analyzer

From this directory, you can build the conflict analyzer python package using:

`python3 -m build`

You can run the conflict analyzer locally using

`python3 -m conflict_analyzer.conflict_analyzer <args>`

You can install using 

`python3 -m pip install .`