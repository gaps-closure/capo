# Steps to set up JOANA for Program Analysis

```
################################################################################
# Install JOANA and dependencies
################################################################################
cd ~/gaps
git clone ssh://git@github.com/gaps-closure/java-closure.git
cd java-closure/

# Make sure ant, java, mvn, g++ are installed -- install if needed
# JOANA really wants Java 1.8, build fails with higher versions
sudo apt install openjdk-8-jdk
sudo apt install ant
sudo apt install maven
sudo apt install build-essential
which java ant mvn g++

git clone ssh://git@github.com/joana-team/joana
cd joana/
git submodule init
git submodule update

# Default setup_deps behavior to autoset params is broken
# Edit setup_deps, comment out if-block and set correct values
# export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
# export PATH=$JAVA_HOME/bin:$PATH
# Or copy the edited file
mv setup_deps setup_deps.orig
cp ../setup_deps .
# Requires cleanup of /tmp/smoke_main
sudo rm /tmp/smoke_main
# continue to run setup_deps
./setup_deps 

# Force ant to use java 1.8, JOANA really needs this version
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
ant
ant doc-wala
doxygen # optional, takes a long time

################################################################################
# Download pre-built jscheme and jython
################################################################################
cd ..
# jscheme is optional
wget https://sourceforge.net/projects/jscheme/files/jscheme/7.2/jscheme-7.2.jar
wget https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.2/jython-standalone-2.7.2.jar

################################################################################
# Build the test program for analysis
################################################################################
cd testprog
ant
cd ..

################################################################################
# Generate SDG and Dot files for test program
################################################################################
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH="joana/dist/*:testprog/dist/*:jython-standalone-2.7.2.jar:jscheme-7.2.jar:"
# jscheme is optional
java -cp $CLASSPATH jscheme.REPL JoanaUsageExample.scm -main main

# Generate the SDG
java -cp $CLASSPATH org.python.util.jython JoanaUsageExample.jy \
  -c './testprog/dist/TESTPROGRAM.jar' \
  -e 'com.peratonlabs.closure.testprog.example1.Example1' \
  -p -P 'out.pdg' \
  -d -D 'out.dot' \
  -j -J 'out.clemap.json' 

java -cp $CLASSPATH org.python.util.jython JoanaUsageExample.jy \
  -c './example_exception_1/dist/EXAMPLE_EXCEPT_1.jar' \
  -e 'com.peratonlabs.closure.example_except_1.Example_Except_1' \
  -p -P 'out.pdg' \
  -d -D 'out.dot' \
  -j -J 'out.clemap.json' 

# Launch the viewer, open the pdg file, and interact
java -cp $CLASSPATH edu.kit.joana.ui.ifc.sdg.graphviewer.GraphViewer 
```


################################################################################
# Evaluate CLE Annotations and Produce Program Partition
################################################################################

java -cp $CLASSPATH org.python.util.jython zincOuput.jy
 -m './example1/src/example1/Example1.java'
 -c './example1/dist/TESTPROGRAM.jar'   
 -e 'com.peratonlabs.closure.testprog.example1.Example1' 
 -b 'com.peratonlabs.closure.testprog' 
 -p -P 'output.pdg'


  the -m option indicates what java file has the main class to analyze
  the -c option indicates the jar file to analyze
  the -e option indicates the class with the entry method
  the -b option indicates the prefix for the classes that are of interest
  the -p option indicates the 

  Running this command will result in the following artifacts to be generated
  
  * enclave_instance.mzn
  * pdg_instance.mzn
  * cle_instance.mzn
  * cut.json
  * dbg_edge.csv
  * dbg_node.csv

  The dbg_edge.csv and dbg_node.csv files report useful information about all of the nodes and edges in the SDG being analyzed that can be useful to debug and find issues with annotations

  The three .mzn files are what get fed to minizinc along with the .mzn files in the constraints/ directory to check if the program is properly annotated.

  If the program is properly annotated, a cut.json file is produced showing the class assingments to each enclave and the methods in the cut.
 