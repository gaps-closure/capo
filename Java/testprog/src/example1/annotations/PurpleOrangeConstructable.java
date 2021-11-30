package com.peratonlabs.closure.testprog.example1.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.peratonlabs.closure.testprog.example1.annotations.Cledef;
 
@Target(ElementType.CONSTRUCTOR)
@Retention(RetentionPolicy.RUNTIME)
@Cledef(clejson = "{" + 
                  "  \"level\":\"purple\"," + 
                  "  \"cdf\":[" + 
                  "    {" + 
                  "      \"remotelevel\":\"orange\"," + 
                  "      \"direction\":\"bidirectional\"," + 
                  "      \"guarddirective\":{" + 
                  "        \"operation\":\"allow\"" + 
                  "      }," + 
                  "      \"argtaints\":[]," +
                  "      \"rettaints\":[\"TAG_RESPONSE_EXTRA\"]," +
                  "      \"codtaints\":[\"com.peratonlabs.closure.testprog.example1.annotations.Purple\"]" +
                  "    }" + 
                  "  ]" +
                  "}")
public @interface PurpleOrangeConstructable {}

