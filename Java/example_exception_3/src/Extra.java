package com.peratonlabs.closure.example_except_3;

import com.peratonlabs.closure.example_except_3.Parent;
import com.peratonlabs.closure.example_except_3.annotations.*;

public class Extra extends Parent {
   @Purple
   private int a2LUE;

   @PurpleOrangeConstructable
   public Extra() {
     this.a2LUE = 42;
   }

   @PurpleOrangeCallable
    public final int getValue(int a, int b) throws ArithmeticException, ArrayIndexOutOfBoundsException{
     if (a < 0)
     {
      throw new ArithmeticException("Test 1");
     }

     if (b < 0)
     {
      throw new ArrayIndexOutOfBoundsException("Test 2");
     }
     
     return this.a2LUE;
   }
}

