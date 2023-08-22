cleLabel = { nullCleLabel, BAR, ORANGE_NOSHARE, ORANGE_SHARE };
hasLabelLevel = [ nullLevel, orange, orange, orange ];
isFunctionAnnotation = [ false, true, false, false ];
cdf = { nullCdf, BAR_cdf_0 };
fromCleLabel = [ nullCleLabel, BAR ];
hasRemotelevel = [ nullLevel, orange ];
hasDirection = [ nullDirection, bidirectional ];
hasGuardOperation = [ nullGuardOperation, allow ];
isOneway = [ false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf,
  nullCdf, BAR_cdf_0,
  nullCdf, nullCdf,
  nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, false, false, true
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, false, true, true
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false,
  false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, true, true, true
]);