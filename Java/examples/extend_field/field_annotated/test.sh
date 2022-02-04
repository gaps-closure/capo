#!/bin/bash
export CLASSPATH="../../../joana/dist/*:./dist/*:jython-standalone-2.7.2.jar:jscheme-7.2.jar:"
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ant
java -cp $CLASSPATH org.python.util.jython zincOuput.jy -m './src/Test.java' -t './'   -c './dist/TESTPROGRAM.jar'   -e 'com.peratonlabs.closure.tests.Test' -b 'com.peratonlabs.closure.tests' -p -P 'current.pdg'
# minizinc --solver Gecode ./*.mzn ./constraints/*.mzn

# minizinc --solver Findmus --depth 3 --output-json ./constraints/*.mzn ./*.mzn > result.txt