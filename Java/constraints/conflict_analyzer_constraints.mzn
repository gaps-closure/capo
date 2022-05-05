% include "conflict_variable_declarations.mzn";
% include "./instance/classInfo.mzn";  
% include "./instance/cle_instance.mzn";  
% include "./instance/enclave_instance.mzn";  
% include "./instance/pdg_instance.mzn";




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

predicate isFunctionEntry(var PDGNodeIdx: n)   = (n>=FunctionEntry_start /\ n<=FunctionEntry_end);
predicate isFunCall(var PDGEdgeIdx: e)   = (e>=ControlDep_CallInv_start /\ e<=ControlDep_CallInv_end);
predicate isFunRet(var PDGEdgeIdx: e)   = (e>=ControlDep_CallRet_start /\ e<=ControlDep_CallRet_end);
predicate isParameter(var PDGEdgeIdx: e)   = ((e>=Parameter_In_start /\ e<=Parameter_In_end) \/ (e>=Parameter_Out_start /\ e<=Parameter_Out_end));
predicate isCDOther(var PDGEdgeIdx: e)   = (e>=ControlDep_Other_start /\ e<=ControlDep_Other_end);

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

array[ClassNames,nonNullEnclave] of var bool: classEnclave;
array[ClassNames,Level]   of var bool: classTaintedAtLevel;

constraint :: "BindClassLevelToEnclave" 
forall (cl in ClassNames)
  (forall (e in nonNullEnclave)
    (classTaintedAtLevel[cl, hasEnclaveLevel[e]] == classEnclave[cl,e])
  );

constraint :: "BindClassTaintedAtLevel" 
forall (n in PDGNodeIdx)
(
  (forall (e in nonNullEnclave)
    (classTaintedAtLevel[hasClass[n], hasLabelLevel[taint[n,e]]] == true)
  )
);

constraint :: "CheckFieldTaint"
forall (method in FunctionEntry)
(
  forall(field in methodsFieldAccess[method])
  (
    forall (l in nonNullEnclave) 
    (
      hasLabelLevel[fieldTaint[field,l]] == hasLabelLevel[ctaint[hasClass[method],l]] /\
      (
      if userAnnotatedFunction[method]==false
      then
        (fieldTaint[field,l] == ftaint[method,l])
      else
        (if field in ClassFields_Static
        then
        % static field can become multiply tainted at this point since inside annotated function
          false
        else
          true
        endif)
      endif
      )
    )
  )
);

% constraint :: "ClassCannotHaveNullEnclave"               
% forall (cl in ClassNames)
% ( forall(e in nonNullEnclave) 
% (nullEnclave!=classEnclave[cl, e]));

% constraint :: "BindAnnoClassToEnclaveLevel"
% forall (cl in ClassNames)
% ( forall(l1 in nonNullEnclave) 
% (forall(l2 in nonNullEnclave) 
% ((isClassAnnotated[cl]) -> classEnclave[cl, e1] == classEnclave[cl, e2])));

% constraint :: "BindUnannoClassToEnclave"       
% forall (cl in ClassNames)
% ( forall(l in nonNullEnclave) 
% ((not isClassAnnotated[cl]) -> l == classEnclave[cl, l]));

% constraint :: "BindFunctionToClass"
% forall (n in FunctionEntry)
% ( forall(l in nonNullEnclave) 
% ( nodeEnclave[n,l]==classEnclave[hasClass[n], nodeLevel[n,l]]));

constraint :: "NodeLevelAtTaintLevel"         
forall (n in NonAnnotation)      
( forall(l in nonNullEnclave) 
( nodeLevel[n,l]==hasLabelLevel[taint[n,l]]));

constraint :: "NodeLevelAtEnclaveLevel"       
forall (n in NonAnnotation)      
( forall(l in nonNullEnclave) 
( nodeLevel[n,l]==hasEnclaveLevel[nodeEnclave[n,l]]));

constraint :: "CannotBeNullEnclave"       
forall (n in NonAnnotation)      
( forall(l in nonNullEnclave) 
( nullEnclave != nodeEnclave[n,l]));

constraint :: "FnAnnotationForFnOnly"         
forall (n in NonAnnotation)      
( forall(l in nonNullEnclave)
(isFunctionAnnotation[taint[n,l]] -> isFunctionEntry(n)));

constraint :: "FnAnnotationByUserOnly"        
forall (n in FunctionEntry)      
( forall(l in nonNullEnclave)
(isFunctionAnnotation[taint[n,l]] == userAnnotatedFunction[n]));

constraint :: "UnannotatedClassSinglyTainted"
 forall (n in PDGNodeIdx) 
 (forall (l in nonNullEnclave) 
 ((not isClassAnnotated[hasClass[n]]) -> ctaint[hasClass[n],l] == taint[n,l]));


% constraint :: "BindFieldTaintstoFunctions"
% forall (method in FunctionEntry)
% (
%   forall(field in methodsFieldAccess[method])
%   (
%     forall (l in nonNullEnclave) 
%     (
%       if userAnnotatedFunction[method]==false
%       then
%         (fieldTaint[field,l] == ftaint[method,l])
%       else
%         (if field in ClassFields_Static
%         then
%           false
%         else
%           true
%         endif)
%       endif
%     )
%   )
% );



constraint :: "UnannotatedFunContentTaintMatch"
 forall (n in PDGNodeIdx) 
 (forall (l in nonNullEnclave) 
 (userAnnotatedFunction[hasFunction[n]]==false -> taint[n,l]==ftaint[n,l]));


constraint :: "ForceAnnotFuncToAnnoLvl"
forall (n in FunctionEntry) 
(forall (l in nonNullEnclave) 
(userAnnotatedFunction[hasFunction[n]] -> hasLabelLevel[taint[n,l]]==hasLabelLevel[ftaint[n,l]]));

constraint :: "AnnotatedFunContentCoercible"
 forall (n in PDGNodeIdx where  isFunctionEntry(n)==false)  
 (forall (l in nonNullEnclave)
  (userAnnotatedFunction[hasFunction[n]] -> isInArctaint(ftaint[n,l], taint[n,l], hasLabelLevel[taint[n,l]])));

constraint :: "EdgeSourceEnclave"             
forall (e in PDGEdgeIdx)        
(forall (l in nonNullEnclave) 
(esEnclave[e,l]==nodeEnclave[hasSource[e],l]));

constraint :: "EdgeDestEnclave"               
forall (e in PDGEdgeIdx)        
(forall (l in nonNullEnclave) 
(edEnclave[e,l]==nodeEnclave[hasDest[e],l]));

constraint :: "EdgeInEnclaveCut"              
forall (e in PDGEdgeIdx)         
(
  if (isClassAnnotated[hasClass[hasDest[e]]] == true)
  then
  (
    forall (l in nonNullEnclave) 
      (xdedge[e,l]==(esEnclave[e,l]!=edEnclave[e,l]))
  )
  else
  (
    forall (l in nonNullEnclave)  
      (esEnclave[e,l]!=edEnclave[e,l] -> classTaintedAtLevel[hasClass[hasDest[e]], hasEnclaveLevel[l]] == true)
  )
  endif
);


constraint :: "OnlyCallsParamsAndRetsInCut"              
forall (e in ControlDep_NonCall)         
(forall (l in nonNullEnclave) 
(xdedge[e,l]==false));

constraint :: "SourceFunctionAnnotation"
 forall (e in ControlDep_CallInv union ControlDep_CallRet) 
 (forall (l in nonNullEnclave) 
 (esFunTaint[e,l] == 
 (if sourceAnnotFun(e) 
 then taint[hasFunction[hasSource[e]],l] 
 else nullCleLabel endif)));

constraint :: "DestFunctionAnnotation"
 forall (e in ControlDep_CallInv union ControlDep_CallRet) 
 (forall (l in nonNullEnclave)(edFunTaint[e,l] == 
 (if destAnnotFun(e) 
 then taint[hasFunction[hasDest[e]],l] 
 else nullCleLabel endif)));

constraint :: "SourceCdfForDestLevel"
 forall (e in ControlDep_CallInv union ControlDep_CallRet) 
 (forall (l in nonNullEnclave)(esFunCdf[e,l] == 
 (if sourceAnnotFun(e) 
 then cdfForRemoteLevel[esFunTaint[e,l], hasLabelLevel[taint[hasDest[e],l]]] 
 else nullCdf endif)));

constraint :: "DestCdfForSourceLevel"
 forall (e in ControlDep_CallInv union ControlDep_CallRet) 
 (forall (l in nonNullEnclave) (edFunCdf[e,l] == 
 (if destAnnotFun(e) then 
 cdfForRemoteLevel[edFunTaint[e,l], hasLabelLevel[taint[hasSource[e],l]]] 
 else nullCdf endif)));

constraint :: "XDCDataReturnAllowed"
 forall (e in DataDepEdge_Ret) 
 (forall (l in nonNullEnclave)  (
  xdedge[e,l] -> allowOrRedact(cdfForRemoteLevel[esFunTaint[e,l], hasLabelLevel[edTaint[e,l]]])));

constraint :: "XDCallBlest"                   
forall (e in ControlDep_CallInv) 
(forall (l in nonNullEnclave) ( ( xdedge[e,l]) -> userAnnotatedFunction[hasDest[e]]));

constraint :: "XDCallAllowed"
 forall (e in ControlDep_CallInv) 
 (forall (l in nonNullEnclave) (
 xdedge[e,l] -> allowOrRedact(cdfForRemoteLevel[edTaint[e,l], hasLabelLevel[esTaint[e,l]]])));

constraint :: "XDCParmAllowed"
 forall (e in Parameter)     
 (forall (l in nonNullEnclave)  
 (xdedge[e,l] -> allowOrRedact(cdfForRemoteLevel[esFunTaint[e,l], hasLabelLevel[edTaint[e,l]]])));


constraint :: "ArgumentTaintCoerced"
 forall (e in Parameter_In union Parameter_Out)
 (forall (l in nonNullEnclave)
  (if sourceAnnotFun(e) /\ xdedge[e,l] /\ isParam_ActualOut(hasSource[e]) /\ (hasParamIdx[hasSource[e]]>0)
   then hasArgtaints[esFunCdf[e,l], hasParamIdx[hasSource[e]], taint[hasDest[e],l]]
   else true 
   endif));


constraint :: "ReturnTaintCoerced"
 forall (e in DataDepEdge_Ret) 
 (forall (l in nonNullEnclave) 
 ((if sourceAnnotFun(e) /\ xdedge[e,l] 
 then hasRettaints[esFunCdf[e,l], taint[hasDest[e],l]]
 else true endif)));

constraint :: "DataTaintCoercedData"
 forall (e in DataEdgeNoRet)
(forall (l in nonNullEnclave)
  (if ( sourceAnnotFun(e))
   then (isInArctaint(esFunTaint[e,l], taint[hasDest[e],l], hasLabelLevel[taint[hasDest[e],l]]) /\
                       isInArctaint(esFunTaint[e,l], taint[hasSource[e],l], hasLabelLevel[taint[hasSource[e],l]]))
   else true
   endif));

% todo: add checks for statics and fields

/*
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: objective = sum(e in ControlDep_CallInv, l in nonNullEnclave where xdedge[e,l])(1);
solve minimize objective;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% output ["Domain assignments for globals:" ++ "\n"];
% output [" GLOBAL   : " ++ show(x) ++ " -> " ++ show(nodeEnclave[x]) ++ "::" ++ show(taint[x]) ++ "\n" | x in Global] ;
output ["Domain assignments for functions:" ++ "\n"];
output [" FUNCTION : " ++ show(x) ++ " -> " ++ show(nodeEnclave[x,l]) ++ "::" ++ show(taint[x,l]) ++ "\n" | x in FunctionEntry, l in nonNullEnclave ] ;



output [if debug then "Label and Enclave assignments to non-annotation nodes:\n" else "" endif];
output [" ASSIGN   : " ++
 show(n) ++ " " ++
 (if (n>=FunctionEntry_start /\ n<=FunctionEntry_end) then "FunctionEntry "
  elseif (n>=Inst_FunCall_start          /\ n<=Inst_FunCall_end)          then "FunCall          "
  elseif (n>=Inst_start          /\ n<=Inst_end)          then "Inst          "
  elseif (n>=Param_start         /\ n<=Param_end)         then "Param         "
  else                                                         "Annotation    "
  endif)
 ++ show(l) ++ " [" ++
 show(nodeEnclave[n,l])
 ++ "]::" ++ show(taint[n,l]) ++ "\n"
 | n in PDGNodeIdx, l in nonNullEnclave where debug];
 output ["=======================================" ++ "\n" ++ "Enclave Assingments\n" ++ "=======================================" ++ "\n"];
output [" Enclaves : " ++ show(hasEnclaveLevel[x]) ++ ":" ++ show(x) ++ "\n" | x in Enclave ] ;
output ["=======================================" ++ "\n" ++ "Assignments for classes:\n" ++ "=======================================" ++ "\n"];

output [" Class : " ++ show(l) ++ " : " ++ show(x) ++ " -> " ++ show(classEnclave[x, l]) ++ "\n" | x in ClassNames, l in nonNullEnclave where fix(classEnclave[x, l]==true) ] ;
% output [" Class : " ++ show(x) ++ " -> " ++ show(classEnclave[x]) ++ "\n" | x in ClassNames where x != sharedClass] ;

output ["Cross-domain cut:" ++ "\n"];
output [" XDCALL   : "  ++ show(hasSource[e]) ++ ":" ++ show(taint[hasSource[e],l]) ++ " "
                       ++ "--[" ++ show(nodeEnclave[hasFunction[hasSource[e]],l]) ++ "]"
                       ++ "--||-->"
                       ++ "[" ++ show(nodeEnclave[hasDest[e],l]) ++ "]-- "
                       ++ show(hasDest[e]) ++ ":" ++ show(taint[hasDest[e],l])
                       ++ "\n"
        | e in ControlDep_CallInv, l in nonNullEnclave where fix(xdedge[e,l]==true)] ;
% output ["Edge Map: \n"];
% output [" Edge["++ "<" ++ show(isFunCall(e) == false /\ isFunRet(e) == false /\ isParameter(e) == false) ++ ">" ++ show(e) ++", " ++ show(l) ++ "]    : "  ++ show(esEnclave[e,l]) ++ " => " ++ show(edEnclave[e,l]) ++ "\n" | e in PDGEdgeIdx, l in nonNullEnclave];
% output["EXEDGE["++ show(xdedge[e,l]) ++ "]\n"| e in PDGEdgeIdx, l in nonNullEnclave];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
