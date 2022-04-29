package com.peratonlabs.closure.tests;

import com.peratonlabs.closure.tests.Parent;
import com.peratonlabs.closure.tests.annotations.*;

public class Child extends Parent {

   @Purple
   private int a2LUE;

   @PurpleOrangeConstructable
   public Child() {
     this.a2LUE = 42;
   }

   @OrangeMain
   public  int test() {
     return this.a2LUE;
   }
}

