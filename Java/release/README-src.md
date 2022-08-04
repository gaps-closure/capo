# Java Closure Source Release
## Contents:

* [Start the Docker Image](#start-the-docker-image)
* [Install and Build Joana](#install-and-build-joana)
* [Build the Demo Application](#build-the-demo-application)
* [Run the Conflict Analyzer](#run-the-conflict-analyzer)
* [Build HAL](#build-hal)
* [Build Code Generator](#build-code-generator)
* [Partition the Demo Application](#partition-the-demo-application)
* [Run the Demo Application](#run-the-demo-application)

## Start the Docker Image
    $ docker run -ti --device /dev/video0 closure:src
            
where closure:src is the docker repository and tag of the image and /dev/video0 is the device file for the camera on the host.

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

  If the program is properly annotated, a cut.json file is produced showing the class assignments to each enclave and the methods in the cut.

    $ cp cut.json $HOME/gaps/CodeGenJava/test
  
### Build HAL
    $ cd $HOME/gaps/hal
    $ make   
      
### Build Code Generator
    $ cd $HOME/gaps/CodeGenJava
    $ ant

### Partition the Demo Application
    $ cd $HOME/gaps/CodeGenJava
    $ java -jar code-gen/code-gen.jar
  
### Run the Demo Application
    $ cd $HOME/gaps
    $ ./run.sh
    
Once started, there will be three sets of terminals, from left to right, one for each of the Purple, Orange and Green partitions. Within each partition, the top terminal is the output for HAL and the bottom one for the Java app.  
Wait until the Purple enclave (the leftmost one) is ready and sending messages to the other enclaves. Then on the host of the container, start a browser and go to the URL http://172.17.0.2:8080/.

    host$ firefox http://172.17.0.2:8080/

Click on the Play button. The camera image should appear in the browser at this point.

