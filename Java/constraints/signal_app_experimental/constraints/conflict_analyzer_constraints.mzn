%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility functions and predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic constraints on output decision variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Level of class with annotated elements determined by annotation level, which must match across elements of class
constraint :: "UserAnnotation"
 forall (x in AnnotatedElement) (boundLevel[hasClass[x]] = hasLabelLevel[hasAnnotation[x]]);

% A class with no annotated elements touches all 
%constraint :: "LevelTouched"
% forall (x in UnannotatedClass)
%  (forall (l in ValidLevel) 
%   (labelAtLevel[x,l] != nullCleLabel -> touchesLevel[x,l]));

% For each call edge, if the 

% Two annotated in cut causes peers 

%  forall x in Class
%    (forall e in Enclave where e != nullEnclave
%      (touchesLevel[x, hasLabelLevel[e]] -> hasEnclave[x,e]));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve satisfy;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output ["Enclave assignements:" ++ "\n"];
output [" AnnotatedClass:   " ++ show(c) ++ " -> [" ++ show(e) ++ "]::" ++ show(hasEnclaveLevel[e]) ++ "\n" 
        | c in AnnotatedClass, e in ValidEnclave where fix(boundLevel[c]) = hasEnclaveLevel[e]];
output [" UnannotatedClass: " ++ show(c) ++ " -> [" ++ show(e) ++ "]::" ++ show(hasEnclaveLevel[e]) ++ "\n" 
        | c in UnannotatedClass, e in ValidEnclave where fix(labelAtLevel[c,hasEnclaveLevel[e]]) != nullCleLabel];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
