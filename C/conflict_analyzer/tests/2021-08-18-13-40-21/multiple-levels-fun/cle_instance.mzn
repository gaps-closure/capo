cleLabel = {nullCleLabel, PURPLE , ORANGE , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , orange , orange , purple ]; 
isFunctionAnnotation = [false, false , false , false , false ]; 
cdf = {nullCdf}; 
fromCleLabel = [nullCleLabel]; 
hasRemotelevel = [nullLevel]; 
hasDirection = [nullDirection]; 
hasGuardOperation = [nullGuardOperation]; 
isOneway = [false]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
  ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
  ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
  ]); 
