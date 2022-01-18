package com.peratonlabs.closure.example_generic_1;

import com.peratonlabs.closure.example_generic_1.Extra;
import com.peratonlabs.closure.example_generic_1.annotations.*;

public class Example_Generic_1 {
  @OrangeShareable
  public static int myConstant = 777;

  private Extra extra;

  public int getValue() {
    return this.extra.getValue();
  }

  public Example_Generic_1() {
    this.extra = new Extra();
  }

  @OrangeMain
  public static void main(String[] args) {
    Example_Generic_1 e = new Example_Generic_1();
    System.out.println("Hello Example 1: " + e.getValue());
  }
}

