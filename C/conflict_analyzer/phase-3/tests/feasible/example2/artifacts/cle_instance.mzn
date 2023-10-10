cleLabel = { nullCleLabel, XDLINKAGE_GET_EWMA, EWMA_MAIN, PURPLE, PURPLE_SHAREABLE, ORANGE, TAG_RESPONSE_GET_EWMA, TAG_REQUEST_GET_EWMA };
hasLabelLevel = [ nullLevel, purple, orange, purple, purple, orange, nullLevel, nullLevel ];
isFunctionAnnotation = [ false, true, true, false, false, false, false, false ];
cdf = { nullCdf, XDLINKAGE_GET_EWMA_cdf_0, XDLINKAGE_GET_EWMA_cdf_1, EWMA_MAIN_cdf_0, PURPLE_SHAREABLE_cdf_0, ORANGE_cdf_0 };
fromCleLabel = [ nullCleLabel, XDLINKAGE_GET_EWMA, XDLINKAGE_GET_EWMA, EWMA_MAIN, PURPLE_SHAREABLE, ORANGE ];
hasRemotelevel = [ nullLevel, orange, purple, orange, orange, purple ];
hasDirection = [ nullDirection, bidirectional, bidirectional, bidirectional, bidirectional, egress ];
hasGuardOperation = [ nullGuardOperation, allow, allow, allow, allow, allow ];
isOneway = [ false, false, false, false, false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf, nullCdf,
  nullCdf, XDLINKAGE_GET_EWMA_cdf_0, XDLINKAGE_GET_EWMA_cdf_1,
  nullCdf, EWMA_MAIN_cdf_0, nullCdf,
  nullCdf, nullCdf, nullCdf,
  nullCdf, PURPLE_SHAREABLE_cdf_0, nullCdf,
  nullCdf, nullCdf, ORANGE_cdf_0,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, true, false,
  false, false, false, false, false, false, true, false,
  false, false, false, false, false, true, false, false,
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false,
  false, false, false, true, true, false, false, false,
  false, false, false, true, true, false, false, false,
  false, false, false, false, false, true, true, true,
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false,
  false, true, false, true, true, false, true, true,
  false, true, false, true, true, false, true, true,
  false, false, true, false, false, true, true, true,
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false
]);