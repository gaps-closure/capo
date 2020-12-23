v=`grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
echo "ENTRY = ["
for i in $v
do
	grep $i $1 | grep ENTRY 1>out 2>err
	if test "${?}" == "0"
	then
		echo "true,"
	else
		echo "false,"
	fi
done
echo "];"


