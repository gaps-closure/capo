/**
 * Copyright (c) 2022 All rights reserved
 * Peraton Labs, Inc.
 *
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *
 * Jun 26, 2022
 */
package com.peratonlabs.closure.eop2.level;

import java.io.IOException;
import java.nio.ByteBuffer;

import javax.websocket.Session;

import com.peratonlabs.closure.eop2.video.requester.Request;
import com.peratonlabs.closure.eop2.video.requester.RequestHigh;

public abstract class VideoRequester
{
    protected String id;
    protected Session channel;

    // north bound
    public void send(byte[] data) {
        try {
            // the browser complains about 'invalid websocket response' if 
            // this just sends data as is or a clone of the exact size.
            byte[] dataCopy = new byte[data.length + 50480];
            System.arraycopy(data, 0, dataCopy, 0, data.length);

            if (channel == null)  // channel has been closed
               return;
            
            channel.getBasicRemote().sendBinary(ByteBuffer.wrap(dataCopy));
        }
        catch (IOException e) {
            e.printStackTrace();
            channel = null;
        }
    }
    
    protected void onMessage(Request request, Session channel) {
        String command = request.getCommand();
        if (command == null) {
            // change video quality only
            return;
        }
        switch(command) {
        case "start":
            this.channel = channel;
            break;
        case "stop":
            try {
                if (channel != null)
                    channel.close();
            }
            catch (IOException e) {
                e.printStackTrace();
            }
            finally {
                this.channel = null;
            }
            break;
        }
        System.out.println(this.getClass().getSimpleName() + ": " + command + " command processed");                        
    }

    protected void onMessageHigh(RequestHigh request, Session channel) {
        String command = request.getCommand();
        if (command == null) {
            // change video quality only
            return;
        }
        switch(command) {
        case "start":
            this.channel = channel;
            break;
        case "stop":
            try {
                if (channel != null)
                    channel.close();
            }
            catch (IOException e) {
                e.printStackTrace();
            }
            finally {
                this.channel = null;
            }
            break;
        }
        System.out.println(this.getClass().getSimpleName() + ": " + command + " command processed");                        
    }
    
    public Session getChannel() {
        return channel;
    }

    public void setChannel(Session channel) {
        this.channel = channel;
    }
}
