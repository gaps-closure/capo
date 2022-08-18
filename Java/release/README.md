# GAPS/CLOSURE Binary Release

A Docker image with Ubuntu 20.04 LTS and the necessary packages to run the CLOSURE end-of-phase2 Java demo

## Start the Image
    $ docker run -ti --device /dev/video0 closure:bin ./run.sh
            
where closure:bin is the repository and tag of the docker image and /dev/video0 is the device file for the camera on the host. 
Once started, there will be three sets of terminals, from left to right, one for each of the Purple, Orange and Green partitions. Within each partition, the top terminal is the output for HAL and the bottom one for the Java app.  
Wait until the Purple enclave (the leftmost one) is ready and sending messages to the other enclaves. 

## Start Browser
On the host of the container, start a browser and go to the URL http://172.17.0.2:8080/. 

    $ firefox http://172.17.0.2:8080/

Click on the Play button. The camera image should appear in the browser at this point.
    