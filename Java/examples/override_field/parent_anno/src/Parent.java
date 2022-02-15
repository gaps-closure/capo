package com.peratonlabs.closure.tests;

import com.peratonlabs.closure.tests.annotations.*;

public class Parent {

  @Purple
   protected int temp;


  @PurpleOrangeConstructable
   public Parent() {
     this.temp = 42;
   }

   @PurpleOrangeCallable
   public  int test() {
     return temp;
   }
}
