# CLOSURE Workflow for Java

## Annotation

* The CDS developer using CLOSURE needs to know `com.peratonlabs.closure.cle.Cledef` as well as the CLE-JSON schema
* Developer creates a copy of the application for CLOSURE annotations
* Developer defines a number of CLE annotations relevant for the application, which are in turn are annotated using Cledef, which will associate a CLE-JSON with that annotation
* Developer applies annotations to application source to capture cross-domain partitioning intent

## Conflict Analyzer

* Developer runs conflict analyzer on annotated application source code
* Output of conflict analyzer is one of:
  - failure, with description of conflict plus developer refactoring guidance to mitigate conflict
  - success, with a output `topology.json`
     -- every application class is assigned to a unique enclave or to a library common to all enclaves
     -- identifies methods and constructors that are in the cross-domain cut

```
"assignment": [
   { "class" : "A",
     "enclave": "Purple",
   },
     ...
 ],
"cut": [
  { "method-signature" : "methodFoo(type1 arg1,...)",
    "caller-level" : [ "Orange", "Red" ],
    "caller-type" : [ "Foo", "Bar"],
    "callee-level": [ "Purple" ]
    "callee-type": [ "A" ]
  }
  // need to know class or instance methods, each parameter needs to be in, out or in-out.
  // need to know size and max size of a collection.
]
```

## GEDL Program Analyzer

* For each method in the cut, for each parameter infer direction and (collection) size; also infer structure of the object via reflection
  - output .GEDL file contains the method signatures and inferred information for each method in the cut
 
## Autogeneration and Refactoring

* Replace method and constructor calls with RPC using aspects -- could be AIDL, CLOSURE HAL, or other
* Generate main class plus code for RPC handling on remote side
* Generate code for un/marshalling and serialization which will be invoked by the RPC call and handler
* Filtering and access violation checks
* DFDL of cross-domain datatypes
* DAGR for cross-domain rules

## Aspect Design and Paritioning Scheme/Glue

* Create a copy of the annotated code (that passed conflict analyzer checks) without modifications for each enclave
* All behavior modifications and new functionality will be introduced through aspects
* Autogenerate context which will specify the enclave, e.g., CLOSUREContext.myEnclave()

* For each class that is assigned to a different enclave
  - create a pointcut that traps constructor and method _calls_ and replaces them with RPC
  - create a pointcut that traps constructor and method _executions_ calls and generates a violation exception (execution must happen on remote side)
  - create a pointcut that traps all field accesses and generates a violation exception (field access must happen remotely)
  - developer must refactor field access using setters and getters to ensure cross-domain RPC

* new():
  - Upon instantiation, the aspect on caller side generates an ID, and sends it remote side for object creation, and stores the ID
    association with local ("shadow") object
  - The RPC handler on the callee side instantiates the object and maintains an association with the caller provied ID 

* finalize():
  - the aspect on caller side traps the finalize (on the shadow object) and sends the ID to the remote side 
  - the handler on calee side must release its references to the actual object corresponding to the ID

* method invocations (both declared and inherited):
  - the aspect on caller side must send the ID, the methodName, and the arguments in an RPC to the remote side (after marshalling
    and serialization); if not oneway, caller should wait for a response, and desrialize/unmarshall response into output parameters
    and return value -- caller must generate a request ID and check response matches request
    -- based on annotation, ought to also handle distribution issues such as retries upon delay/loss, deduplication, subject to 
       function semantics such as idempotency or caching
  - the handler on the callee side should deserialize/unmarshall, lookup the object from the ID, invoke the method, marshall/serialize
    the output parameters and return value
  - for any methods on the object that are not in the cut, the caller side must trap and generate exception

* The caller side aspects for new(), finalize(), and method invocation, should call an optional access-control/filter stub 
  - this function is normally done by CDG, but for signal app, we will generate this logic later
    (check needs <mux,sec,typ> tag, caller level, callee level in addition to object and stub must be calle with this info)

* Additional support classes to create remote main with handler threads
  - Maintain map of remote object ID to local memory reference
  - handle incoming messages and dispatch methods with (unmarshalled) parameters to relevant object
 
* Additional support calles for software content filtering (e.g., Signal app)
  - Based on CLE JSON do allow, block, redact processing 
  - Make it configurable on whether RPC call or RPC handler does the filtering (egress vs. ingress vs. neither)

