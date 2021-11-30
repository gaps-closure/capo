cleLabel = {nullCleLabel, PURPLE , XD_BAR , TAG_RESPONSE_GET_EWMA , PURPLE_SHAREABLE , TAG_REQUEST_GET_EWMA , ORANGE , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , purple , nullLevel , nullLevel , nullLevel , orange , orange , purple ]; 
isFunctionAnnotation = [false, false , true , false , false , false , false , false , false ]; 
cdf = {nullCdf, XD_BAR_cdf_0 , XD_BAR_cdf_1 , ORANGE_cdf_0 }; 
fromCleLabel = [nullCleLabel, XD_BAR , XD_BAR , ORANGE ]; 
hasRemotelevel = [nullLevel, orange , purple , purple ]; 
hasDirection = [nullDirection, bidirectional , bidirectional , egress ]; 
hasGuardOperation = [nullGuardOperation, allow , allow , allow ]; 
isOneway = [false, false , false , false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, XD_BAR_cdf_0 , XD_BAR_cdf_1 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , ORANGE_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  false , false , false , false , false , false , false , false , false 
, false , false , false , true  , false , false , false , false , false 
 ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
  false , false , false , false , false , false , false , false , false 
, false , true  , false , false , true  , false , false , false , false 
 ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
  false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		
, false , false , false 		, false , false , true  		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		
 ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
 

 ]); 
