cleLabel = { nullCleLabel, ORANGE_1, ORANGE_2 };
hasLabelLevel = [ nullLevel, orange, orange ];
isFunctionAnnotation = [ false, false, false ];
cdf = { nullCdf };
fromCleLabel = [ nullCleLabel ];
hasRemotelevel = [ nullLevel ];
hasDirection = [ nullDirection ];
hasGuardOperation = [ nullGuardOperation ];
isOneway = [ false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf,
  nullCdf, nullCdf,
  nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false
]);