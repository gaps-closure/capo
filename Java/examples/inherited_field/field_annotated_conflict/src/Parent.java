package com.peratonlabs.closure.tests;

import com.peratonlabs.closure.tests.annotations.*;

public class Parent {

  @Purple
   protected int parentVal;


  @PurpleOrangeConstructable
   public Parent() {
     this.parentVal = 42;
   }

   @PurpleOrangeCallable
   public  int test() {
     return parentVal;
   }
}

