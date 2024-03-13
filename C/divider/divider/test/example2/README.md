This example is a GAPS/CLOSURE use case for a simple single-domain Java 
application, cross-domain paritioning and data sharing policies, and
CLE annotations that express that intent on the Java application source code.

===

classes
fields,  on which data sharing policies may apply
methods, some of which may be called XD
inheritance in subclasses
  - annotated methods are overridden and reannotated
  - non-annotated methods are overridden and annotated 
  - steps in class hierarchy without overriding
use of generics 
  - ArrayList<T> is not shareable, but average can be shared, T can be int or double

===

//orange
class Foobar<T> {
 // orange, not shareable
 private ArrayList<T> myreadings;
 public <T> getNth(int n) {
   // return nth entry of myreadings
 }
 public <T> getAverage() {
   return AggregUtils<T>().average(this.myreadings);
 }
}

//green
class Client {
 public static void main(String[] args) {
   Foobar<double> x = Foobar<double>();  // <== resolvable by refactoring, move to orange side
   System.out.println(x.getNth());       // <== unresolvable conflict, value cannot be available to println on green side
   System.out.println(x.getAverage());   // <== resolvable by RPC
 }
}

//orange
class ClientShadow {
  Foobar<double> x;
  ClientShadow() {
    Foobar<double> x = Foobar<double>(); 
  }
}

Class AggregUtils<T> {
 // rettaint shareable
 // argtaint notshareable
 public static <T> average(ArrayList<T> invector) {
  double ret = 0.0;
  if <T> is not int or float throw exception
  for (T y : invector) {
    ret += (double) y;
  }
  return (<T>) ret / invector.length();
 }
}

===
* Fields and methods may be annotated
* Overridden members must be reannotated, and inherited ancestral members will also inherit the annotation
* Variants of a polymorphic method may require different CLEJSON for annotation

* In a valid partitioning:
  - control can flow between enclaves only through XD RPC of blessed methods
  - data can flow between enclaves only through parameters/return of XD RPC of blessed methods
  - all fields and methods of any given instance must have the same level
  - all instances of a class with an annotated method must be at the same level
  - any label coercion can occur only through blessed methods
  - when method annotation is overridden, access the superclasses' method from the instance method can result in conflict

===
