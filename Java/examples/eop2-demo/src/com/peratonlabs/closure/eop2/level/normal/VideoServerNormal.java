package com.peratonlabs.closure.eop2.level.normal;

import com.peratonlabs.closure.eop2.level.VideoServer;

import com.peratonlabs.closure.annotations.*;

public class VideoServerNormal extends VideoServer implements Runnable
{
    private static boolean started = false;
    
    @GreenPurpleConstructable
    private VideoServerNormal(int port, String webroot) {
        this.port = port;
        this.webroot = webroot;
    }
    
    @GreenPurpleCallable
    public static void startServer(int port, String webroot) {
        if (started) {
            return;
        }
        
        VideoServerNormal instance = new VideoServerNormal(port, webroot);
        Thread thread = new Thread(instance);
        thread.start();
        
        started = true;
    }
}
