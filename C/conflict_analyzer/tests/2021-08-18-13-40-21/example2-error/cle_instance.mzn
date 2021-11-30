cleLabel = {nullCleLabel, PURPLE , XDLINKAGE_GET_EWMA , TAG_RESPONSE_GET_EWMA , TAG_REQUEST_GET_EWMA , ORANGE , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , purple , nullLevel , nullLevel , orange , orange , purple ]; 
isFunctionAnnotation = [false, false , true , false , false , false , false , false ]; 
cdf = {nullCdf, XDLINKAGE_GET_EWMA_cdf_0 , ORANGE_cdf_0 }; 
fromCleLabel = [nullCleLabel, XDLINKAGE_GET_EWMA , ORANGE ]; 
hasRemotelevel = [nullLevel, orange , purple ]; 
hasDirection = [nullDirection, bidirectional , egress ]; 
hasGuardOperation = [nullGuardOperation, allow , allow ]; 
isOneway = [false, false , false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, XDLINKAGE_GET_EWMA_cdf_0 , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , ORANGE_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  false , false , false , true  , false , false , false , false 
 ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
  false , true  , false , false , false , false , false , false 
 ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
  false , false , false 		, false , true  , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		
 ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
  false , true  , true  , true  , true  , false , false , false 
 ]); 
