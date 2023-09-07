cleLabel = { nullCleLabel, EWMA_SHAREABLE, XDLINKAGE_GET_EWMA, EWMA_MAIN, PURPLE, ORANGE, ORANGE_SHAREABLE, TAG_RESPONSE_GET_EWMA, TAG_REQUEST_GET_EWMA };
hasLabelLevel = [ nullLevel, orange, orange, purple, purple, orange, orange, nullLevel, nullLevel ];
isFunctionAnnotation = [ false, true, true, true, false, false, false, false, false ];
cdf = { nullCdf, EWMA_SHAREABLE_cdf_0, XDLINKAGE_GET_EWMA_cdf_0, XDLINKAGE_GET_EWMA_cdf_1, EWMA_MAIN_cdf_0, ORANGE_SHAREABLE_cdf_0 };
fromCleLabel = [ nullCleLabel, EWMA_SHAREABLE, XDLINKAGE_GET_EWMA, XDLINKAGE_GET_EWMA, EWMA_MAIN, ORANGE_SHAREABLE ];
hasRemotelevel = [ nullLevel, orange, orange, purple, purple, purple ];
hasDirection = [ nullDirection, egress, bidirectional, bidirectional, bidirectional, egress ];
hasGuardOperation = [ nullGuardOperation, allow, allow, allow, allow, allow ];
isOneway = [ false, false, false, false, false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, EWMA_SHAREABLE_cdf_0,
  nullCdf, XDLINKAGE_GET_EWMA_cdf_1, XDLINKAGE_GET_EWMA_cdf_0,
  nullCdf, EWMA_MAIN_cdf_0, nullCdf,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, nullCdf,
  nullCdf, ORANGE_SHAREABLE_cdf_0, nullCdf,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, true, false, false,
  false, false, false, false, false, false, false, true, false,
  false, false, false, false, false, false, false, true, false,
  false, false, false, false, true, false, false, false, false,
  false, false, false, false, false, false, false, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, true, true, false, false,
  false, false, false, false, false, true, true, false, false,
  false, false, false, false, false, true, true, false, false,
  false, false, false, false, true, false, false, true, true,
  false, false, false, false, false, false, false, false, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false, false,
  false, true, false, false, false, true, true, false, false,
  false, false, true, false, false, true, true, true, false,
  false, false, true, false, false, true, true, true, false,
  false, false, false, true, true, false, false, true, true,
  false, false, false, false, false, false, false, false, false
]);