v=`grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
echo "STATICVAR = ["
for i in $v
do
	grep $i $1 | grep annotation= |grep "GLOBAL_VALUE:" | grep "dbginfo="| grep "True 0"  1>out 2>err
	if test "${?}" == "0"
	then
		echo "true,"
	else
		echo "false,"
	fi
done
echo "];"


#grep annotation= TFB.dot |grep "GLOBAL_VALUE:" | grep "dbginfo="| sed -e "s/^  *//" -e "s/ .*dbginfo=\"/,/" -e "s/\".*$//" -e "s/ /:/" -e "s/ /:/" -e "s/ /:/" -e "s/ /:/" -e "s/,.*:/,/" -e "s/,/ /" | grep "True 0" | sed -e "s/ .*$//" -e "s/^/STATICVAR\[/" -e "s/$/]=1;/"
# the last int is 0 for STATICS
# TRUE FALSE is FALSE for STATICS
