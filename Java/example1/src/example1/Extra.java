package com.peratonlabs.closure.testprog.example1;

import com.peratonlabs.closure.testprog.example1.Parent;
import com.peratonlabs.closure.testprog.example1.annotations.*;

public class Extra extends Parent {
   @Purple
   private int a2LUE;

   @PurpleOrangeConstructable
   public Extra() {
     this.a2LUE = 42;
   }

   @PurpleOrangeCallable
   public final int getValue() {
     return this.a2LUE;
   }
}

