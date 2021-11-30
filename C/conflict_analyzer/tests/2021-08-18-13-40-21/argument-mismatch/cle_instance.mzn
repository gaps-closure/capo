cleLabel = {nullCleLabel, PURPLE , ORANGE , TAG_RESPONSE_FOO , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , orange , nullLevel , orange , purple ]; 
isFunctionAnnotation = [false, false , true , false , false , false ]; 
cdf = {nullCdf, ORANGE_cdf_0 }; 
fromCleLabel = [nullCleLabel, ORANGE ]; 
hasRemotelevel = [nullLevel, purple ]; 
hasDirection = [nullDirection, egress ]; 
hasGuardOperation = [nullGuardOperation, allow ]; 
isOneway = [false, false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , ORANGE_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  false , false , true  , true  , false , false 
 ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
  false , false , true  , false , false , false 
 ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
  false , false , true  		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		
 ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
  false , false , true  , true  , false , false 
 ]); 
