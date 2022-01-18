package com.peratonlabs.closure.example_except_2.annotations;
 
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
 
@Target(ElementType.ANNOTATION_TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Cledef 
{
    String clejson() default "";
    boolean isFile() default false;
}
