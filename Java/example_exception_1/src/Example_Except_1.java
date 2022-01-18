package com.peratonlabs.closure.example_except_1;

import com.peratonlabs.closure.example_except_1.Extra;
import com.peratonlabs.closure.example_except_1.annotations.*;

public class Example_Except_1 {
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
    catch(Exception e)
    {
      return 0;
    }
  }

  public Example_Except_1() {
    this.extra = new Extra();
  }

  @OrangeMain
  public static void main(String[] args) {
    Example_Except_1 e = new Example_Except_1();
    System.out.println("Hello Example 1: " + e.getValue());
  }
}

