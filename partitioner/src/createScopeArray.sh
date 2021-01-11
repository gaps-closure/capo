v=`grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
echo -n "SCOPE = ["
for v1 in $v
do
	echo -n "|"
	grep "${v1} -> " $1 | grep SCOPE 1>out 2>err
	if test "${?}" != "0"
	then
		for v2 in $v
		do
			echo -n "false,"
		done
	else
		for v2 in $v
		do
			grep "${v1} -> ${v2}" $1 | grep SCOPE 1>out 2>err
			if test "${?}" == "0"
			then
				echo -n "true,"
			else
				echo -n "false,"
			fi
		done
	fi
	echo ""
done
echo "|];"

