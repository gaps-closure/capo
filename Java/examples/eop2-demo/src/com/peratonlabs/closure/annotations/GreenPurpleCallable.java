package com.peratonlabs.closure.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Cledef(clejson = "{" + 
                  "  \"level\":\"green\"," + 
                  "  \"cdf\":[" + 
                  "    {" + 
                  "      \"remotelevel\":\"purple\"," + 
                  "      \"direction\":\"bidirectional\"," + 
                  "      \"guarddirective\":{" + 
                  "        \"operation\":\"allow\"" + 
                  "      }," + 
                  "      \"argtaints\":[]," +
                  "      \"rettaints\":[\"TAG_RESPONSE_GETVALUE\"]," +
                  "      \"codtaints\":[\"Green\"]" +
                  "    }," + 
                                    "    {" + 
                  "      \"remotelevel\":\"green\"," + 
                  "      \"direction\":\"bidirectional\"," + 
                  "      \"guarddirective\":{" + 
                  "        \"operation\":\"allow\"" + 
                  "      }," + 
                  "      \"argtaints\":[]," +
                  "      \"rettaints\":[\"TAG_RESPONSE_GETVALUE\"]," +
                  "      \"codtaints\":[\"Green\"]" +
                  "    }" + 
                  "  ]" +
                  "}")
public @interface GreenPurpleCallable {}

