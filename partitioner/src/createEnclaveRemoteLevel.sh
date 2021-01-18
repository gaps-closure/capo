myDir=`dirname $0`
v=`grep -v " -> " $1.annotated.dot | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
t=`grep taint $1.annotated.dot | sed -e "s/^  *//" -e "s/ .*taint=\"/,/" -e "s/\".*$//"`
e=`grep enclave $1.annotated.dot | sed -e "s/^.*enclave=\"//" -e "s/\".*$//" | sort -u`
echo -n "ENCLAVEREMOTELEVEL = ["
for v1 in $v
do
	echo -n "|"
	grep "${v1}" $1.annotated.dot | grep taint 1>out 2>err
	if test "${?}" != "0"
	then
		for  e1 in $e
		do
			echo -n "false,"
		done
	else
		t=`grep "${v1}" $1.annotated.dot | grep taint | sed -e "s/^.*taint=\"//" -e "s/\".*$//"`
		for e1 in $e
		do
			r=`python3 $myDir/getRemoteLevel.py $1.clemap.json $t`
			if test "${e1}" == "${r}"
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

