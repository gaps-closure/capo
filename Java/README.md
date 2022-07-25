# Java Closure
##Contents:

* [`Setup`](#Setup)
* [`Test Joana`](#Test-Joana)
* [`Produce Program Partition`](#Produce-Program-Partition)
* [`Run EOP2 Demo`](#Run-EOP2-Demo)


## Setup


### Download Java Closure
```
cd ~/gaps
git clone ssh://git@github.com/gaps-closure/java-closure.git
cd java-closure/
```

### Install JOANA and dependencies


**IMPORTANT** JOANA really wants Java 1.8, build fails with higher versions

Install the following dependencies

```
sudo apt install openjdk-8-jdk
sudo apt install ant
sudo apt install maven
sudo apt install build-essential
which java ant mvn g++
```

Download Joana inside java-closure directory

```
git clone ssh://git@github.com/joana-team/joana
cd joana/
git submodule init
git submodule update
```

Default setup_deps behavior to autoset params is broken
Edit setup_deps, comment out if-block and set correct values

```
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

Or copy the edited file

```
mv setup_deps setup_deps.orig
cp ../setup_deps .
```

Requires cleanup of /tmp/smoke_main

```
sudo rm /tmp/smoke_main
```
continue to run setup_deps

```
./setup_deps 
```

Force ant to use java 1.8

```
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
ant
ant doc-wala
doxygen # optional, takes a long time
```


### Download pre-built jscheme and jython

```
cd ./java-closure # Project Home Directory

wget https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.2/jython-standalone-2.7.2.jar

# jscheme is optional
wget https://sourceforge.net/projects/jscheme/files/jscheme/7.2/jscheme-7.2.jar
```



## Test Joana

```
cd testprog # From project base directory
ant
cd ..
```

### Generate SDG and Dot files for test program

```
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH="joana/dist/*:testprog/dist/*:jython-standalone-2.7.2.jar:jscheme-7.2.jar:"


# Generate the SDG
java -cp $CLASSPATH org.python.util.jython JoanaUsageExample.jy \
  -c './testprog/dist/TESTPROGRAM.jar' \
  -e 'com.peratonlabs.closure.testprog.example1.Example1' \
  -p -P 'out.pdg' \
  -d -D 'out.dot' \
  -j -J 'out.clemap.json' 

```

### Launch the viewer, open the pdg file, and interact
```
java -cp $CLASSPATH edu.kit.joana.ui.ifc.sdg.graphviewer.GraphViewer 
```

## Produce Program Partition

```
java -cp $CLASSPATH org.python.util.jython zincOuput.jy
 -m './example1/src/example1/Example1.java'
 -c './example1/dist/TESTPROGRAM.jar'   
 -e 'com.peratonlabs.closure.testprog.example1.Example1' 
 -b 'com.peratonlabs.closure.testprog' 
```

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

  Since the output of the constraint solver reports edge IDs, useful scripts are available in the java-closure/scripts directory. The edgeDbg.py scripts takes an edge ID as input and produces the debug information for the associated source and destination nodes. Similarly, getclassName.py takes a class ID and produces the correspoinding class name for the ID. Note that these scripts assume the dbg_*.csv files are in the same directory as the scripts.

## Run EOP2 Demo

Set classpath and java location.
These commands assume you are in the java-closure based directory. 

  ```
  export CLASSPATH="joana/dist/*:examples/eop2-demo//dist/*:jython-standalone-2.7.2.jar:jscheme-7.2.jar:"
  export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
  ```

Build the demo application
```
cd examples/eop2-demo/
ant
cd ../..
```

**IMPORTANT** In file 
```
java-closure/examples/eop2-demo/src/com/peratonlabs/closure/eop2/video/manager/config.java 
```
ensure that webroot is initalized to 

```
java-closure/examples/eop2-demo/resources
```

Run Conflict Analyzer
```
java -cp $CLASSPATH org.python.util.jython zincOutput.jy -m './examples/eop2-demo/src/com/peratonlabs/closure/eop2/video/manager/VideoManager.java'   -c './examples/eop2-demo/dist/TESTPROGRAM.jar' -e 'com.peratonlabs.closure.eop2.video.manager.VideoManager' -b 'com.peratonlabs.closure.eop2.'
```

The resulting cut.json will be produced in the directory the above command is invoked from.


 
