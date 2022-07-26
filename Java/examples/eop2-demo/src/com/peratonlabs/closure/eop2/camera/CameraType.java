/**
 * Copyright (c) 2022 All rights reserved
 * Peraton Labs, Inc.
 *
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *
 * @author tchen
 *
 * Jun 28, 2022
 */
package com.peratonlabs.closure.eop2.camera;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

public enum CameraType {
    IP_CAMERA(0),
    WEB_CAMERA(1);
    
    private int code;

    private static final Map<Integer, CameraType> lookup = new HashMap<Integer, CameraType>();

    static {
        for (CameraType s : EnumSet.allOf(CameraType.class))
            lookup.put(s.getCode(), s);
    }

    private CameraType(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    public static CameraType get(int code) {
        CameraType type = lookup.get(code);
        if (type == null) {
            return null;
        }

        return type;
    }

    // public static CameraType get(String status) {
    //     try {
    //         Integer i = Integer.parseInt(status);
    //         return get(i);
    //     }
    //     catch (NumberFormatException e) {
    //         return null;
    //     }
    // }

    public static CameraType getByName(String status) {
        for (CameraType det : lookup.values())
            if (det.toString().equalsIgnoreCase(status))
                return det;
        
        return null;
    }
}
