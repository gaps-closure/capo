package com.peratonlabs.closure.eop2.level.high;

import com.peratonlabs.closure.eop2.level.VideoServer;

import com.peratonlabs.closure.annotations.*;

public class VideoServerHigh extends VideoServer implements Runnable
{
    private static boolean started = false;
    
    @OrangePurpleConstructable
    private VideoServerHigh(int port, String webroot) {
        this.port = port;
        this.webroot = webroot;
    }
    
    @OrangePurpleCallable
    public static void startServer(int port, String webroot) {
        if (started) {
            return;
        }
        
        VideoServerHigh instance = new VideoServerHigh(port, webroot);
        Thread thread = new Thread(instance);
        thread.start();
        
        started = true;
    }
}
