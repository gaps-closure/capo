cleLabel = {nullCleLabel, PURPLE , ORANGE , ORANGE_SHAREABLE , XD_ORANGE , TAG_RESPONSE_GET_FOO , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , orange , orange , orange , nullLevel , orange , purple ]; 
isFunctionAnnotation = [false, false , false , false , true , false , false , false ]; 
cdf = {nullCdf, ORANGE_SHAREABLE_cdf_0 , XD_ORANGE_cdf_0 }; 
fromCleLabel = [nullCleLabel, ORANGE_SHAREABLE , XD_ORANGE ]; 
hasRemotelevel = [nullLevel, purple , purple ]; 
hasDirection = [nullDirection, egress , egress ]; 
hasGuardOperation = [nullGuardOperation, allow , allow ]; 
isOneway = [false, false , false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , ORANGE_SHAREABLE_cdf_0 
|nullCdf, nullCdf , XD_ORANGE_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  false , false , true  , true  , false , true  , false , false 
 ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
  false , false , true  , false , false , false , false , false 
 ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
  false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		
 ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
  false , false , true  , true  , true  , true  , false , false 
 ]); 
