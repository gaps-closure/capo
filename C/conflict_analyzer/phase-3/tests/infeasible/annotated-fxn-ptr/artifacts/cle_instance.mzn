cleLabel = { nullCleLabel, FOO, ORANGE };
hasLabelLevel = [ nullLevel, orange, orange ];
isFunctionAnnotation = [ false, true, false ];
cdf = { nullCdf, FOO_cdf_0 };
fromCleLabel = [ nullCleLabel, FOO ];
hasRemotelevel = [ nullLevel, orange ];
hasDirection = [ nullDirection, bidirectional ];
hasGuardOperation = [ nullGuardOperation, allow ];
isOneway = [ false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf,
  nullCdf, FOO_cdf_0,
  nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false,
  false, false, true
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false,
  false, false, true
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false,
  false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false,
  false, true, true
]);