/* Variables from annotated LLVM IR instance */
enum Vertices;
enum Enclaves;
array[Vertices] of bool: LLVMGLOBAL;
array[Vertices] of bool: LLVMVAR;
array[Vertices] of bool: ENTRY;
array[Vertices] of bool: STATICVAR;
array[Vertices] of bool: FUNCTION;
array[Vertices] of bool: FUNCTIONCALL;
array[Vertices] of bool: LOCALVAR;
array[Vertices,Vertices] of bool: DEF_USE;
array[Vertices,Vertices] of bool: RAW;
array[Vertices,Vertices] of bool: PARAMETER;
array[Vertices,Vertices] of bool: CONTROL;
array[Vertices,Vertices] of bool: GLOBAL_DEP;
array[Vertices,Vertices] of bool: D_general;
array[Vertices,Vertices] of bool: SCOPE;
array[Vertices,Enclaves] of bool: ENCLAVEREMOTELEVEL;

/* Decision variables, problem will additionally constrain nodeEnclave for annotated nodes */
array[Vertices] of var Enclaves: nodeEnclave;
array[Vertices,Vertices] of var bool: resolvableConflict;

/* BEGIN unused, baggage from imperative */
int: CONTROLEntryPath;
int: SCOPEEntryPath;
int: CONTROLEntryPathDepthMax;
int: SCOPEEntryPathDepthMax;
array[1 .. CONTROLEntryPath] of int: CONTROLEntryPathDepth;
array[1 .. SCOPEEntryPath] of int: SCOPEEntryPathDepth;
array[1 .. CONTROLEntryPath,1 .. CONTROLEntryPathDepthMax] of Vertices: entryCONTROLDFS;
array[1 .. SCOPEEntryPath,1 .. SCOPEEntryPathDepthMax] of Vertices: entrySCOPEDFS;
/* END unused, baggage from imperative */

/* We expect that every function and static variable is assigned to a valid enclave */
constraint forall (x in Vertices where ENTRY[x]==1) ( nodeEnclave[x] != enclaveNull );
constraint forall (x in Vertices where STATICVAR[x]==1) ( nodeEnclave[x] != enclaveNull );

/* Conflict is resolvable vis RPC if endpoints of control edge from functioncall to entry are in different enclaves */
constraint forall (x in Vertices, y in Vertices) (
  not (CONTROL[x,y]==1 /\ FUNCTIONCALL[x] /\ ENTRY[y] /\ nodeEnclave[x] != nodeEnclave[y]) -> resolvableConflict[x,y]==0
);

/* The two ends of every CONTROL edge must be assigned to the same enclave unless it is a resolvable conflict */ 
constraint forall (x in Vertices, y in Vertices) ( CONTROL[x,y]==1 /\ resolvableConflict[x,y]!=1 -> nodeEnclave[x]==nodeEnclave[y] );

/* The two edges of every DEF_USE edge must be assigned the same enclave, no exceptions */
/* constraint forall (x in Vertices, y in Vertices) ( DEF_USE[x,y]==1 -> nodeEnclave[x]==nodeEnclave[y] ); */

/* The two edges of every RAW edge must be assigned the same enclave, no exceptions */
constraint forall (x in Vertices, y in Vertices) ( RAW[x,y]==1 -> nodeEnclave[x]==nodeEnclave[y] );

/* The two edges of every PARAMETER edge must be assigned the same enclave, no exceptions */
constraint forall (x in Vertices, y in Vertices) ( PARAMETER[x,y]==1 -> nodeEnclave[x]==nodeEnclave[y] );

/* The two edges of every GLOBAL_DEP edge must be assigned the same enclave, no exceptions */
constraint forall (x in Vertices, y in Vertices) ( GLOBAL_DEP[x,y]==1 -> nodeEnclave[x]==nodeEnclave[y] );

var int: obj = sum(x in Vertices, y in Vertices where resolvableConflict[x,y]==1)(1);
solve minimize obj;

/* solve satisfy; */
/* try to generate all cases */

output["ENTRY: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in Vertices where ENTRY[x]==1] ;
/* XXX: Need to only output those static vars that are global */
output["STATICVAR: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in Vertices where STATICVAR[x]==1] ; 
output["Resolvable: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ " " ++ show(y) ++ " " ++ show(nodeEnclave[y]) ++ "\n" | x in Vertices, y in Vertices where fix(resolvableConflict[x,y])==1];
output[show(nodeEnclave[v1]) ++ " " ++ show(v1) ++ "\n" | v1 in Vertices where fix(nodeEnclave[v1])!=enclaveNull ];
