/*parent function of local variables has same enclave as local variable*/
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
/*parent function of static variables has same enclave as static variable*/
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
/*no node may be assigned more than one enclave*/
constraint forall (v in Vertices) (
	forall (e1 in Enclaves) (
		if ENCLAVENODES[v,e1] == 1 
		then
			forall (e2 in Enclaves where e2 != e1) (
				ENCLAVENODES[v,e2]=0
			)
		endif
	)
);
/*output[show(ENCLAVENODES[Vertices,orange]==1),orange])];*/
/*output[show(ENCLAVENODES[v,orange]) | v in Vertices];*/
/*output["orange " ++ show(v) ++ "\n" | v in Vertices where fix(ENCLAVENODES[v,orange]) == 1 ++ "\npurple " ++ show(v) ++ "\n" | v in Vertices where fix(ENCLAVE[v,purple]) == 1];*/
output["orange " ++ show(o) ++ "\npurple " ++ show(p) ++ "\n" | o in Vertices where fix(ENCLAVENODES[o,orange]) == 1, p in Vertices where fix(ENCLAVENODES[p,purple]) == 1];
/*output[show(v) | v in Vertices ];*/
/*output[show(v) | v in Vertices where ENCLAVENODES[v,orange] ]*/
/*output [forall (v in Vertices) (forall (e in Enclaves)((show(ENCLAVENODES[v,e]))))];*/
