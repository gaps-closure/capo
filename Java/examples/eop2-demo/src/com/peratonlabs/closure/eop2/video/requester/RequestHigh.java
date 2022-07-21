package com.peratonlabs.closure.eop2.video.requester;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class RequestHigh
{
    private String id;
    private String command;
    
    private int frameRate;
    private long delay;
    private boolean color = true;
    private boolean blur;
    private boolean scale;
    private int scalePercentage;
    
    private static Gson gson = new GsonBuilder()
//            .registerTypeAdapterFactory(typeAdapterFactory)
            .setPrettyPrinting()
            .create();
    
    public RequestHigh(String id) {
        this.id = id;
    }
    
    public static RequestHigh fromJson(String json) {
        return gson.fromJson(json, RequestHigh.class);
    }
    
    public void update(RequestHigh request) {
        this.frameRate = request.frameRate;
        this.delay = request.delay;
        this.color = request.color;
        this.blur = request.blur;
        this.scale = request.scale;
        this.scalePercentage = request.scalePercentage;
    }
    
    public String toJson() {
        return gson.toJson(this, getClass());
    }

    public Integer getFrameRate() {
        return frameRate;
    }

    public void setFrameRate(int frameRate) {
        this.frameRate = frameRate;
    }

    public long getDelay() {
        return delay;
    }

    public void setDelay(long delay) {
        this.delay = delay;
    }

    public boolean isColor() {
        return color;
    }

    public void setColor(boolean color) {
        this.color = color;
    }

    public boolean isBlur() {
        return blur;
    }

    public void setBlur(boolean blur) {
        this.blur = blur;
    }

    public boolean isScale() {
        return scale;
    }

    public void setScale(boolean scale) {
        this.scale = scale;
    }

    public int getScalePercentage() {
        return scalePercentage;
    }

    public void setScalePercentage(int scalePercentage) {
        this.scalePercentage = scalePercentage;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCommand() {
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }
}
