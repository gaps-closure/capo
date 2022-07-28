if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <enclave>"
  exit 1
fi

echo $1 enclave
echo ----------------

cd /tmp/xdcc/$1

CLASSPATH=\
dist/weaved-TESTPROGRAM.jar:\
dist/lib/class-scanner.jar:\
dist/lib/javax.websocket-client-api.jar:\
dist/lib/opencv-460.jar:\
dist/lib/webserver.jar:\
dist/lib/javax.websocket-server-api.jar:\
dist/lib/servlet.jar:\
dist/lib/wskt.jar:\
dist/closure-aspect.jar:\
aspect/lib/aspectjrt.jar:\
aspect/lib/gson-2.8.0.jar:\
aspect/lib/codeGen.jar:\
aspect/lib/jzmq-3.1.0.jar

JNI=java.library.path=/usr/lib/x86_64-linux-gnu/jni:/home/tchen/opencv-4.6.0/build/lib
TJWS=tjws.websocket.container=true
CFG=resources/config.json

java -cp $CLASSPATH -D$JNI -D$TJWS com.peratonlabs.closure.eop2.video.manager.VideoManager -c $CFG 
