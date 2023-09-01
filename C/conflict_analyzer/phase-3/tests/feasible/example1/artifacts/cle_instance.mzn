cleLabel = { nullCleLabel, EWMA_MAIN, XDLINKAGE_GET_A, PURPLE, ORANGE, TAG_RESPONSE_GET_A };
hasLabelLevel = [ nullLevel, purple, orange, purple, orange, nullLevel ];
isFunctionAnnotation = [ false, true, true, false, false, false ];
cdf = { nullCdf, EWMA_MAIN_cdf_0, XDLINKAGE_GET_A_cdf_0, XDLINKAGE_GET_A_cdf_1, ORANGE_cdf_0 };
fromCleLabel = [ nullCleLabel, EWMA_MAIN, XDLINKAGE_GET_A, XDLINKAGE_GET_A, ORANGE ];
hasRemotelevel = [ nullLevel, purple, purple, orange, purple ];
hasDirection = [ nullDirection, bidirectional, bidirectional, bidirectional, egress ];
hasGuardOperation = [ nullGuardOperation, allow, allow, allow, allow ];
isOneway = [ false, false, false, false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, EWMA_MAIN_cdf_0,
  nullCdf, XDLINKAGE_GET_A_cdf_1, XDLINKAGE_GET_A_cdf_0,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, ORANGE_cdf_0,
  nullCdf, nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false,
  false, false, false, true, false, false,
  false, false, false, false, false, true,
  false, false, false, false, false, true,
  false, false, false, false, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false,
  false, false, false, true, false, true,
  false, false, false, false, true, false,
  false, false, false, false, true, false,
  false, false, false, false, false, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false,
  false, true, false, true, false, true,
  false, false, true, false, true, true,
  false, false, true, false, true, true,
  false, false, false, false, false, false
]);