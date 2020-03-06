Partitioner:
------------

This software processes a CLE annotated program (currently only C and maximum of 2 different enclaves) and produces a list of actions that a developer needt to take to partition that program into two separate processes communicating using guarded send and receive.

Dependencies:
-------------

The following are necessary Python3 packages:
> pip3 install clang lark-parser pydot decorator

and Linux package:   
> apt install xdot


Two projects must be checked out and in working order:   
cle/ - the preprocessor   
pdg/ - the PDG software (dependency graph builder)

They may have other dependencies (e.g., llvm).   


Notes:
------

The PDG created by the pdg software has different debugging info attached to it than the original LLVM IR file (.ll)

The pydot used to read the dot file creates NEW INSTANCES of nodes (or edges) with the same name (which are unique) and attributes each time the graph.get_nodes() (or graph.get_edges()) is called.

PDG software has been modified extensively, to print labels on all arcs, add more info on ENTRY nodes (function definition), process global annotations etc.


Code organization:
------------------

src/ contains the partitioner code, both Python and C.   
example/ contains the example file on which we work.   
example/example_files/ contains the unmodifies example files. These should not be modified (unless you know what you are doing).   
directories src/scratch, include/ and pyir/ are experimental directories, not meant for general use.

Building the partitioner:
-------------------------

> cd src   
> make   

Basic usage:
------------

The Makefile containing the steps that pre-process the program has to be copied from the partitioner example directory to the directory that contains the program to be processed.
The name of the program to be processed is given as a parameter to the make file running all pre-processing steps, and then to the partitioner that runs the analysis. The syntax of these commands is:

> cd \<directory where the program resides\>   
> make PROG=\<name of C program without extension\>   
> python3 \<path to partitioner diretory\>/partitioner.py \<name of C program without extension\>   

For example, assuming the partitioner is in /home/user/partitioner/, to process program /home/user/bar/foo.c:

> cd /home/user/bar/   
> cp /home/user/partitioner/example/Makefile .   
> make PROG=foo   
> python3 /home/user/partitioner/src/partitioner.py foo   



Example walkthrough:
--------------------

There is a demonstration program in the subdirectory 'example' showing the steps and results of running the Partitioner. The name of this program is ex1.c: 

> cd example    
> cp example_files/* .   

The starting point is 'ex1_plain.c' - a simple program that gets three values, combines them and displays the result. It
uses three header files (gps_lib.h, targeting.h imaging.h) and a library (libex1.a).

The developer edits this file by adding the CLE markings, resulting in ex1.c. 
This file can be compiled and run, just to see the results:

Using gcc:   
> make PROG=ex1 ex1   
> ./ex1   

Using clang:   
> make PROG=ex1 clang_ex1   
> ./clang_ex1   

The file with markings is run through the preprocessor, to generate annotations and an annotation map file:

> make PROG=ex1 ex1.mod.c

The result are two files:   
ex1.mod.c - the source file containing preprocessed directives (annotations). This is the file the developer will be working on from now on.   
ex1.c.clemap.json - the annotation map containing information about security labels. It will be read by the partitioner.   

The preprocesed file is run through LLVM IR and bytecode generation:

> make PROG=ex1 ex1.mod.bc

The result is files ex1.mod.ll and ex1.mod.bc (IR and bytecode respectively). .ll file will be read by the partitioner, .bc file will be read by the PDG software.

Next, the program dependency graph is build:

> make PROG=ex1 dot

The result are files:   
pdgragh.main.dot   
cdgragh.main.dot   
ddgragh.main.dot   
and many other .dot files. The named three will be read by the partitioner, and only pdgragh.main.dot is actually used at this time.

You can display the pd graph using command:

> xdot pdgragh.main.dot

Note that the graph is huge, and it may show almost invisible. Click "1" icon to zoom in properly.

Finally, run the partitioner:

> python3 ../src/partitioner.py ex1

It displays the analysis of the program, and the actions needed to be undertaken to partition it into independent security enclaves. There are two actions in the output: \<end of step1\> and \<end of step2\>. The files ex1_step1.mod.c and ex2_step2.mod.c show how the file would look like at these places if the developer followed the actions.

The partitioner works by "coloring" the dependency graph with the colors corresponding to security enclaves. It produces a file enclaves.dot that contains the colored graph for display and humab inspection purposes. You can show it by:

> xdot enclaves.dot

You can see that the node "combine_and_display_data" has arrows coming from both enclaves, thus creating a conflict.

The file with all the actions up to \<end of step2\> applied should be free of conflicts. Copy it as the new ex1.mod.c and run the software again (dont forget to make dot):

> cp ex1_step2.mod.c ex1.mod.c
> make PROG=ex1 dot
> python3 ../src/partitioner.py

You should see no conflicts - the file is ready to be split in two according to actions in "Other" section

After performing the remaining actions you should have two files: 'ex1_orange.mod.c' and 'ex1_purple.mod.c'. There are two targets in the Makefile to make them: ex1_orange and ex1_purple (these two can be called together as 'ex1_parts'). Compile them:

> make PROG=ex1 ex1_parts

then run each in separate terminals (in any orther):

> ./ex1_orange

and

> ./ex1_purple

The result should be just as like you run the 'ex1' program.

Partitioner design:
-------------------

The partitioner has two parts: software, that analyses and manipulates the program with security markings, and library that implements data transfer fucnctions.

The partitioner software is written in Python and contains five modules:   
dot_reader.py - a module to read the dependency graph (.dot) files, using pydot package.   
graph_helper.py = implements graph operations on the dependency graphs read by the dot_reader.   
ir_reader.py - reads LLVM IR files (.ll) and implements most operations on them, such as searching for debug info.   
policy_resolver.py - reads the annotation map file (.clemap.json) and potentially the default security policy file, and provides information about CLE markings, labels, enclaves, and parmitted operations.   
partitioner.py - this is the main driver and contains most of the logic. It initializes the other modules, causes them to read the input files, and prints out the partitioning information.   

The partitioner library is written in C, and consists of partitioner.h and partitioner.c files, implementing the data transfer between enclaves.
