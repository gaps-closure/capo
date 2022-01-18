package com.peratonlabs.closure.example_except_2;

import com.peratonlabs.closure.example_except_2.Extra;
import com.peratonlabs.closure.example_except_2.annotations.*;

public class Example_Except_2 {
  @OrangeShareable
  public static int myConstant = 777;

  private Extra extra;

  public int getValue()throws Exception {
    int a = 1;
    int b = 2;
    return this.extra.getValue(a,b);
  }

  public Example_Except_2() {
    this.extra = new Extra();
  }

  @OrangeMain
  public static void main(String[] args) {
    Example_Except_2 e = new Example_Except_2();
    try
    {
      System.out.println("Hello Example 2: " + e.getValue());
    }
    catch(Exception ex)
    {
      return  ;
    }
    
  }
}

