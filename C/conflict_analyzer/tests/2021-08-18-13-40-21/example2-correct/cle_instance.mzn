cleLabel = {nullCleLabel, PURPLE , PURPLE_SHAREABLE , XDLINKAGE_GET_EWMA , TAG_RESPONSE_GET_EWMA , TAG_REQUEST_GET_EWMA , ORANGE , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , purple , purple , nullLevel , nullLevel , orange , orange , purple ]; 
isFunctionAnnotation = [false, false , false , true , false , false , false , false , false ]; 
cdf = {nullCdf, PURPLE_SHAREABLE_cdf_0 , XDLINKAGE_GET_EWMA_cdf_0 , XDLINKAGE_GET_EWMA_cdf_1 , ORANGE_cdf_0 }; 
fromCleLabel = [nullCleLabel, PURPLE_SHAREABLE , XDLINKAGE_GET_EWMA , XDLINKAGE_GET_EWMA , ORANGE ]; 
hasRemotelevel = [nullLevel, orange , orange , purple , purple ]; 
hasDirection = [nullDirection, bidirectional , bidirectional , bidirectional , egress ]; 
hasGuardOperation = [nullGuardOperation, allow , allow , allow , allow ]; 
isOneway = [false, false , false , false , false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, PURPLE_SHAREABLE_cdf_0 , nullCdf 
|nullCdf, XDLINKAGE_GET_EWMA_cdf_0 , XDLINKAGE_GET_EWMA_cdf_1 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , ORANGE_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  false , false , false , false , true  , false , false , false , false 
, false , false , false , false , true  , false , false , false , false 
 ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
  false , true  , true  , false , false , false , false , false , false 
, false , true  , true  , false , false , false , false , false , false 
 ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
  false , false , false 		, false , false , true  		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		
, false , false , false 		, false , false , true  		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		, false , false , false 		
 ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
  false , true  , true  , true  , true  , true  , false , false , false 
, false , true  , true  , true  , true  , true  , false , false , false 
 ]); 
