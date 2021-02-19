/**********************************************************************************************/
/* Constraint model for cross-domain conflict checking of CLE annotated C programs            */
/* XXX: Initially only the control flow constraints are encoded, data flow and typing         */
/*      constraints are to be added.                                                          */
/**********************************************************************************************/

/**********************************************************************************************/
/* Variables from annotated LLVM IR instance                                                  */
/* XXX: Need to handle label, level, cdfs from annotation properly                            */
/**********************************************************************************************/
enum Enclaves;
/* array[Vertices,Enclaves] of bool: ENCLAVEREMOTELEVEL; */  /* XXX: Not yet used */

/**********************************************************************************************/
/* Variables from annotated LLVM IR instance using PDG abstractions                           */
/* XXX: Consider updating to new PSU PDG which is a cleaner abstraction before encoding       */
/*      data flow and label/type constraints                                                  */
/**********************************************************************************************/
enum Vertices;                                         
array[Vertices] of bool: ENTRY;
array[Vertices] of bool: STATICVAR;
array[Vertices] of bool: FUNCTIONCALL;
array[Vertices] of bool: LOCALVAR;                      /* XXX: Not yet used */
array[Vertices] of bool: FUNCTION;                      /* XXX: Not yet used */
/* array[Vertices] of bool: LLVMGLOBAL; */              /* XXX: Annotations being pre-processed? */
/* array[Vertices] of bool: LLVMVAR; */                 /* XXX: Annotations being pre-processed? */

enum CONTROLEdges;                                     
array[CONTROLEdges] of Vertices: CONTROLFrom;
array[CONTROLEdges] of Vertices: CONTROLTo;

/* XXX: Not yet used, will bring in when we do data flow and typing contraints */
/* 
enum DEF_USEEdges; 
array[DEF_USEEdges] of Vertices: DEF_USEFrom;
array[DEF_USEEdges] of Vertices: DEF_USETo;
enum RAWEdges;
array[RAWEdges] of Vertices: RAWFrom;
array[RAWEdges] of Vertices: RAWTo;
enum PARAMETEREdges;
array[PARAMETEREdges] of Vertices: PARAMETERFrom;
array[PARAMETEREdges] of Vertices: PARAMETERTo;
enum GLOBAL_DEPEdges;
array[GLOBAL_DEPEdges] of Vertices: GLOBAL_DEPFrom;
array[GLOBAL_DEPEdges] of Vertices: GLOBAL_DEPTo;
enum SCOPEEdges;
array[SCOPEEdges] of Vertices: SCOPEFrom;
array[SCOPEEdges] of Vertices: SCOPETo;
enum D_generalEdges;
array[D_generalEdges] of Vertices: D_generalFrom;
array[D_generalEdges] of Vertices: D_generalTo;
*/

/**********************************************************************************************/
/* Decision variables, problem will additionally constrain nodeEnclave for annotated nodes    */
/**********************************************************************************************/
array[Vertices] of var Enclaves: nodeEnclave;
array[CONTROLEdges] of var bool: resolvableControlConflict;

/* We expect that every function and static variable is assigned to a valid enclave */
constraint forall (x in Vertices where ENTRY[x]==1) ( nodeEnclave[x] != enclaveNull );
constraint forall (x in Vertices where STATICVAR[x]==1) ( nodeEnclave[x] != enclaveNull );

/* Conflict is resolvable via RPC if endpoints of CONTROL edge from functioncall to entry are in different enclaves */
constraint forall (e in CONTROLEdges) (
  not (FUNCTIONCALL[CONTROLFrom[e]] /\ ENTRY[CONTROLTo[e]] /\ (nodeEnclave[CONTROLFrom[e]] != nodeEnclave[CONTROLTo[e]]))
  -> resolvableControlConflict[e]==0
);

/* The two ends of every CONTROL edge must be assigned to the same enclave unless it is a resolvable control conflict */ 
constraint forall (e in CONTROLEdges) ( resolvableControlConflict[e]!=1 -> nodeEnclave[CONTROLFrom[e]]==nodeEnclave[CONTROLTo[e]] );

/* XXX: Constraints on data flow and typing will touch DEF_USE, RAW, PARAMETER, GLOBAL_DEP, and D_generic edges */
/* XXX: TODO */

var int: obj = sum( e in CONTROLEdges where resolvableControlConflict[e]==1 )(1);
solve minimize obj;

/* solve satisfy; */
/* try to generate all cases */

/**********************************************************************************************/
/* Output assignments to relevant decision variables                                          */
/* XXX: Ought to only output those static vars that are global                                */
/**********************************************************************************************/
output["ENTRY: "     ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in Vertices where ENTRY[x]==1] ;
output["STATICVAR: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in Vertices where STATICVAR[x]==1] ;
output["Resolvable: "
       ++ show(CONTROLFrom[e]) ++ " " ++ show(nodeEnclave[CONTROLFrom[e]]) ++ " "
       ++ show(CONTROLTo[e]) ++ " " ++ show(nodeEnclave[CONTROLTo[e]]) ++ "\n"
       | e in CONTROLEdges where fix(resolvableControlConflict[e])==1];
output[show(nodeEnclave[v1]) ++ " " ++ show(v1) ++ "\n" | v1 in Vertices where fix(nodeEnclave[v1])!=enclaveNull ];
