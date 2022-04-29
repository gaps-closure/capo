package com.peratonlabs.closure.tests;

import com.peratonlabs.closure.tests.Parent;
import com.peratonlabs.closure.tests.annotations.*;

public class Child extends Parent {

  //  @Purple
   protected int temp;

   @PurpleOrangeConstructable
   public Child() {
     this.temp = 42;
   }

   @PurpleOrangeCallable
   public  int test() {
     return this.temp;
   }

}

