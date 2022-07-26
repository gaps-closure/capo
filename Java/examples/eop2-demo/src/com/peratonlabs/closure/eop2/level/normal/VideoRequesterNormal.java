/**
 * Copyright (c) 2022 All rights reserved
 * Peraton Labs, Inc.
 *
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *
 * Jun 26, 2022
 */
package com.peratonlabs.closure.eop2.level.normal;

import java.util.HashMap;
import java.util.concurrent.LinkedBlockingQueue;

import javax.websocket.Session;

import com.peratonlabs.closure.eop2.level.VideoRequester;
import com.peratonlabs.closure.eop2.video.requester.Request;
import com.peratonlabs.closure.annotations.*;

public class VideoRequesterNormal extends VideoRequester
{
    private static boolean serverStarted = false;
    private static HashMap<String, VideoRequesterNormal> clients = new HashMap<String, VideoRequesterNormal>();
    private static LinkedBlockingQueue<Request> queue = new LinkedBlockingQueue<Request>();

    private VideoRequesterNormal(String id) {
        this.id = id;
    }
    
    // south bound from VideoEndpointNormal
    public static void handleMessage(Request request, Session channel) {
        String id = request.getId();
        VideoRequesterNormal client = clients.get(id);
        if (client == null) {
            client = new VideoRequesterNormal(id);
            clients.put(request.getId(), client);
        }
        client.onMessage(request, channel);
        
        queue.add(request); // wait for video manager to retrieve it
    }
    
    // VideoManager retrieves requests by calling this function
    @GreenPurpleCallable
    public static Request getRequest() {
        if (!queue.isEmpty()) {
            try {
                Request request = queue.take();
                return request;
            }
            catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
    
    // north bound from VideoManager
    @GreenPurpleCallable
    public static void start(int port, String webroot) {
        if (serverStarted)
            return;
        
        VideoServerNormal.startServer(port, webroot);
        serverStarted = true;
    }
    
    // north bound from Transcoder
    @GreenPurpleCallable
    public static void send(String id, byte[] data) {
        VideoRequesterNormal client = clients.get(id);
        if (client == null) {
            System.err.println("no such client: " + id);
            return;
        }
        client.send(data);
    }
}
