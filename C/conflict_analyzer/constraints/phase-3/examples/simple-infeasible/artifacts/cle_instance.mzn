cleLabel = { nullCleLabel, ORANGE_XD, PURPLE_XD, ORANGE_SHAREABLE, PURPLE_SHAREABLE, TAG_RESPONSE_FOO, TAG_REQUEST_FOO };
hasLabelLevel = [ nullLevel, orange, purple, orange, purple, nullLevel, nullLevel ];
isFunctionAnnotation = [ false, true, true, false, false, false, false ];
cdf = { nullCdf, ORANGE_XD_cdf_0, PURPLE_XD_cdf_0, PURPLE_XD_cdf_1, ORANGE_SHAREABLE_cdf_0, PURPLE_SHAREABLE_cdf_0 };
fromCleLabel = [ nullCleLabel, ORANGE_XD, PURPLE_XD, PURPLE_XD, ORANGE_SHAREABLE, PURPLE_SHAREABLE ];
hasRemotelevel = [ nullLevel, orange, orange, purple, purple, orange ];
hasDirection = [ nullDirection, bidirectional, bidirectional, bidirectional, egress, egress ];
hasGuardOperation = [ nullGuardOperation, allow, allow, allow, allow, allow ];
isOneway = [ false, false, false, false, false, false ];
cdfForRemoteLevel = array2d(cleLabel, Level, [
  nullCdf, nullCdf, nullCdf,
  nullCdf, ORANGE_XD_cdf_0, nullCdf,
  nullCdf, PURPLE_XD_cdf_0, PURPLE_XD_cdf_1,
  nullCdf, nullCdf, ORANGE_SHAREABLE_cdf_0,
  nullCdf, PURPLE_SHAREABLE_cdf_0, nullCdf,
  nullCdf, nullCdf, nullCdf,
  nullCdf, nullCdf, nullCdf
]);
hasRettaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false,
  false, false, false, true, false, false, false,
  false, false, false, false, false, true, false,
  false, false, false, false, false, true, false,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false
]);
hasCodtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false,
  false, false, false, true, false, true, false,
  false, false, false, false, true, false, false,
  false, false, false, false, true, false, false,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false
]);
hasArgtaints = array3d(cdf, parmIdx, cleLabel, [
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, true,
  false, false, false, false, false, false, true,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false
]);
hasARCtaints = array2d(cdf, cleLabel, [
  false, false, false, false, false, false, false,
  false, true, false, true, false, true, false,
  false, false, true, false, true, true, true,
  false, false, true, false, true, true, true,
  false, false, false, false, false, false, false,
  false, false, false, false, false, false, false
]);