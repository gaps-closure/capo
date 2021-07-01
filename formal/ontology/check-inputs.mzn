output ["Enclave Assingment: \(nodeEnclave) \n"];
output ["CLE Assingment: \(hasCle) \n"];
output["ENTRY: "     ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in C_FunctionEntry(FunctionEntry) ] ;
output["GLOBAL: " ++ show(x) ++ " " ++ show(nodeEnclave[x]) ++ "\n" | x in PDGNode where x in Global] ;
output["\(PDGNode) \n"];



output ["Edge: "++ show(x) ++ " src: "  ++ show_int(0, to_enum(PDGNode,hasSource[to_enum(PDGEdge,x)])) ++ " | " ++ show(hasCle[to_enum(PDGNode,hasSource[to_enum(PDGEdge,x)])]) ++ "\n" | x in 1..max(PDGEdge) ] ;
output ["dest: " ++ show_int(0, hasDest[to_enum(PDGEdge,x)]) ++ " | " ++ show(hasCle[hasDest[to_enum(PDGEdge,to_enum(PDGEdge,x))]]) ++ "\n" | x in 1..max(PDGEdge) ] ;

output ["Node: " ++ show_int(0, x) ++ " | " ++ show(hasCle[to_enum(PDGNode,x) ]) ++ "\n" | x in 1..max(PDGNode) ] ;
output["\(hasDest[C_ControlDep(to_enum(ControlDep,13))]) \n"];
% output["\(show_int(0,to_enum(PDGEdge,C_DataEdge(C_DataDep(C_DataDepEdge_DefUse(ID4294967228)))))) \n"];
predicate CanCoerce(DataDep:e) = if e in C_DataDepEdge_Ret(DataDepEdge_Ret) then true else false endif ;

constraint forall (e in DataDep) (hasCle[hasSource[C_DataEdge(C_DataDep(e))]] == hasCle[hasDest[C_DataEdge(C_DataDep(e))]] \/ CanCoerce(e));
output ["src: "++ show(hasSource[C_DataEdge(C_DataDep(to_enum(DataDep,x)))]) ++ " " ++ show(hasCle[hasSource[C_DataEdge(C_DataDep(to_enum(DataDep,x)))]]) ++ " dest: " ++ show(hasDest[C_DataEdge(C_DataDep(to_enum(DataDep,x)))]) ++ " | " ++ show(hasCle[hasDest[C_DataEdge(C_DataDep(to_enum(DataDep,x)))]]) ++ "\n" | x in 1..max(DataDep) ] ;

output ["src: " ++ show(to_enum(PDGNode,29)) ++ "dest: " ++ show(to_enum(PDGNode,10))]
