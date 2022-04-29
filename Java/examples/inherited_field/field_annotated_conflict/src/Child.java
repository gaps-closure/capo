package com.peratonlabs.closure.tests;

import com.peratonlabs.closure.tests.Parent;
import com.peratonlabs.closure.tests.annotations.*;

public class Child extends Parent {

   @OrangeShareable
   protected int temp;

   @OrangePurpleConstructable
   public Child() {

   }

   @PurpleOrangeCallable
   public  int test() {
     return this.parentVal;
   }

}

