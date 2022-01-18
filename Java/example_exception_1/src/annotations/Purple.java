package com.peratonlabs.closure.example_except_1.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.peratonlabs.closure.example_except_1.annotations.Cledef;
 
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Cledef(clejson = "{" + 
                  "  \"level\":\"purple\"" + 
                  "}")
public @interface Purple {}

