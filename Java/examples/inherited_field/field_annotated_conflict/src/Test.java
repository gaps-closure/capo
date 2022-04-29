package com.peratonlabs.closure.tests;

import com.peratonlabs.closure.tests.Child;
import com.peratonlabs.closure.tests.annotations.*;

public class Test {
  public static int myConstant = 777;

  private Child child;

  public int testMain() {
    return this.child.test();
  }

  public Test() {
    this.child = new Child();
  }

 
  public static void main(String[] args) {
    Test e = new Test();
    System.out.println("Hello Example 1: " + e.testMain());
  }
}

