cleLabel = {nullCleLabel, PURPLE , ORANGE , XDLINKAGE_GET_A , TAG_RESPONSE_GET_A , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , orange , orange , nullLevel , orange , purple ]; 
isFunctionAnnotation = [false, false , false , true , false , false , false ]; 
cdf = {nullCdf, ORANGE_cdf_0 , XDLINKAGE_GET_A_cdf_0 }; 
fromCleLabel = [nullCleLabel, ORANGE , XDLINKAGE_GET_A ]; 
hasRemotelevel = [nullLevel, purple , purple ]; 
hasDirection = [nullDirection, egress , bidirectional ]; 
hasGuardOperation = [nullGuardOperation, allow , allow ]; 
isOneway = [false, false , false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , ORANGE_cdf_0 
|nullCdf, nullCdf , XDLINKAGE_GET_A_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
  false , false , false , false , true  , false , false 
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
