package com.peratonlabs.closure.testprog.example1;

import com.peratonlabs.closure.testprog.example1.Extra;
import com.peratonlabs.closure.testprog.example1.annotations.*;

public class Example1 {
  @OrangeShareable
  public static int myConstant = 777;

  private Extra extra;

  public int getValue() {
    return this.extra.getValue();
  }

  public Example1() {
    this.extra = new Extra();
  }

  @OrangeMain
  public static void main(String[] args) {
    Example1 e = new Example1();
    System.out.println("Hello Example 1: " + e.getValue());
  }
}

