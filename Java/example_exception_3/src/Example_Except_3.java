package com.peratonlabs.closure.example_except_3;

import com.peratonlabs.closure.example_except_3.Extra;
import com.peratonlabs.closure.example_except_3.annotations.*;

public class Example_Except_3 {
  @OrangeShareable
  public static int myConstant = 777;

  private Extra extra;

  public int getValue() {
    int a = 1;
    int b = 2;
    try
    {
      return this.extra.getValue(a,b);
    }
    catch(ArithmeticException e)
    {
      return 0;
    }
    catch(ArrayIndexOutOfBoundsException e)
    {
      return 1;
    }
  }

  public Example_Except_3() {
    this.extra = new Extra();
  }

  @OrangeMain
  public static void main(String[] args) {
    Example_Except_3 e = new Example_Except_3();
    System.out.println("Hello Example 1: " + e.getValue());
  }
}

