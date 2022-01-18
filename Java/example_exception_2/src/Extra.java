package com.peratonlabs.closure.example_except_2;

import com.peratonlabs.closure.example_except_2.Parent;
import com.peratonlabs.closure.example_except_2.annotations.*;

public class Extra extends Parent {
   @Purple
   private int a2LUE;

   @PurpleOrangeConstructable
   public Extra() {
     this.a2LUE = 42;
   }

   @PurpleOrangeCallable
   public final int getValue(int a, int b) throws Exception{
     if (a < 0)
     {
      throw new Exception("Test 1");
     }

     if (b < 0)
     {
      throw new Exception("Test 2");
     }
     
     return this.a2LUE;
   }
}


