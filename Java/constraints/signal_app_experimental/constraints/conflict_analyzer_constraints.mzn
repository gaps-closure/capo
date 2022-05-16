%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
array[Edge]                        of var bool:     xdedge;
array[Class,ValidLevel]            of var bool:     touchesLevel;
array[UnannotatedClass,ValidLevel] of var cleLabel: labelAtLevel;

constraint :: "NoXDFieldAccess"
 forall (x in Access) (xdedge[x] = false);

constraint :: "XDIffAnnotatedEndpointsAtDifferentLevels"
 forall (x in Call)
  (if   (hasFrom[x] in AnnotatedElement /\ hasTo[x] in AnnotatedElement) 
   then (xdedge[x] <-> hasLabelLevel[hasAnnotation[hasFrom[x]]] != hasLabelLevel[hasAnnotation[hasTo[x]]])
   else (xdedge[x] = false) 
   endif);

constraint :: "UserAnnotationBindsUniqueLevel"
 forall (x in AnnotatedElement) 
  (let {Class: c = hasClass[x];} in
   (forall (l in ValidLevel) (touchesLevel[c,l] <-> hasLabelLevel[hasAnnotation[x]] = l)));

constraint :: "c4"
 forall (x in Edge)
  (let {Class: s = hasClass[hasFrom[x]]; Class: d = hasClass[hasTo[x]];} in
   (xdedge[x] = false -> (forall (l in ValidLevel) (touchesLevel[s,l] = touchesLevel[d,l]))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve satisfy;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output ["Call edges in cut:" ++ "\n"];

output [" Cut: " 
        ++ show(hasClass[hasFrom[x]]) ++ "::" ++ show(hasFrom[x]) ++ " [" ++ " @" ++ show(fix(boundLevel[hasClass[hasFrom[x]]])) ++ " ]"
        ++ " -> "
        ++ show(hasClass[hasTo[x]]) ++ "::" ++ show(hasTo[x]) ++ " [" ++ " @" ++ show(fix(boundLevel[hasClass[hasTo[x]]])) ++ " ]" ++ "\n"
        | x in Call 
          where (hasClass[hasFrom[x]] in AnnotatedClass) /\ (hasClass[hasTo[x]] in AnnotatedClass) /\ 
                 fix(boundLevel[hasClass[hasFrom[x]]]) != fix(boundLevel[hasClass[hasTo[x]]])];

output ["\nEnclave assignments:" ++ "\n"];

output [" AnnotatedClass: " ++ show(c) ++ " [" ++ show(e) ++ "@" ++ show(hasEnclaveLevel[e]) ++ "]" ++ "\n" 
        | e in ValidEnclave, l in Level, c in AnnotatedClass 
          where (fix(touchesLevel[c,l]) /\ hasEnclaveLevel[e] = l)];

output [" UnannotatedClass: " ++ show(c) ++ " [" ++ show(e) ++ "@" ++ show(hasEnclaveLevel[e]) ++ "]" ++ "\n" 
        | e in ValidEnclave, l in Level, c in UnannotatedClass 
          where (fix(touchesLevel[c,l]) /\ hasEnclaveLevel[e] = l)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
