cleLabel = {nullCleLabel, PURPLE , ORANGE , XD_FOO , TAG_RESPONSE_FOO , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , orange , orange , nullLevel , orange , purple ]; 
isFunctionAnnotation = [false, false , false , true , false , false , false ]; 
cdf = {nullCdf, XD_FOO_cdf_0 }; 
fromCleLabel = [nullCleLabel, XD_FOO ]; 
hasRemotelevel = [nullLevel, purple ]; 
hasDirection = [nullDirection, egress ]; 
hasGuardOperation = [nullGuardOperation, allow ]; 
isOneway = [false, false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , XD_FOO_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  false , false , true  , false , true  , false , false 
 ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
  false , false , true  , false , false , false , false 
 ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
  false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		
 ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
  false , false , true  , true  , true  , false , false 
 ]); 
