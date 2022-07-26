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
package com.peratonlabs.closure.eop2.video.requester;

import javax.websocket.DecodeException;
import javax.websocket.Decoder;
import javax.websocket.EndpointConfig;

import com.google.gson.Gson;

public class RequestDecoderHigh implements Decoder.Text<RequestHigh> {

    private static Gson gson = new Gson();

    @Override
    public RequestHigh decode(String s) throws DecodeException {
        return gson.fromJson(s, RequestHigh.class);
    }

    @Override
    public boolean willDecode(String s) {
        return (s != null);
    }

    @Override
    public void init(EndpointConfig endpointConfig) {
        // Custom initialization logic
    }

    @Override
    public void destroy() {
        // Close resources
    }
}
