%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision variables, utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
array[Edge]                        of var bool:     xdedge;
array[Class,ValidLevel]            of var bool:     touchesLevel;
array[Class,ValidLevel]            of var cleLabel: labelAtLevel;

predicate isAnnotatedClass(Class: x)    = x >= AnnotatedInternalClass_start           /\ x <= AnnotatedInternalClass_end;
predicate isUnannotatedClass(Class: x)  = x >= UnannotatedInternalClass_start         /\ x <= UnannotatedExternalClass_end;
predicate isAnnotatedElement(Node: x)   = x >= AnnotatedInternalInstanceField_start   /\ x <= AnnotatedInternalStaticMethod_end;
predicate isUnannotatedElement(Node: x) = x >= UnannotatedInternalInstanceField_start /\ x <= UnannotatedExternalStaticMethod_end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint :: "NoXDFieldAccess"
 forall (x in Access) (xdedge[x] = false);

constraint :: "CallEndpointAnnotationLevelsDiffer"
 forall (x in Call)
  (let { Element: se = hasFrom[x]; Class: sc = hasClass[se]; Element: de = hasTo[x]; Class: dc = hasClass[de]; } in
   (if   (isAnnotatedElement(se) /\ isAnnotatedElement(de))
    then (xdedge[x] = (hasLabelLevel[hasAnnotation[se]] != hasLabelLevel[hasAnnotation[de]]))
    else (xdedge[x] = false)
    endif));

constraint :: "UserAnnotationBindsUniqueLevel"
 forall (x in AnnotatedElement, l in ValidLevel)
  (let {Class: c = hasClass[x];} in (touchesLevel[c,l] <-> hasLabelLevel[hasAnnotation[x]] = l));

constraint :: "LevelTouched"
 forall (x in Edge, l in ValidLevel)
  (let { Element: se = hasFrom[x]; Class: sc = hasClass[se]; Element: de = hasTo[x]; Class: dc = hasClass[de]; } in
   (xdedge[x] = false -> touchesLevel[sc,l] = touchesLevel[dc,l]));

constraint :: "ClassLabelAtLevelTouched"
 forall (x in Class, l in ValidLevel) 
  (touchesLevel[x,l]  -> (hasLabelLevel[labelAtLevel[x,l]] = l /\ isFunctionAnnotation[labelAtLevel[x,l]] = false));

% +--+----+--+--+--+--+-------------------------------------------------------------------
% |xd|call|sc|se|dc|de|constrain labels on endpoints of edges 
% +--+----+--+--+--+--+-------------------------------------------------------------------
% |N |N   |* |U |A |A |sc label matches de label at touched level
% |N |N   |A |A |A |A |de label in ARCtaints of se label at touched level
% |N |*   |A |A |* |U |dc label in ARCtaints of se label at touched level
% |N |*   |* |U |* |U |sc and dc have same label at each touched level
% |N |Y   |* |U |A |A |unannot calls anno method at applicable level
% |N |Y   |A |A |A |A |anno internal call 
% |Y |Y   |A |A |A |A |cut
% +--+----+--+--+--+--+-------------------------------------------------------------------

constraint :: "AccessXU2AA"
 forall (x in Access)
  (let { Element: se = hasFrom[x]; Class: sc = hasClass[se]; Element: de = hasTo[x]; Class: dc = hasClass[de]; } in
   (if   (isUnannotatedElement(se) /\ isAnnotatedElement(de)) 
    then (let { cleLabel: dt = hasAnnotation[de]; Level: dl = hasLabelLevel[dt]; } in
          (labelAtLevel[sc,dl] = dt))
    endif));

constraint :: "AccessAA2AA"
 forall (x in Access)
  (let { Element: se = hasFrom[x]; Class: sc = hasClass[se]; Element: de = hasTo[x]; Class: dc = hasClass[de]; } in
   (if   (isAnnotatedElement(se) /\ isAnnotatedElement(de)) 
    then (let { cleLabel: st = hasAnnotation[se]; Level: sl = hasLabelLevel[st]; cleLabel: dt = hasAnnotation[de]; } in
          (hasARCtaints[cdfForRemoteLevel[st,sl],dt] = true))
    endif));

constraint :: "EdgeAA2XU"
 forall (x in Edge)
  (let { Element: se = hasFrom[x]; Class: sc = hasClass[se]; Element: de = hasTo[x]; Class: dc = hasClass[de]; } in
   (if   (isAnnotatedElement(se) /\ isUnannotatedElement(de)) 
    then (let { cleLabel: st = hasAnnotation[se]; Level: sl = hasLabelLevel[st]; } in
          (hasARCtaints[cdfForRemoteLevel[st,sl],labelAtLevel[dc,sl]] = true))
    endif));

constraint :: "EdgeXU2XU"
 forall (x in Edge, l in ValidLevel)
  (let { Element: se = hasFrom[x]; Class: sc = hasClass[se]; Element: de = hasTo[x]; Class: dc = hasClass[de]; } in
   (if   (isUnannotatedElement(se) /\ isUnannotatedElement(de)) 
    then (touchesLevel[sc,l] /\ touchesLevel[dc,l] -> labelAtLevel[sc,l] = labelAtLevel[dc,l])
    endif));

% internal anno-call check
%  check callee can be called from caller
%  for every param index, argtaints of callee has one taint in common with all taints of caller
%  rettaints of callee has one taint in common with all taints of caller

% XXX: warn developer if static field is accessed at multiple levels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve satisfy;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output ["Call edges in cut:" ++ "\n"];

output [" Cut: "
        ++ show(hasClass[hasFrom[x]]) ++ "::" ++ show(hasFrom[x])
        ++ " [*:" ++ show(hasAnnotation[hasFrom[x]]) ++ " @" ++ show(hasLabelLevel[hasAnnotation[hasFrom[x]]]) ++ " ]"
        ++ " -> "
        ++ show(hasClass[hasTo[x]])   ++ "::" ++ show(hasTo[x])
        ++ " [*:" ++ show(hasAnnotation[hasTo[x]])   ++ " @" ++ show(hasLabelLevel[hasAnnotation[hasTo[x]]])   ++ " ]" ++ "\n"
        | x in Call where fix(xdedge[x]) = true];

output ["\nEnclave assignments:" ++ "\n"];

output [" AnnotatedClass: " ++ show(c) ++ " [" ++ show(e) ++ ":*@" ++ show(hasEnclaveLevel[e]) ++ "]" ++ "\n"
        | e in ValidEnclave, l in Level, c in AnnotatedClass
          where (fix(touchesLevel[c,l]) /\ hasEnclaveLevel[e] = l)];

output [" UnannotatedClass: " ++ show(c) ++ " [" ++ show(e) ++ ":" ++ show(fix(labelAtLevel[c,l])) ++ "@" ++ show(hasEnclaveLevel[e]) ++ "]" ++ "\n"
        | e in ValidEnclave, l in Level, c in UnannotatedClass
          where (fix(touchesLevel[c,l]) /\ hasEnclaveLevel[e] = l)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
