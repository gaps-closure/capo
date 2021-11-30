cleLabel = {nullCleLabel, ORANGE , EMBEDDING_SHAREABLE , PURPLE , XDLINKAGE_RECOGNIZE , TAG_RESPONSE_RECOGNIZE , TAG_REQUEST_RECOGNIZE , XDLINKAGE_START_RECOGNIZER , TAG_RESPONSE_START_RECOGNIZER , TAG_REQUEST_START_RECOGNIZER , XDLINKAGE_STOP_RECOGNIZER , TAG_RESPONSE_STOP_RECOGNIZER , TAG_REQUEST_STOP_RECOGNIZER , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, orange , orange , purple , purple , nullLevel , nullLevel , purple , nullLevel , nullLevel , purple , nullLevel , nullLevel , orange , purple ]; 
isFunctionAnnotation = [false, false , false , false , true , false , false , true , false , false , true , false , false , false , false ]; 
cdf = {nullCdf, EMBEDDING_SHAREABLE_cdf_0 , XDLINKAGE_RECOGNIZE_cdf_0 , XDLINKAGE_START_RECOGNIZER_cdf_0 , XDLINKAGE_STOP_RECOGNIZER_cdf_0 }; 
fromCleLabel = [nullCleLabel, EMBEDDING_SHAREABLE , XDLINKAGE_RECOGNIZE , XDLINKAGE_START_RECOGNIZER , XDLINKAGE_STOP_RECOGNIZER ]; 
hasRemotelevel = [nullLevel, purple , orange , orange , orange ]; 
hasDirection = [nullDirection, egress , bidirectional , bidirectional , bidirectional ]; 
hasGuardOperation = [nullGuardOperation, allow , allow , allow , allow ]; 
isOneway = [false, false , false , false , false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , EMBEDDING_SHAREABLE_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, XDLINKAGE_RECOGNIZE_cdf_0 , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, XDLINKAGE_START_RECOGNIZER_cdf_0 , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, XDLINKAGE_STOP_RECOGNIZER_cdf_0 , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  false , false , false , false , false , true  , false , false , false , false , false , false , false , false , false 
, false , false , false , false , false , false , false , false , true  , false , false , false , false , false , false 
, false , false , false , false , false , false , false , false , false , false , false , true  , false , false , false 
 ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
  false , false , false , true  , false , false , false , false , false , false , false , false , false , false , false 
, false , false , false , true  , false , false , false , false , false , false , false , false , false , false , false 
, false , false , false , true  , false , false , false , false , false , false , false , false , false , false , false 
 ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
  false , false , false , false , false , false , true  , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		
, false , false , false , false , false , false , false , false , false 		, true  , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		
, false , false , false , false , false , false , false , false , false 		, false , false , false , true  , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		, false , false , false , false , false , false , false , false , false 		
 ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
  false , false , false , true  , true  , true  , true  , false , false , false , false , false , false , false , false 
, false , false , false , true  , false , false , false , true  , true  , true  , false , false , false , false , false 
, false , false , false , true  , false , false , false , false , false , false , true  , true  , true  , false , false 
 ]); 
