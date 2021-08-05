MaxFuncParms = 3;
cleLabel = {nullCleLabel, PURPLE, ORANGE, XDLINKAGE_GET_A, TAG_REQUEST_GET_A, TAG_RESPONSE_GET_A, PURPLE_DFLTLBL, ORANGE_DFLTLBL};
hasLabelLevel = [nullLevel, purple, orange, orange, nullLevel, nullLevel, purple, orange];
isFunctionAnnotation = [false, false, false, true, false, false, false, false];
cdf = {nullCdf, ORANGE_cdf_0, XDLINKAGE_GET_A_cdf_0 };
fromCleLabel = [nullCleLabel, ORANGE, XDLINKAGE_GET_A];
hasRemotelevel = [nullLevel, purple, purple];
hasDirection = [nullDirection, egress, bidirectional];
hasGuardOperation = [nullGuardOperation, allow, allow];
isOneway = [false, false, false];
cdfForRemoteLevel = [|
 nullCdf, nullCdf, nullCdf, nullCdf
|nullCdf, nullCdf, nullCdf, nullCdf
|nullCdf, nullCdf, ORANGE_cdf_0, nullCdf
|nullCdf, nullCdf, XDLINKAGE_GET_A_cdf_0, nullCdf
|nullCdf, nullCdf, nullCdf, nullCdf
|nullCdf, nullCdf, nullCdf, nullCdf
|nullCdf, nullCdf, nullCdf, nullCdf
|nullCdf, nullCdf, nullCdf, nullCdf
|];
hasRettaints = array2d(functionCdf, cleLabel, [
 false, false, false, false, false, true, false, false
]);
hasCodtaints = array2d(functionCdf, cleLabel, [
 false, false, true, false, false, false, false, false
]);
hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [
 % XDLINKAGE_GET_A_cdf_0, 1, [nullCleLabel, PURPLE, ORANGE, XDLINKAGE_GET_A, TAG_REQUEST_GET_A, TAG_RESPONSE_GET_A, PURPLE_DFLTLBL, ORANGE_DFLTLBL]
 false, false, false, false, true,  false, false, false,
 % XDLINKAGE_GET_A_cdf_0, 2, [nullCleLabel, PURPLE, ORANGE, XDLINKAGE_GET_A, TAG_REQUEST_GET_A, TAG_RESPONSE_GET_A, PURPLE_DFLTLBL, ORANGE_DFLTLBL]
 false, false, false, false, true,  false, false, false,
 % XDLINKAGE_GET_A_cdf_0, 3, [nullCleLabel, PURPLE, ORANGE, XDLINKAGE_GET_A, TAG_REQUEST_GET_A, TAG_RESPONSE_GET_A, PURPLE_DFLTLBL, ORANGE_DFLTLBL]
 false, false, false, false, false, false, false, false
]);
