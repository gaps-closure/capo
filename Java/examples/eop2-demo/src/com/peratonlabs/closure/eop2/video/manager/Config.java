/*******************************************************************************
 * Copyright (c) 2018 Perspecta Labs Inc  - All Rights Reserved.
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *  
 * @author tchen
 *******************************************************************************/
package com.peratonlabs.closure.eop2.video.manager;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;
import com.peratonlabs.closure.eop2.camera.CameraType;

import java.io.FileNotFoundException;
import java.io.FileReader;

public class Config
{
    private CameraType cameraType = CameraType.WEB_CAMERA;
    private String cameraAddr = "127.0.0.1";
    private String cameraUser = "admin";
    private String cameraPassword = "Boosters";
    private int cameraDevId = 0;
    
    private String webroot = "/home/tchen/eop2/eop2-demo/resources";
    private int normalPort = 8080; 
    private int highPort = 8081; 
    
    public Config() {
        // KEEP this to make sure default values are used if they are not specified in the json file.
    }
    
    public static Config load(String jsonFile) {
        try {
            JsonReader reader = new JsonReader(new FileReader(jsonFile));
            return new Gson().fromJson(reader, Config.class);
        }
        catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public CameraType getCameraType() {
        return cameraType;
    }

    public void setCameraType(CameraType cameraType) {
        this.cameraType = cameraType;
    }

    public String getCameraAddr() {
        return cameraAddr;
    }

    public void setCameraAddr(String cameraAddr) {
        this.cameraAddr = cameraAddr;
    }

    public String getCameraUser() {
        return cameraUser;
    }

    public void setCameraUser(String cameraUser) {
        this.cameraUser = cameraUser;
    }

    public String getCameraPassword() {
        return cameraPassword;
    }

    public void setCameraPassword(String cameraPassword) {
        this.cameraPassword = cameraPassword;
    }

    public int getCameraDevId() {
        return cameraDevId;
    }

    public void setCameraDevId(int cameraDevId) {
        this.cameraDevId = cameraDevId;
    }

    public String getWebroot() {
        return webroot;
    }

    public void setWebroot(String webroot) {
        this.webroot = webroot;
    }

    public int getNormalPort() {
        return normalPort;
    }

    public void setNormalPort(int normalPort) {
        this.normalPort = normalPort;
    }

    public int getHighPort() {
        return highPort;
    }

    public void setHighPort(int highPort) {
        this.highPort = highPort;
    }
}
