cleLabel = { nullCleLabel, FOO, A, B, C };
hasLabelLevel = [ nullLevel, orange, orange, orange, orange ];
isFunctionAnnotation = [ false, true, false, false, false ];
cdf = { nullCdf, FOO_cdf_0 };
fromCleLabel = [ nullCleLabel, FOO ];
hasRemotelevel = [ nullLevel, orange ];
hasDirection = [ nullDirection, bidirectional ];
hasGuardOperation = [ nullGuardOperation, allow ];
isOneway = [ false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf,
  nullCdf, FOO_cdf_0,
  nullCdf, nullCdf,
  nullCdf, nullCdf,
  nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false, false,
  false, false, true, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false,
  false, false, true, true, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false,
  false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false,
  false, true, true, true, false
]);