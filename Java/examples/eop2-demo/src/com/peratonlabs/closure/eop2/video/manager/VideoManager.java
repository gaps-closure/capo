/**
 * Copyright (c) 2022 All rights reserved
 * Peraton Labs, Inc.
 *
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *
 * Jun 23, 2022
 */
package com.peratonlabs.closure.eop2.video.manager;

import java.util.HashMap;

import org.opencv.core.Mat;

import com.peratonlabs.closure.eop2.camera.CameraReader;
import com.peratonlabs.closure.eop2.camera.CameraType;
import com.peratonlabs.closure.eop2.level.high.VideoRequesterHigh;
import com.peratonlabs.closure.eop2.level.normal.VideoRequesterNormal;
import com.peratonlabs.closure.eop2.transcoder.Transcoder;
import com.peratonlabs.closure.eop2.video.requester.Request;
import com.peratonlabs.closure.eop2.video.requester.RequestHigh;
import com.peratonlabs.closure.annotations.*;

public class VideoManager
{
    private static HashMap<String, Transcoder> transcoders = new HashMap<String, Transcoder>();
    
    private static VideoManager instance;
    private static CameraReader camera;
    
    private Config config;

    public static void main(final String[] args) {
        VideoManager manager = VideoManager.getInstance();
        manager.getOpts(args);
        
        manager.loop();
    }
    
    public void loop() {
        VideoRequesterHigh.start(config.getHighPort(), config.getWebroot());
        VideoRequesterNormal.start(config.getNormalPort(), config.getWebroot());
        
        while (true) {
            RequestHigh requestHigh = VideoRequesterHigh.getRequest();
            handleRequestHigh(true, requestHigh);
            
            Request request = VideoRequesterNormal.getRequest();
            handleRequest(false, request);
            
            try {
                Thread.sleep(1000);
            }
            catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
    
    // from VideoRequester
    public static void handleRequest(boolean high, Request request) {
        if (request == null) {
            return;
        }
        
        String id = request.getId();
        Transcoder transcoder = transcoders.get(id);
        if (transcoder == null) {
            transcoder = new Transcoder(high, id);
            transcoders.put(id, transcoder);
        }
        
        String cmd = request.getCommand();
        if (cmd == null) {
            // Do permission checking here
            updateRequest(transcoder, request);
        }
        else {
            runCommand(transcoder, request);
        }
    }

    // from VideoRequester
    public static void handleRequestHigh(boolean high, RequestHigh request) {
        if (request == null) {
            return;
        }
        
        String id = request.getId();
        Transcoder transcoder = transcoders.get(id);
        if (transcoder == null) {
            transcoder = new Transcoder(high, id);
            transcoders.put(id, transcoder);
        }
        
        String cmd = request.getCommand();
        if (cmd == null) {
            // Do permission checking here
            updateRequestHigh(transcoder, request);
        }
        else {
            runCommandHigh(transcoder, request);
        }
    }
    
    private static void updateRequest(Transcoder transcoder, Request request) {
        transcoder.getRequest().update(request);
    }

    private static void updateRequestHigh(Transcoder transcoder, RequestHigh request) {
        transcoder.getRequestHigh().update(request);
    }
    
    private static void runCommand(Transcoder transcoder, Request request) {
        String command = request.getCommand();
        if (command == null) {
            System.err.println("VideoManager: null command for " + request.getId());
            return;
        }
        switch(command) {
        case "start":
            transcoder.start();
            startCamera();
            break;
        case "stop":
            transcoder.interrupt();
            transcoders.remove(request.getId());
            stopCamera();
            break;
        }
        System.out.println("VideoManager: " + command + " command processed");                        
    }

    private static void runCommandHigh(Transcoder transcoder, RequestHigh request) {
        String command = request.getCommand();
        if (command == null) {
            System.err.println("VideoManager: null command for " + request.getId());
            return;
        }
        switch(command) {
        case "start":
            transcoder.start();
            startCamera();
            break;
        case "stop":
            transcoder.interrupt();
            transcoders.remove(request.getId());
            stopCamera();
            break;
        }
        System.out.println("VideoManager: " + command + " command processed");                        
    }
    
    // public static void removeClient(Request request) {
    //     removeClient(request.getId());
    // }
    
    // public static void removeClient(String id) {
    //     Transcoder transcoder = transcoders.remove(id);
    //     transcoder.interrupt();
    // }

    public static void broadcast(Mat mat) {
        for (Transcoder transcoder : transcoders.values()) {
            transcoder.add(mat);
        }
    }
    
    public static VideoManager getInstance() {
        if (instance == null) {
            instance = new VideoManager();
        }
        return instance;
    }

    public static void startCamera() {
        if (camera != null)
            return;
            
        VideoManager manager = VideoManager.getInstance();
        Config config = manager.getConfig();
        camera = new CameraReader(config);
        camera.start();
        
        System.out.println("Camera started");
    }
    
    public static void stopCamera() {
        if (!transcoders.isEmpty())
            return;
        
        if (camera == null)
            return;
        
        camera.interrupt();
        camera = null;
        
        System.out.println("Camera stopped");
    }
    
    private void getOpts(String[] args) {
        String arg;
        
        for (int i = 0; i < args.length; i++) {
            arg = args[i];
            switch (arg) {
            case "--cameraType":
            case "-t":
                if (config == null) {
                    config = new Config();
                }
                config.setCameraType(CameraType.getByName(args[++i]));
                break;
            case "--cameraAddr":
            case "-a":
                if (config == null) {
                    config = new Config();
                }
                config.setCameraAddr(args[++i]);
                break;
            case "--cameraDev":
            case "-d":
                if (config == null) {
                    config = new Config();
                }
                config.setCameraDevId(Integer.parseInt(args[++i]));
                break;
            case "--webRoot":
            case "-w":
                if (config == null) {
                    config = new Config();
                }
                config.setWebroot(args[++i]);
                break;
            case "--config":
            case "-c":
                if (config != null) {
                    System.err.println("WARNING: command line arguments specified before -c will be overriden by those in " + args[i + 1]);
                }
                config = Config.load(args[++i]);
                break;
            default:
                System.err.println("unknown option: " + arg);
                break;
            }
        }
        if (config == null) {  // all defaults
            config = new Config();
        }
    }

    public Config getConfig() {
        return config;
    }
}
