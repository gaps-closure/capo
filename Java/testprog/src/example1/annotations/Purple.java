package com.peratonlabs.closure.testprog.example1.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.peratonlabs.closure.testprog.example1.annotations.Cledef;
 
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Cledef(clejson = "{" + 
                  "  \"level\":\"purple\"" + 
                  "}")
public @interface Purple {}

