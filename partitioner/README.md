Conflict analyzer:
==================

The name 'partitioner' is a misnomer, as the program performs conflict analysis of an annotated source code.

Usage:
------

python3 partitioner.py <C source file>

Notes:
- partitioner expects LLVM IR file of the same name but with extension .ll in the same directory
- partitioner expects a program dependency graph generated with the pdg software named 'pdgragh.main.dot' in the same directory


Output:
-------

Partitioner prints information about the results of the analysis of conflicts between data and functions annotated with different enclave levels. Conflicts can be resolvable, in which case a dividing program can be run on it, or non-resolvable, in which case the programmer must refactor the code.

Partitioner produces two output files:
- 'enclaves.dot' containing the program dependency graph where each node is colored according to the enclave it should belong to.
- 'topology.json' containing JSON desription of which function and global variable belongs to which enclave. This file is an input to the dividing program.

Processing steps:
-----------------

Partitioner colors the program dependency graph, and detects conflicts, as follows:

1. Color all items directly annotated, finding the actual item definition nodes
   - possible conflicts: 
     . more than one annotation for an item

2. Color the function definition node if that function has a directly annotated item defined in it.
   - possible conflicts:
     . item annotated differently than function itself
     . differently annotated items in the same function

3. Color each instruction in a function that has a colored definition node.
   - possible conflicts:
     . calls from colored function to a function colored differently

4. Color each instruction that uses a colored item (data or function). This is the main step of conflict analysis.

