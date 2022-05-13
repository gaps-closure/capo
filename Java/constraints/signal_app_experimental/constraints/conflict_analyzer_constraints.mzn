%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint :: "UserAnnotationBindsUniqueLevel"
 forall (x in AnnotatedElement) (boundLevel[hasClass[x]] = hasLabelLevel[hasAnnotation[x]]);

%constraint :: "LabelsMatchIfEndpointsUnannotated"
% forall (x in Edge where isUnannotatedClass(hasClass[hasFrom[x]]) /\ isUnannotatedClass(hasClass[hasTo[x]]))
%  (forall (l in ValidLevel) (labelAtLevel[hasClass[hasFrom[x]],l] = labelAtLevel[hasClass[hasTo[x]],l]));

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
