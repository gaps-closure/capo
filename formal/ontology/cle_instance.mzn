cleLabel = {nullCleLabel, PURPLE , ORANGE , EWMA_SHAREABLE , XDLINKAGE_GET_EWMA , TAG_RESPONSE_GET_EWMA , orangeDFLT , purpleDFLT }; 
hasLabelLevel = [nullLevel, purple , orange , orange , orange , nullLevel , orange , purple ]; 
isFunctionAnnotation = [false, false , false , true , true , false , false , false ]; 
cdf = {nullCdf, EWMA_SHAREABLE_cdf_0 , XDLINKAGE_GET_EWMA_cdf_0 }; 
fromCleLabel = [nullCleLabel, EWMA_SHAREABLE , XDLINKAGE_GET_EWMA ]; 
hasRemotelevel = [nullLevel, purple , purple ]; 
hasDirection = [nullDirection, egress , bidirectional ]; 
hasGuardOperation = [nullGuardOperation, allow , allow ]; 
isOneway = [false, false , false ]; 
cdfForRemoteLevel = [|
 nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , EWMA_SHAREABLE_cdf_0 
|nullCdf, nullCdf , XDLINKAGE_GET_EWMA_cdf_0 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|nullCdf, nullCdf , nullCdf 
|]; 
hasRettaints = array2d(functionCdf, cleLabel, [
 false, false , false , true , false , false , false , false , false , false , false , false , false , true , false , false 
 ]); 
hasCodtaints = array2d(functionCdf, cleLabel, [
 false, false , false , false , false , false , false , false , false , false , true , true , false , false , false , false 
 ]); 
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
 false, false , true , false , false , false , false , false , false , false , true , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false , false 
 ]); 
hasARCtaints = array2d(functionCdf, cleLabel, [
 false, false , true , true , false , false , false , false , false , false , true , true , false , true , false , false 
 ]); 
