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

# Launch the viewer, open the pdg file, and interact
java -cp $CLASSPATH edu.kit.joana.ui.ifc.sdg.graphviewer.GraphViewer 
```
