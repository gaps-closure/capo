package com.peratonlabs.closure.example_generic_1.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.peratonlabs.closure.example_generic_1.annotations.Cledef;
 
@Target(ElementType.METHOD)
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
                  "      \"rettaints\":[\"TAG_RESPONSE_GETVALUE\"]," +
                  "      \"codtaints\":[\"Purple\"]" +
                  "    }," + 
                  "    {" + 
                  "      \"remotelevel\":\"purple\"," + 
                  "      \"direction\":\"bidirectional\"," + 
                  "      \"guarddirective\":{" + 
                  "        \"operation\":\"allow\"" + 
                  "      }," + 
                  "      \"argtaints\":[]," +
                  "      \"rettaints\":[]," +
                  "      \"codtaints\":[\"Purple\"]" +
                  "    }" + 
                  "  ]" +
                  "}")
public @interface PurpleOrangeCallable {}

