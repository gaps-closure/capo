%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flag to include/exclude debug output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

predicate isFunctionEntry(var PDGNodeIdx: n)   = (n>=FunctionEntry_start /\ n<=FunctionEntry_end);
predicate isParam_ActualIn(var PDGNodeIdx: n)  = (n>=Param_ActualIn_start /\ n<=Param_ActualIn_end);
predicate isParam_ActualOut(var PDGNodeIdx: n) = (n>=Param_ActualOut_start /\ n<=Param_ActualOut_end);
predicate allowOrRedact(var cdf: c)            = (hasGuardOperation[c]==allow \/ hasGuardOperation[c]==redact);

predicate sourceAnnotFun(var PDGEdgeIdx: e) =
 (if hasFunction[hasSource[e]]!=0 then userAnnotatedFunction[hasFunction[hasSource[e]]] else false endif);

predicate destAnnotFun(var PDGEdgeIdx: e) =
 (if hasFunction[hasDest[e]]!=0 then userAnnotatedFunction[hasFunction[hasDest[e]]] else false endif);

 predicate  isInArctaint(var cleLabel: fan, var cleLabel: tnt, var Level: lvl) =
 (if isFunctionAnnotation[fan] then hasARCtaints[cdfForRemoteLevel[fan, lvl], tnt] else false endif);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% constraint :: "ClassHasEnclave"               forall (n in classNames)         (n == sharedClass \/ nullEnclave!=classEnclave[n]);
constraint :: "ClassHasEnclave"               forall (n in classNames)         (nullEnclave!=classEnclave[n]);
constraint :: "BindFunctionToClass"           forall (n in FunctionEntry)      (nodeEnclave[n]==classEnclave[hasClass[n]]);
constraint :: "InstHasEnclave"                forall (n in Inst)               (nodeEnclave[n]==nodeEnclave[hasFunction[n]]);
constraint :: "ParamHasEnclave"               forall (n in Param)              (nodeEnclave[n]==nodeEnclave[hasFunction[n]]);

constraint :: "NodeLevelAtTaintLevel"         forall (n in NonAnnotation)      (nodeLevel[n]==hasLabelLevel[taint[n]]);
constraint :: "NodeLevelAtEnclaveLevel"       forall (n in NonAnnotation)      (nodeLevel[n]==hasEnclaveLevel[nodeEnclave[n]]);
% When this fails, implies the program is not suffieciently annotated
constraint :: "FnAnnotationForFnOnly"         forall (n in NonAnnotation)      (isFunctionAnnotation[taint[n]] -> isFunctionEntry(n));
constraint :: "FnAnnotationByUserOnly"        forall (n in FunctionEntry)      (isFunctionAnnotation[taint[n]] -> userAnnotatedFunction[n]);

% /*
constraint :: "MyFunctionTaint"
 forall (n in PDGNodeIdx) (ftaint[n] == taint[hasFunction[n]]);


constraint :: "UnannotatedFunContentTaintMatch"
 forall (n in PDGNodeIdx) (userAnnotatedFunction[hasFunction[n]]==false -> taint[n]==ftaint[n]);

% /*


constraint :: "AnnotatedFunContentCoercible"
 forall (n in PDGNodeIdx where  isFunctionEntry(n)==false) 
  (userAnnotatedFunction[hasFunction[n]] -> isInArctaint(ftaint[n], taint[n], hasLabelLevel[taint[n]]));

constraint :: "EdgeSourceEnclave"             forall (e in PDGEdgeIdx)         (esEnclave[e]==nodeEnclave[hasSource[e]]);
constraint :: "EdgeDestEnclave"               forall (e in PDGEdgeIdx)         (edEnclave[e]==nodeEnclave[hasDest[e]]);
constraint :: "EdgeInEnclaveCut"              forall (e in PDGEdgeIdx)         (xdedge[e]==(esEnclave[e]!=edEnclave[e]));

constraint :: "EdgeSourceTaint"               forall (e in PDGEdgeIdx)         (esTaint[e]==taint[hasSource[e]]);
constraint :: "EdgeDestTaint"                 forall (e in PDGEdgeIdx)         (edTaint[e]==taint[hasDest[e]]);
constraint :: "EdgeTaintMismatch"             forall (e in PDGEdgeIdx)         (tcedge[e]==(esTaint[e]!=edTaint[e]));

constraint :: "SourceFunctionAnnotation"
 forall (e in PDGEdgeIdx) (esFunTaint[e] == (if sourceAnnotFun(e) then taint[hasFunction[hasSource[e]]] else nullCleLabel endif));

constraint :: "DestFunctionAnnotation"
 forall (e in PDGEdgeIdx) (edFunTaint[e] == (if destAnnotFun(e) then taint[hasFunction[hasDest[e]]] else nullCleLabel endif));

constraint :: "SourceCdfForDestLevel"
 forall (e in PDGEdgeIdx) (esFunCdf[e] == (if sourceAnnotFun(e) then cdfForRemoteLevel[esFunTaint[e], hasLabelLevel[edTaint[e]]] else nullCdf endif));

constraint :: "DestCdfForSourceLevel"
 forall (e in PDGEdgeIdx) (edFunCdf[e] == (if destAnnotFun(e) then cdfForRemoteLevel[edFunTaint[e], hasLabelLevel[esTaint[e]]] else nullCdf endif));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Control never leaves enclave except via valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% /*
constraint :: "NonCallControlEnclaveSafe"     forall (e in ControlDep_NonCall ) (xdedge[e]==false);
constraint :: "XDCallBlest"                   forall (e in ControlDep_CallInv) (xdedge[e] -> userAnnotatedFunction[hasDest[e]]);

constraint :: "XDCallAllowed"
 forall (e in ControlDep_CallInv) (
 xdedge[e] -> allowOrRedact(cdfForRemoteLevel[edTaint[e], hasLabelLevel[esTaint[e]]]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data never leaves enclave except via parameters or return for valid XDC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% /*
constraint :: "NonRetNonParmDataEnclaveSafe"  forall (e in DataEdgeNoRet)      (xdedge[e]==false);


constraint :: "XDCDataReturnAllowed"
 forall (e in DataDepEdge_Ret) (
  xdedge[e] -> allowOrRedact(cdfForRemoteLevel[esFunTaint[e], hasLabelLevel[edTaint[e]]]));


constraint :: "XDCParmAllowed"
 forall (e in Parameter)       (xdedge[e] -> allowOrRedact(cdfForRemoteLevel[esFunTaint[e], hasLabelLevel[edTaint[e]]]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Labels can only be cooerced inside enclave via parameters or return by noblest functions that are so blest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


constraint :: "TaintsSafeOrCoerced"           forall (e in DataEdgeParam)      ((tcedge[e] /\ (xdedge[e]==false)) -> coerced[e]);

constraint :: "ArgumentTaintCoerced"
 forall (e in Parameter_In union Parameter_Out)
  (if     destAnnotFun(e)   /\ isParam_ActualIn(hasDest[e])    /\ (hasParamIdx[hasDest[e]]>0)
   then coerced[e] == hasArgtaints[edFunCdf[e], hasParamIdx[hasDest[e]], esTaint[e]]
   elseif sourceAnnotFun(e) /\ isParam_ActualOut(hasSource[e]) /\ (hasParamIdx[hasSource[e]]>0)
   then coerced[e] == hasArgtaints[esFunCdf[e], hasParamIdx[hasSource[e]], edTaint[e]]
   else true 
   endif);

constraint :: "ReturnTaintCoerced"
 forall (e in DataDepEdge_Ret) (coerced[e] == (if sourceAnnotFun(e) then hasRettaints[esFunCdf[e], edTaint[e]] else false endif));


constraint :: "DataTaintCoercedData"
 forall (e in DataEdgeNoRet)
  (if ( hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
   then coerced[e] == (isInArctaint(esFunTaint[e], edTaint[e], hasLabelLevel[edTaint[e]]) /\
                       isInArctaint(esFunTaint[e], esTaint[e], hasLabelLevel[esTaint[e]]))
   else coerced[e] == false
   endif);

% constraint :: "DataTaintCoercedParam"
%  forall (e in Parameter)
%   (if ( hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
%    then coerced[e] == (isInArctaint(esFunTaint[e], edTaint[e], hasLabelLevel[edTaint[e]]) /\
%                        isInArctaint(esFunTaint[e], esTaint[e], hasLabelLevel[esTaint[e]]))
%    else coerced[e] == false
%    endif);

constraint :: "DataTaintCoercedParam"
 forall (e in Parameter)
  (if ( hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
   then coerced[e] == (isInArctaint(esFunTaint[e], edTaint[e], hasLabelLevel[edTaint[e]]) /\
                       isInArctaint(esFunTaint[e], esTaint[e], hasLabelLevel[esTaint[e]]))
   else coerced[e] == false
   endif);

% constraint :: "DataTaintCoercedField"
%  forall (e in Parameter_Field)
%  (if (e != 125 /\ e != 133) then
%   (if ( hasFunction[hasSource[e]]==hasFunction[hasDest[e]])
%    then coerced[e] == (isInArctaint(esFunTaint[e], edTaint[e], hasLabelLevel[edTaint[e]]) /\
%                        isInArctaint(esFunTaint[e], esTaint[e], hasLabelLevel[esTaint[e]]))
%    else coerced[e] == false
%    endif)
%    else
%    true
%    endif);


/*
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: objective = sum(e in ControlDep_CallInv where xdedge[e])(1);
solve minimize objective;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% output ["Domain assignments for globals:" ++ "\n"];
% output [" GLOBAL   : " ++ show(x) ++ " -> " ++ show(nodeEnclave[x]) ++ "::" ++ show(taint[x]) ++ "\n" | x in Global] ;
output ["Domain assignments for functions:" ++ "\n"];
output [" FUNCTION : " ++ show(x) ++ " -> " ++ show(nodeEnclave[x]) ++ "::" ++ show(taint[x]) ++ "\n" | x in FunctionEntry ] ;



output [if debug then "Label and Enclave assignments to non-annotation nodes:\n" else "" endif];
output [" ASSIGN   : " ++
 show(n) ++ " " ++
 (if (n>=FunctionEntry_start /\ n<=FunctionEntry_end) then "FunctionEntry "
  elseif (n>=Inst_start          /\ n<=Inst_end)          then "Inst          "
  elseif (n>=Param_start         /\ n<=Param_end)         then "Param         "
  else                                                         "Annotation    "
  endif)
 ++ "[" ++
 show(nodeEnclave[n])
 ++ "]::" ++ show(taint[n]) ++ "\n"
 | n in PDGNodeIdx where debug];
 output ["=======================================" ++ "\n" ++ "Enclave Assingments\n" ++ "=======================================" ++ "\n"];
output [" Enclaves : " ++ show(hasEnclaveLevel[x]) ++ ":" ++ show(x) ++ "\n" | x in Enclave ] ;
output ["=======================================" ++ "\n" ++ "Assignments for classes:\n" ++ "=======================================" ++ "\n"];

output [" Class : " ++ show(x) ++ " -> " ++ show(classEnclave[x]) ++ "\n" | x in classNames ] ;
% output [" Class : " ++ show(x) ++ " -> " ++ show(classEnclave[x]) ++ "\n" | x in classNames where x != sharedClass] ;
output ["Cross-domain cut:" ++ "\n"];
output [" XDCALL   : "  ++ show(hasSource[e]) ++ ":" ++ show(taint[hasSource[e]]) ++ " "
                       ++ "--[" ++ show(nodeEnclave[hasFunction[hasSource[e]]]) ++ "]"
                       ++ "--||-->"
                       ++ "[" ++ show(nodeEnclave[hasDest[e]]) ++ "]-- "
                       ++ show(hasDest[e]) ++ ":" ++ show(taint[hasDest[e]])
                       ++ "\n"
        | e in ControlDep_CallInv where fix(xdedge[e]==true)] ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
