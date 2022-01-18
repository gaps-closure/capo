package com.peratonlabs.closure.example_except_3.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.peratonlabs.closure.example_except_3.annotations.Cledef;
 
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Cledef(clejson = "{" + 
                  "  \"level\":\"orange\"," + 
                  "  \"cdf\":[" + 
                  "    {" + 
                  "      \"remotelevel\":\"purple\"," + 
                  "      \"direction\":\"egress\"," + 
                  "      \"guarddirective\":{" + 
                  "        \"operation\":\"allow\"" + 
                  "      }" + 
                  "    }" + 
                  "  ]" + 
                  "}")
public @interface OrangeShareable {}

