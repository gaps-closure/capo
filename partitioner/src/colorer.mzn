enum Vertices;
enum Enclaves;
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
array[Vertices,Enclaves] of var bool: ENCLAVENODES;

/*immediate parent function of local variables has same enclave as local variable*/
constraint forall (v in Vertices where LOCALVAR[v] == 1) (
	forall (i in Vertices where ENTRY[i] == 1) (
		if (CONTROL[i,v] == 1)
		then
			forall (j in Enclaves where ENCLAVENODES[v,j] == 1)(
				ENCLAVENODES[i,j]=1
			)
		endif
	)
);
/*annotated STATICLOCAL variables must have exactly one immediate parent of type ENTRY*/
constraint forall (v1 in Vertices where STATICVAR[v1] == 1) (
	forall (e1 in Vertices where ENTRY[e1] == 1) (
		if (SCOPE[e1,v1] == 1)
		then
			forall (e2 in Vertices where ENTRY[e2] == 1) (
				if (e1 != e2)
				then
					SCOPE[e2,v1] = 0
				endif
			)
		endif
	)
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
		if (SCOPE[i,v] == 1)
		then
			forall (j in Enclaves where ENCLAVENODES[v,j] == 1)(
				ENCLAVENODES[i,j]=1
			)
		endif
	)
);
/*control descendents of all entry functions must has same enclave as entry function*/
constraint forall (n1 in Vertices where ENTRY[n1] == 1) (
	forall (e in Enclaves where ENCLAVENODES[n1,e] == 1)(
		forall (n2 in Vertices where controlAncestor[n1,n2] == 1) (
			ENCLAVENODES[n2,e]=1
		)
	)
);
/*scope descendents of all entry functions must has same enclave as entry function*/
constraint forall (n1 in Vertices where ENTRY[n1] == 1) (
	forall (e in Enclaves where ENCLAVENODES[n1,e] == 1 ) (
		forall (n2 in Vertices where scopeAncestor[n1,n2] == 1) (
			ENCLAVENODES[n2,e]=1
		)
	)
);

/*no node may be assigned more than one enclave*/
constraint forall (v in Vertices) (
	forall (e1 in Enclaves) (
		if ENCLAVENODES[v,e1] == 1 
		then
			if (FUNCTIONCALL[v] == 1)
			then
				forall (e2 in Enclaves where e2 != e1) (
					if (ENCLAVEREMOTELEVEL[v,e2] != 1)
					then
						ENCLAVENODES[v,e2]=0
					endif
				)
			/*else
				forall (e2 in Enclaves where e2 != e1) (
					ENCLAVENODES[v,e2]=0
				)*/
			endif
		endif
	)
);
/*output[show(ENCLAVENODES)];*/
output["orange " ++ show(o) ++ "\npurple " ++ show(p) ++ "\n" | o in Vertices where fix(ENCLAVENODES[o,orange]) == 1, p in Vertices where fix(ENCLAVENODES[p,purple]) == 1];






/*output[show(v1) ++ " " ++ show(v1) ++ "\n" |v1 in Vertices where fix(scopeAncestor[v1,v1]) == 1];*/
/*output[show(v1) ++ "," ++ show(v2) ++ "\n" |v1 in Vertices, v2 in Vertices where fix(scopeAncestor[v1,v2]) == 1];*/





/*output[show(ENCLAVENODES[Vertices,orange]==1),orange])];*/
/*output[show(ENCLAVENODES[v,orange]) | v in Vertices];*/
/*output["orange " ++ show(v) ++ "\n" | v in Vertices where fix(ENCLAVENODES[v,orange]) == 1 ++ "\npurple " ++ show(v) ++ "\n" | v in Vertices where fix(ENCLAVE[v,purple]) == 1];*/
/*output[show(v) | v in Vertices ];*/
/*output[show(v) | v in Vertices where ENCLAVENODES[v,orange] ]*/
/*output [forall (v in Vertices) (forall (e in Enclaves)((show(ENCLAVENODES[v,e]))))];*/
