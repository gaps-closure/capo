# Java Closure
## Contents:

* [Install and Build Joana](#install-and-build-joana)
* [Build the Demo Application](#build-the-demo-application)
* [Run the Conflict Analyzer](#run-the-conflict-analyzer)
* [Build HAL](#build-hal)
* [Build Code Generator](#build-code-generator)
* [Partition the Demo Application](#partition-the-demo-application)

### Install and Build Joana

    $ rm -rf /tmp/smoke_main
    $ cd $CAPO/joana
    $ ./setup_deps 
    $ ant
    $ ant doc-wala

### Build the Demo Application

    $ cd $CAPO/examples/eop2-demo/
    $ ant

### Run the Conflict Analyzer 

    $ cd $CAPO
    $ java -cp $CLASSPATH org.python.util.jython zincOutput.jy -m ./examples/eop2-demo/src/com/peratonlabs/closure/eop2/video/manager/VideoManager.java -c ./examples/eop2-demo/dist/TESTPROGRAM.jar -e com.peratonlabs.closure.eop2.video.manager.VideoManager -b  com.peratonlabs.closure.eop2.

The resulting cut.json will be produced in the directory the above command is invoked from.

  -m option indicates what java file has the main class to analyze

  -c option indicates the jar file to analyze
  
  -e option indicates the class with the entry method
  
  -b option indicates the prefix for the classes that are of interest

  Running this command will result in the following artifacts to be generated
  
  * enclave_instance.mzn
  * pdg_instance.mzn
  * cle_instance.mzn
  * cut.json
  * dbg_edge.csv
  * dbg_node.csv
  * dbg_classinfo.csv

  The dbg_edge.csv and dbg_node.csv files report useful information about all of the nodes and edges in the SDG being analyzed that can be useful to debug and find issues with annotations

  The dbg_classinfo.csv file contains the class name, field, and method name to ID relationships.

  The three .mzn files are what get fed to minizinc along with the .mzn files in the constraints/ directory to check if the program is properly annotated.

  If the program is properly annotated, a cut.json file is produced showing the class assingments to each enclave and the methods in the cut.

  Since the output of the constraint solver reports edge IDs, useful scripts are available in the capo/Java/scripts directory. The edgeDbg.py scripts takes an edge ID as input and produces the debug information for the associated source and destination nodes. Similarly, getclassName.py takes a class ID and produces the correspoinding class name for the ID. Note that these scripts assume the dbg_*.csv files are in the same directory as the scripts.
  
### Build HAL
    $ cd $HOME/gaps/hal
    $ make   
      
### Build Code Generator
    $ cd $HOME/gaps/CodeGenJava
    $ ant

### Partition the Demo Application
    $ java -jar code-gen/code-gen.jar
  

