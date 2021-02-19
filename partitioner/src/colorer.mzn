/* Variables from annotated LLVM IR instance */
enum Vertices;
enum Enclaves;
enum DEF_USEEdges;
enum PARAMETEREdges;
enum GLOBAL_DEPEdges;
/*enum D_generalEdges;*/
enum CONTROLEdges;
enum SCOPEEdges;
enum RAWEdges;

/* Decision variables, problem will additionally constrain nodeEnclave for annotated nodes */
/*array[Vertices] of bool: LLVMGLOBAL;
array[Vertices] of bool: LLVMVAR;*/
array[Vertices] of bool: ENTRY;
array[Vertices] of bool: STATICVAR;
array[Vertices] of bool: FUNCTION;
array[Vertices] of bool: FUNCTIONCALL;
array[Vertices] of bool: LOCALVAR;
/*array[Vertices,Vertices] of bool: DEF_USE;
array[Vertices,Vertices] of bool: RAW;
array[Vertices,Vertices] of bool: PARAMETER;
array[Vertices,Vertices] of bool: CONTROL;
array[Vertices,Vertices] of bool: GLOBAL_DEP;
array[Vertices,Vertices] of bool: D_general;
array[Vertices,Vertices] of bool: SCOPE;*/
array[Vertices,Enclaves] of bool: ENCLAVEREMOTELEVEL;
array[RAWEdges] of Vertices: RAWFrom;
array[RAWEdges] of Vertices: RAWTo;
array[DEF_USEEdges] of Vertices: DEF_USEFrom;
array[DEF_USEEdges] of Vertices: DEF_USETo;
array[PARAMETEREdges] of Vertices: PARAMETERFrom;
array[PARAMETEREdges] of Vertices: PARAMETERTo;
array[GLOBAL_DEPEdges] of Vertices: GLOBAL_DEPFrom;
array[GLOBAL_DEPEdges] of Vertices: GLOBAL_DEPTo;
/*array[D_generalEdges] of Vertices: D_generalFrom;
array[D_generalEdges] of Vertices: D_generalTo;*/
array[CONTROLEdges] of Vertices: CONTROLFrom;
array[CONTROLEdges] of Vertices: CONTROLTo;
array[SCOPEEdges] of Vertices: SCOPEFrom;
array[SCOPEEdges] of Vertices: SCOPETo;

/* Decision variables, problem will additionally constrain nodeEnclave for annotated nodes */
array[Vertices] of var Enclaves: nodeEnclave;
array[Vertices] of var bool: resolvableConflictFrom;
array[Vertices] of var bool: resolvableConflictTo;

/* BEGIN unused, baggage from imperative
int: CONTROLEntryPath;
int: SCOPEEntryPath;
int: CONTROLEntryPathDepthMax;
int: SCOPEEntryPathDepthMax;
array[1 .. CONTROLEntryPath] of int: CONTROLEntryPathDepth;
array[1 .. SCOPEEntryPath] of int: SCOPEEntryPathDepth;
array[1 .. CONTROLEntryPath,1 .. CONTROLEntryPathDepthMax] of Vertices: entryCONTROLDFS;
array[1 .. SCOPEEntryPath,1 .. SCOPEEntryPathDepthMax] of Vertices: entrySCOPEDFS;
END unused, baggage from imperative */

/* We expect that every function and static variable is assigned to a valid enclave */
constraint forall (x in Vertices where ENTRY[x]==1) ( nodeEnclave[x] != enclaveNull );
constraint forall (x in Vertices where STATICVAR[x]==1) ( nodeEnclave[x] != enclaveNull );
function var bool: resolvableConflict(Vertices: x, Vertices: y) = (
	(resolvableConflictFrom[x] == 1 /\ resolvableConflictTo[y] == 1)
);
function int: countControlEdges(Vertices: x, Vertices: y) = (
	sum(e in CONTROLEdges where CONTROLFrom[e]==x /\ CONTROLTo[e]==y)(1)
);
function int: countDefUseEdges(Vertices: x, Vertices: y) = (
	sum(e in DEF_USEEdges where DEF_USEFrom[e]==x /\ DEF_USETo[e]==y)(1)
);
function int: countRawEdges(Vertices: x, Vertices: y) = (
	sum(e in RAWEdges where RAWFrom[e]==x /\ RAWTo[e]==y)(1)
);
/*function int: countD_generalEdges(Vertices: x, Vertices: y) = (
	sum(e in D_generalEdges where D_generalFrom[e]==x /\ D_generalTo[e]==y)(1)
);*/
function int: countParameterEdges(Vertices: x, Vertices: y) = (
	sum(e in PARAMETEREdges where PARAMETERFrom[e]==x /\ PARAMETERTo[e]==y)(1)
);
function int: countScopeEdges(Vertices: x, Vertices: y) = (
	sum(e in SCOPEEdges where SCOPEFrom[e]==x /\ SCOPETo[e]==y)(1)
);
function int: countGlobalDepEdges(Vertices: x, Vertices: y) = (
	sum(e in GLOBAL_DEPEdges where GLOBAL_DEPFrom[e]==x /\ GLOBAL_DEPTo[e]==y)(1)
);
/* Conflict is resolvable vis RPC if endpoints of control edge from functioncall to entry are in different enclaves */
constraint forall (x in Vertices, y in Vertices) (
  not (countControlEdges(x,y) > 0 /\ FUNCTIONCALL[x] /\ ENTRY[y] /\ nodeEnclave[x] != nodeEnclave[y]) -> resolvableConflict(x,y)==0
);

/* The two ends of every CONTROL edge must be assigned to the same enclave unless it is a resolvable conflict */ 
constraint forall (x in Vertices, y in Vertices) ( countControlEdges(x,y)>0 /\ resolvableConflict(x,y)!=1 -> nodeEnclave[x]==nodeEnclave[y] );

/* The two edges of every DEF_USE edge must be assigned the same enclave, no exceptions */
 /*constraint forall (x in Vertices, y in Vertices) ( countDefUseEdges(x,y)>0 -> nodeEnclave[x]==nodeEnclave[y] ); */

/* The two edges of every RAW edge must be assigned the same enclave, no exceptions */
constraint forall (x in Vertices, y in Vertices) ( countRawEdges(x,y)>0 -> nodeEnclave[x]==nodeEnclave[y] );

/* The two edges of every PARAMETER edge must be assigned the same enclave, no exceptions */
constraint forall (x in Vertices, y in Vertices) ( countParameterEdges(x,y)>0 -> nodeEnclave[x]==nodeEnclave[y] );

/* The two edges of every GLOBAL_DEP edge must be assigned the same enclave, no exceptions */
constraint forall (x in Vertices, y in Vertices) ( countGlobalDepEdges(x,y)>0 -> nodeEnclave[x]==nodeEnclave[y] );

/*var int: obj = sum(x in Vertices, y in Vertices where resolvableConflict(x,y)==1)(1);
solve minimize obj;*/

/* solve satisfy; */
/* try to generate all cases */

output["ENTRY: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in Vertices where ENTRY[x]==1] ;
/* XXX: Need to only output those static vars that are global */
output["STATICVAR: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in Vertices where STATICVAR[x]==1] ; 
output["Resolvable: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ " " ++ show(y) ++ " " ++ show(nodeEnclave[y]) ++ "\n" | x in Vertices, y in Vertices where (fix(resolvableConflictFrom[x])==1 /\ fix(resolvableConflictTo[y])==1)];
output[show(nodeEnclave[v1]) ++ " " ++ show(v1) ++ "\n" | v1 in Vertices where fix(nodeEnclave[v1])!=enclaveNull ];
