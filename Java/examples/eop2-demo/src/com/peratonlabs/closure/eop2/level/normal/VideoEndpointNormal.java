/**
 * Copyright (c) 2022 All rights reserved
 * Peraton Labs, Inc.
 *
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *
 * @author tchen
 *
 * Jul 2, 2022
 */
package com.peratonlabs.closure.eop2.level.normal;

import java.io.IOException;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import com.peratonlabs.closure.eop2.video.requester.Request;
import com.peratonlabs.closure.eop2.video.requester.RequestDecoder;
import com.peratonlabs.closure.eop2.video.requester.RequestEncoder;

@ServerEndpoint( 
    value="/video/{id}", 
    decoders = RequestDecoder.class, 
    encoders = RequestEncoder.class )
public class VideoEndpointNormal 
{
    String id;
    
    @OnOpen
    public void onOpen(
      Session session, 
      @PathParam("id") String id) throws IOException {
        this.id = id;
        System.out.println(id + " connected");
    }

    @OnMessage
    public void onMessage(Session session, Request request) 
      throws IOException {
        System.out.println("VideoEndpointNormal: " + request.toJson());
        VideoRequesterNormal.handleMessage(request, session);
    }

    @OnClose
    public void onClose(Session session) throws IOException {
        System.out.println(id + " disconnected");
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Do error handling here
    }
}
