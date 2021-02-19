F=`basename $0`
LF=`echo $F.out`
EF=`echo $F.err`
rm -f $EF $LF
#find all edges of TYPE in dot file and create edge name s/ -> /$3/
#output enum for all edges
#for each edge
#	extract s
#	extract d
#	output fromTYPE[edge]=s
#	output toTYPE[edge]=d
#
if test "${1}" == ""
then
        echo "usage: $F dotFile edgeType" | tee -a $LF $EF
        exit -1
fi
if test "${2}" == ""
then
        echo "usage: $F dotFile edgeType" | tee -a $LF $EF
        exit -1
fi

et=`grep " -> " $1 | grep $2 |  sed -e "s/\[.*$//" -e "s/ -> /$3/"`
echo  $2Edges = {
for e in $et
do
	echo "$e,"
done
echo "};"
s=`grep " -> " $1 | grep $2 |  sed -e "s/\[.*$//" -e "s/ -> Node.*$//"`
d=`grep " -> " $1 | grep $2 |  sed -e "s/\[.*$//" -e "s/ Node.* -> //"`
echo $2From = [
for e in $s
do
	
	echo "$e,"
done
echo "];"
echo $2To = [
for e in $d
do
	echo "$e,"
done
echo "];"
exit
for v1 in $v
do
	allFalse="$allFalse false,"

done
echo -n "$2 = ["
for v1 in $v
do
	echo -n "|"
	grep "${v1} -> " <<< $et 1>/dev/null 2>>$EF
	if test "${?}" != "0"
	then
		echo $allFalse
		#for v2 in $v
		#do
			#echo -n "false,"
		#done
	else
		for v2 in $v
		do
			grep "${v1} -> ${v2}" <<< $et 2>$EF 1>/dev/null 2>>$EF
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
