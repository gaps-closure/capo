grep annotation= TFB.dot |grep "GLOBAL_VALUE:" | grep "dbginfo="| sed -e "s/^  *//" -e "s/ .*dbginfo=\"/,/" -e "s/\".*$//" -e "s/ /:/" -e "s/ /:/" -e "s/ /:/" -e "s/ /:/" -e "s/,.*:/,/" -e "s/,/ /" | grep "True 0" | sed -e "s/ .*$//" -e "s/^/STATICVAR\[/" -e "s/$/]=1;/"
# the last int is 0 for STATICS
# TRUE FALSE is FALSE for STATICS
