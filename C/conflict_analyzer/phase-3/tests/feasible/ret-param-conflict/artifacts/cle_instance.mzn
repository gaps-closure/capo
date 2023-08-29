cleLabel = { nullCleLabel, FOO, MAIN, A, B, C };
hasLabelLevel = [ nullLevel, orange, orange, orange, orange, orange ];
isFunctionAnnotation = [ false, true, true, false, false, false ];
cdf = { nullCdf, FOO_cdf_0, MAIN_cdf_0 };
fromCleLabel = [ nullCleLabel, FOO, MAIN ];
hasRemotelevel = [ nullLevel, orange, orange ];
hasDirection = [ nullDirection, bidirectional, bidirectional ];
hasGuardOperation = [ nullGuardOperation, allow, allow ];
isOneway = [ false, false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf,
  nullCdf, FOO_cdf_0,
  nullCdf, MAIN_cdf_0,
  nullCdf, nullCdf,
  nullCdf, nullCdf,
  nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false,
  false, false, false, false, true, false,
  false, false, false, false, false, true
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false,
  false, false, false, true, true, false,
  false, false, false, true, true, true
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false, false,
  false, false, false, true, false, false,
  false, false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false,
  false, true, false, true, true, false,
  false, false, true, true, true, true
]);