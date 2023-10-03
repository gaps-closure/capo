cleLabel = { nullCleLabel, FOO, GREEN, GREEN_SHAREABLE, ORANGE, ORANGE_SHAREABLE, TAG_RESPONSE_FOO, TAG_REQUEST_FOO };
hasLabelLevel = [ nullLevel, orange, green, green, orange, orange, nullLevel, nullLevel ];
isFunctionAnnotation = [ false, true, false, false, false, false, false, false ];
cdf = { nullCdf, FOO_cdf_0, FOO_cdf_1, GREEN_SHAREABLE_cdf_0, ORANGE_SHAREABLE_cdf_0 };
fromCleLabel = [ nullCleLabel, FOO, FOO, GREEN_SHAREABLE, ORANGE_SHAREABLE ];
hasRemotelevel = [ nullLevel, orange, green, orange, green ];
hasDirection = [ nullDirection, egress, egress, egress, egress ];
hasGuardOperation = [ nullGuardOperation, allow, allow, allow, allow ];
isOneway = [ false, false, false, false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf, nullCdf,
  nullCdf, FOO_cdf_0, FOO_cdf_1,
  nullCdf, nullCdf, nullCdf,
  nullCdf, GREEN_SHAREABLE_cdf_0, nullCdf,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, ORANGE_SHAREABLE_cdf_0,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, true, true, false,
  false, false, false, false, false, true, true, false,
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false,
  false, false, false, false, true, true, false, false,
  false, false, false, false, true, true, false, false,
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, true, false, true,
  false, false, false, false, false, true, false, true,
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false, false,
  false, true, false, false, true, true, true, true,
  false, true, false, false, true, true, true, true,
  false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false
]);