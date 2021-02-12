enum Vertices;
enum Enclaves;
int: CONTROLEntryPath;
int: SCOPEEntryPath;
int: CONTROLEntryPathDepthMax;
int: SCOPEEntryPathDepthMax;
array[1 .. CONTROLEntryPath] of int: CONTROLEntryPathDepth;
array[1 .. SCOPEEntryPath] of int: SCOPEEntryPathDepth;
array[1 .. CONTROLEntryPath,1 .. CONTROLEntryPathDepthMax] of Vertices: entryCONTROLDFS;
array[1 .. SCOPEEntryPath,1 .. SCOPEEntryPathDepthMax] of Vertices: entrySCOPEDFS;
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
array[Vertices,Vertices] of var bool: scopeAncestor;
array[Vertices,Vertices] of var bool: controlAncestor;
array[Vertices,Vertices] of var bool: d_aliasAncestor;
array[Vertices,Vertices] of var bool: data_call_paraAncestor;
array[Vertices,Vertices] of var bool: data_readAncestor;
array[Vertices,Vertices] of var bool: def_useAncestor;
array[Vertices,Vertices] of var bool: d_generalAncestor;
array[Vertices,Vertices] of var bool: global_depAncestor;
array[Vertices,Vertices] of var bool: parameterAncestor;
array[Vertices,Vertices] of var bool: rawAncestor;
array[Vertices] of var Enclaves: nodeEnclave;
array[Vertices] of var bool: nodeEnclaveAssigned;
array[Vertices,Vertices] of var bool: conflictPair;

constraint forall (v1 in Vertices)(
		forall (v2 in Vertices) (conflictPair[v1,v2] = false));

/*immediate parent function of local variables has same enclave as local variable*/
constraint forall (v in Vertices where LOCALVAR[v] == 1) (
	if (nodeEnclaveAssigned[v] == true)
	then
		forall (i in Vertices where ENTRY[i] == 1) (
			if (CONTROL[i,v] == 1)
			then
				nodeEnclave[i]=nodeEnclave[v]
			endif
		)
	endif
);
/*annotated STATICLOCAL variables must have exactly one immediate parent of type ENTRY*/
constraint forall (v1 in Vertices where STATICVAR[v1] == 1) (
	if (nodeEnclaveAssigned[v1] == true)
	then
		forall (e1 in Vertices where ENTRY[e1] == 1) (
			if (SCOPE[e1,v1] == 1)
			then
				nodeEnclave[e1]=nodeEnclave[v1]
			endif
		)
	endif
);
/*annotated LOCAL variables must have exactly one immediate parent of type ENTRY*/
constraint forall (v1 in Vertices where LOCALVAR[v1] == 1) (
	forall (e1 in Vertices where ENTRY[e1] == 1) (
		if (CONTROL[e1,v1] == 1)
		then
			forall (e2 in Vertices where ENTRY[e2] == 1) (
				if (e1 != e2)
				then
					CONTROL[e2,v1] = 0
				endif
			)
		endif
	)
);


/*immediate parent function of static variables has same enclave as static variable*/
constraint forall (v in Vertices where STATICVAR[v] == 1) (
	forall (i in Vertices where ENTRY[i] == 1) (
		if (nodeEnclaveAssigned[i] == true)
		then
			if (SCOPE[i,v] == 1)
			then
				nodeEnclave[i]=nodeEnclave[v]
			endif
		endif
	)
);
/*control descendents of all entry functions must has same enclave as entry function*/

array[1 .. CONTROLEntryPath] of var bool: CONTROLENTRYPATHSTOP;
array[Vertices,Vertices] of var bool: controlConflict;
array[1 .. CONTROLEntryPath,1 .. CONTROLEntryPathDepthMax] of var bool: entryCONTROLDFSSTOP;
constraint forall (i in 1 .. CONTROLEntryPath)(
		entryCONTROLDFSSTOP[i,1] = false);
constraint forall (v in Vertices where nodeEnclave[v] != enclaveNull) (
	nodeEnclaveAssigned[v] = true
);
	
array[1 .. CONTROLEntryPath] of var bool: CONTROLEntryPathConflict;
/*constraint forall (i in 1 .. CONTROLEntryPath) (
	CONTROLEntryPathConflict[i] = false
);*/

array[1 .. CONTROLEntryPath,1 .. CONTROLEntryPathDepthMax] of var 0 .. CONTROLEntryPathDepthMax: DC;
function var int: CONTROLEntryConflict(int: i, int: j) = (
	if (j < CONTROLEntryPathDepth[i]+1)
	then
		if (LLVMGLOBAL[entryCONTROLDFS[i,j]]==true)
		then
			CONTROLEntryPathDepth[i]
		else
			if (LLVMVAR[entryCONTROLDFS[i,j]]==true)
			then
				CONTROLEntryPathDepth[i]
			else
				if (nodeEnclave[entryCONTROLDFS[i,j]]==nodeEnclave[entryCONTROLDFS[i,1]])
				then
					CONTROLEntryPathDepth[i]
				else
					if (nodeEnclave[entryCONTROLDFS[i,j]] != enclaveNull)
					then
						j-1
					else
						CONTROLEntryConflict(i,j+1)
					endif
				endif
			endif
		endif
	else
		j-1
	endif
);
function var int: CONTROLEntryStop(int: i, int: j) = (
	if (j < CONTROLEntryPathDepth[i]+1)
	then
		if (LLVMGLOBAL[entryCONTROLDFS[i,j]]==true)
		then
			j-1
		else
			if (LLVMVAR[entryCONTROLDFS[i,j]]==true)
			then
				j-1
			else
				if (nodeEnclave[entryCONTROLDFS[i,j]]==nodeEnclave[entryCONTROLDFS[i,1]])
				then
					j-1
				else
					if (nodeEnclave[entryCONTROLDFS[i,j]] != enclaveNull)
					then
						j-1
					else
						CONTROLEntryStop(i,j+1)
					endif
				endif
			endif
		endif
	else
		j-1
	endif
);
constraint forall (i in 1 .. CONTROLEntryPath) (
	forall (j in 2 .. CONTROLEntryPathDepth[i]) (
		if (CONTROLEntryStop(i,2) >= j)
		then
			nodeEnclave[entryCONTROLDFS[i,j]]=nodeEnclave[entryCONTROLDFS[i,1]]
		endif
	)
);
array[1 .. CONTROLEntryPath] of var int: PATHCONFLICT;
constraint forall (i in 1 .. CONTROLEntryPath) (
	PATHCONFLICT[i]=CONTROLEntryConflict(i,2)
	/*if (CONTROLEntryStop(i,2) < CONTROLEntryPathDepth[i])
	then
		controlConflict[entryCONTROLDFS[i,CONTROLEntryStop(i,2)-1],entryCONTROLDFS[i,CONTROLEntryStop(i,2)-1]] = true
	endif*/
);
/*constraint forall (i in 1 .. CONTROLEntryPath where nodeEnclave[entryCONTROLDFS[i,1]]!=enclaveNull) (
	forall (j in 2 .. CONTROLEntryPathDepth[i]+1)(
		if (j > CONTROLEntryPathDepth[i])
		then
			CONTROLEntryPathConflict[i]=j
		else
			if (CONTROLEntryPathConflict[i] == 0)
			then
				if (nodeEnclave[entryCONTROLDFS[i,j]]!=enclaveNull)
				then
					if(nodeEnclave[entryCONTROLDFS[i,1]] !=
						nodeEnclave[entryCONTROLDFS[i,j]])
					then
						CONTROLEntryPathConflict[i]=j 
					else
						CONTROLEntryPathConflict[i]=j
					endif
				else
					nodeEnclave[entryCONTROLDFS[i,j]]=nodeEnclave[entryCONTROLDFS[i,1]]
				endif
			else
				DC[i,j]=j
			endif
		endif
	)
);*/
/*scope descendents of all entry functions must has same enclave as entry function*/
array[Vertices,Vertices] of var int: scopeConflict;
array[1 .. SCOPEEntryPath,1 .. SCOPEEntryPathDepthMax] of var bool: entrySCOPEDFSSTOP;
/*constraint forall (i in 1 .. SCOPEEntryPath where nodeEnclave[entrySCOPEDFS[i,1]]!=enclaveNull) (
	forall (j in 2 .. SCOPEEntryPathDepth[i])(
		if (nodeEnclave[entrySCOPEDFS[i,j]]!=enclaveNull)
		then
			if(nodeEnclave[entrySCOPEDFS[i,1]] !=
				nodeEnclave[entrySCOPEDFS[i,j]])
			then
				(entrySCOPEDFSSTOP[i,j] = true) /\
				(scopeConflict[entrySCOPEDFS[i,j-1],entrySCOPEDFS[i,j]]=true)
			else
				entrySCOPEDFSSTOP[i,j] = true
			endif
		else
			(nodeEnclave[entrySCOPEDFS[i,j]]=nodeEnclave[entrySCOPEDFS[i,1]]) /\
			(entrySCOPEDFSSTOP[i,j] = false)
		endif
	)
);*/

/*solve maximize sum(v in Vertices) (nodeEnclave[v] != enclaveNull);*/
/*solve minimize sum(v1 in Vertices,v2 in Vertices) (controlConflict[v1,v2] == true);*/

output[show(i1) ++ " " ++ show(PATHCONFLICT[i1]) ++ " " ++ show(entryCONTROLDFS[i1,i2]) ++ " " ++ show(nodeEnclave[entryCONTROLDFS[i1,1]]) ++ " " ++ show(nodeEnclave[entryCONTROLDFS[i1,i2]]) ++ "," |i1 in 1 .. CONTROLEntryPath, i2 in 1 .. CONTROLEntryPathDepth[i1] where fix(nodeEnclave[entryCONTROLDFS[i1,1]]) != enclaveNull];
/*output[show(v1) ++ "," ++ show(v2) ++ " " ++ show(fix(controlConflict[v1,v2])) ++ "\n" | v1 in Vertices, v2 in Vertices];*/

/*output[show(v1) ++ " "   ++ show(nodeEnclaveAssigned[v1]) ++ " " ++show(nodeEnclave[v1]) ++ "\n" | v1 in Vertices];*/






/*output[show(entryCONTROLDFSSTOP[v1,v2]) | v1 in Vertices, v2 in Vertices where is_fixed(entryCONTROLDFSSTOP[v1,v2])];*/
/*output[show(v1) ++ " " ++ show(v2) ++ " " ++ show(fix(controlConflict[v1,v2])) ++ "\n" | v1 in Vertices, v2 in Vertices];/* where fix(controlConflict[v1,v2]) != false ];*/
/*output[show(v1) ++ " " ++ show(e1) ++ "\n" | v1 in Vertices where fix(nodeEnclave[v1])==true, e1 in Enclaves where e1 == fix(nodeEnclaveAssigned[v1])];*/


/*output[show(v1) ++ " " ++ show(nodeEnclave[v1]) ++ "\n" | v1 in Vertices where nodeEnclaveAssigned[v1]==true ];*/






/*output[show(v1) ++ " " ++ show(v1) ++ "\n" |v1 in Vertices where fix(scopeAncestor[v1,v1]) == 1];*/
/*output[show(v1) ++ "," ++ show(v2) ++ "\n" |v1 in Vertices, v2 in Vertices where fix(scopeAncestor[v1,v2]) == 1];*/





/*output[show(v) | v in Vertices ];*/
