v=`grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
echo "LOCALVAR = ["
for i in $v
do
	grep $i $1 | grep annotation= |grep -v "GLOBAL_VALUE:" | grep "dbginfo="| grep "True 0"  1>out 2>err
	if test "${?}" == "0"
	then
		echo "true,"
	else
		echo "false,"
	fi
done
echo "];"
