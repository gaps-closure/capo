# (DRAFT) C Language Recommendations for CLOSURE CAPO Analyses (DRAFT)

## Roadmap for Formalizing CAPO Requirements
* Documentation of supported C language subset, types of cross-domain conflicts identified, and partitioning methodology.
* Flesh out C exemplars for the methodologies.
* Make sure partitioner can handle these exemplars (identify and guide refactoring of cross-domain conflicts).
* Create more exemplars of the same class (complexity, constructs) and rerun through partitioner to evaluate generality.
* Advanced exemplars for next level of complexity.

## Supported Types for Cross-Domain Data
* All non-pointer basic types (signed and unsigned variants)
```c
int      float    char   
double   short    long
```
* Structures compposed of basic types
```c
struct {
}
```
* Arrays of basic types

## Supported Program Complexity
* Deterministic programs 
* Single thread of control
* Functions
   * Can we handle data of different enclaves in same functions?
   * Are there restrictions on the function arguments?
      * Do we support call-by-reference and/or call-by-value?
      
## Supported Annotations
* Variables
  * Heap
  * Static
* Functions
* Global Variables

  <i>Note: Need clear understanding of the relationship between typing and annotations. Typing adds additional context to the variable, (e.g.) an annotated `int` is no longer simply `int`, it's an `int` with cross-domain context. This needs to factor into the anlaysis and verification steps. 
  </i>
  
## Program Exemplars For Comprehensive Usage of Suppoted C-Spec
* [CLOSURE C Programming Exemplars](github.com/build/apps/c-exemplars) (TODO)

## Partitioning Methodology
* Synchronous RPC 
   * Needed for program equivalence verification
     * Preserves determinism
   * Requires bi-directional communication
* Asynchronous RPC
   * Can be utilized in 1-way diode configurations, supports uni-directional communication
