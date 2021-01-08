v=`grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
echo "FUNCTIONCALL = ["
for i in $v
do
	grep $i $1 | grep " = call "  1>/dev/null 2>/dev/null
	if test "${?}" == "0"
	then
		echo "true,"
	else
		echo "false,"
	fi
done
echo "];"
