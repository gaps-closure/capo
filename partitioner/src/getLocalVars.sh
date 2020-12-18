grep annotation= TFB.dot |grep -v "GLOBAL_VALUE:" |grep "dbginfo="| sed -e "s/^  *//" -e "s/ .*dbginfo=\"/,/" -e "s/\".*$//" -e "s/ /:/" -e "s/ /:/" -e "s/ /:/" -e "s/ /:/" -e "s/,.*:/,/" -e "s/,/ /" | grep "True 0" | sed -e "s/ .*$//" -e "s/^/LOCALVAR\[/" -e "s/$/]=1;/"
# the last int is 0 for LOCALS
# TRUE FALSE is TRUE for LOCALS
