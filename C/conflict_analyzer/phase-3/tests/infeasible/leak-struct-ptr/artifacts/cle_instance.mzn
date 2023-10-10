cleLabel = { nullCleLabel, MAIN, A, B };
hasLabelLevel = [ nullLevel, orange, orange, orange ];
isFunctionAnnotation = [ false, true, false, false ];
cdf = { nullCdf, MAIN_cdf_0 };
fromCleLabel = [ nullCleLabel, MAIN ];
hasRemotelevel = [ nullLevel, orange ];
hasDirection = [ nullDirection, bidirectional ];
hasGuardOperation = [ nullGuardOperation, allow ];
isOneway = [ false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf,
  nullCdf, MAIN_cdf_0,
  nullCdf, nullCdf,
  nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false,
  false, false, true, true
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