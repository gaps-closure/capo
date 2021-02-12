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
array[Vertices] of var Enclaves: nodeEnclave;
array[Vertices] of var Vertices: controlConflictPair;

/*immediate parent function of local variables has same enclave as local variable*/
constraint forall (v in Vertices where LOCALVAR[v] == 1) (
	if (nodeEnclave[v] != enclaveNull)
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
	if (nodeEnclave[v1] != enclaveNull)
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
		if (nodeEnclave[i] != enclaveNull)
		then
			if (SCOPE[i,v] == 1)
			then
				nodeEnclave[i]=nodeEnclave[v]
			endif
		endif
	)
);
/*control descendents of all entry functions must has same enclave as entry function*/
/*constraint forall (v1 in Vertices) (
		controlConflictPair[v1]=NodeNULL
);*/
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
function var 1 .. CONTROLEntryPathDepthMax: CONTROLEntryStop(int: i, int: j) = (
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
/*constraint forall (v1 in Vertices where controlConflictPair[v1] != NodeNULL) (
	controlConflictPair[v1] != v1 /\ CONTROL[v1,controlConflictPair[v1]]=true
);*/
constraint forall (v1 in Vertices) (
	if ((sum(v2 in Vertices where CONTROL[v1,v2]==true)(1))==0)
	then
		controlConflictPair[v1]=NodeNULL
	endif
);

constraint forall (v1 in Vertices where controlConflictPair[v1] != NodeNULL /\ v1 != NodeNULL) (
	CONTROL[v1,controlConflictPair[v1]]=true
);
/*constraint forall (v1 in Vertices where v1 != NodeNULL /\ controlConflictPair[v1] != NodeNULL) (
	forall (v2 in Vertices where v2 != v1 /\ v2 != NodeNULL /\ controlConflictPair[v1] == v2) (
		CONTROL[v1,v2]=true
	)
);*/
/*constraint forall (v1 in Vertices where v1 != NodeNULL /\ controlConflictPair[v1] != NodeNULL) (
	forall (v2 in Vertices where v2 != v1 /\ v2 != NodeNULL /\ controlConflictPair[v1] == v2) (
		assert(CONTROL[v1,v2]==true,show(v1) ++ " " ++ show(v2) ++ " " ++ show(CONTROL[v1,v2]),true)
	)
);*/

		
	
	
/*constraint forall (i in 1 .. CONTROLEntryPath where nodeEnclave[entryCONTROLDFS[i,1]] != enclaveNull) (
	forall (j in 2 ..CONTROLEntryPathDepth[i]) (
		assert(CONTROL[entryCONTROLDFS[i,j-1],entryCONTROLDFS[i,j]],show(i) ++ " " ++ show(j) ++ show(entryCONTROLDFS[i,j-1]) ++ " " ++ show(entryCONTROLDFS[i,j]),true)
	)
);*/

constraint forall (i in 1 .. CONTROLEntryPath where nodeEnclave[entryCONTROLDFS[i,1]] != enclaveNull) (
	if (CONTROLEntryConflict(i,2) < CONTROLEntryPathDepth[i])
	then
		if (controlConflictPair[entryCONTROLDFS[i,CONTROLEntryStop(i,2)]] == NodeNULL)
		then
			controlConflictPair[entryCONTROLDFS[i,CONTROLEntryConflict(i,2)]]
				=entryCONTROLDFS[i,CONTROLEntryConflict(i,2)+1]
		endif
	endif
);
/*var int: obj = sum(v in Vertices where controlConflictPair[v] != NodeNULL)(1);
solve minimize obj;*/
output[show(v1) ++ " " ++ show(nodeEnclave[v1]) ++ " " ++  show(controlConflictPair[v1]) ++ " " ++ show(CONTROL[v1,controlConflictPair[v1]]) ++ "\n" | v1 in Vertices where fix(nodeEnclave[v1])!=enclaveNull];
/*output[show(obj) ++ " " ++ show(v1) ++ " " ++ show(Vertices[v1]) ++ " " ++ show(nodeEnclave[Vertices[v1]]) ++ " " ++  show(controlConflictPair[Vertices[v1]]) ++ "\n" | v1 in 1 .. max(Vertices) where fix(nodeEnclave[Vertices[v1]])!=enclaveNull];*/
