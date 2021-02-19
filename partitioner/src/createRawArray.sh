F=`basename $0`
LF=`echo $F.out`
EF=`echo $F.err`
v=`grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
echo -n "RAW = ["
if test "${1}" == ""
then
        echo "usage: $F dotFile" | tee -a $LF $EF
        exit -1
fi
for v1 in $v
do
	echo -n "|"
	grep "${v1} -> " $1 2>$EF | grep RAW 1>out 2>err
	if test "${?}" != "0"
	then
		for v2 in $v
		do
			echo -n "false,"
		done
	else
		for v2 in $v
		do
			grep "${v1} -> ${v2}" $1 2>$EF | grep RAW 1>out 2>err
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

if test -s $EF
then
        echo -e "\033[31;1;4m$0 $1 FAILED:\033[0m" 1>&2
        cat $EF 1>&2
        exit -1
fi
rm -f $EF $LF
exit 0
