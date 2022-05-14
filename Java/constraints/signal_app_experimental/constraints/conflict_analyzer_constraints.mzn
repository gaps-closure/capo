%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "UserAnnotationBindsUniqueLevel"
 forall (x in AnnotatedElement) (boundLevel[hasClass[x]] = hasLabelLevel[hasAnnotation[x]]);

/*
array[Class,ValidLevel] of var bool: touchesLevel;
array[Edge,ValidLevel] of var bool: stouchesLevel;
array[Edge,ValidLevel] of var bool: dtouchesLevel;
array[Call] of var bool: xdedge;

constraint :: "c1"
 forall (x in Access) (xdedge[x] = false);

constraint :: "c2"
 forall (x in Call)
  (if   (hasFrom[x] in AnnotatedElement /\ hasTo[x] in AnnotatedElement) 
   then (xdedge[x] <-> hasLabelLevel[hasAnnotation[hasFrom[x]]] != hasLabelLevel[hasAnnotation[hasTo[x]]])
   else (xdedge[x] = false) 
   endif);

constraint :: "c5"
 forall (x in Edge where hasFrom[x] in AnnotatedElement)
  (stouchesLevel[x, hasLabelLevel[hasAnnotation[hasFrom[x]]]] = true);

constraint :: "c6"
 forall (x in Edge where hasTo[x] in AnnotatedElement)
  (dtouchesLevel[x, hasLabelLevel[hasAnnotation[hasTo[x]]]] = true);

constraint :: "c7"
 forall (x in Edge)
  (forall (l in ValidLevel) (xdedge[x] = false -> stouchesLevel[x,l] = dtouchesLevel[x,l]));

constraint :: "c8"
 forall (x in Edge)
  (let {Class: c = hasClass[hasFrom[x]];} in
   (forall (l in ValidLevel) (stouchesLevel[x,l] -> touchesLevel[c,l])));

constraint :: "c9"
 forall (x in Edge)
  (let {Class: c = hasClass[hasTo[x]];} in
   (forall (l in ValidLevel) (dtouchesLevel[x,l] -> touchesLevel[c,l])));
*/

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
        | e in ValidEnclave, c in AnnotatedClass 
          where fix(boundLevel[c]) = hasEnclaveLevel[e]];

output [" UnannotatedClass: " ++ show(c) ++ " [" ++ show(e) ++ "@" ++ show(hasEnclaveLevel[e]) ++ "]" ++ "\n" 
        | e in ValidEnclave, l in Level, c in UnannotatedClass 
          where (hasEnclaveLevel[e] = l /\ hasLabelLevel[fix(labelAtLevel[c,l])] = l)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
