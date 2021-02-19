F=`basename $0`
LF=`echo $F.out`
EF=`echo $F.err`
myDir=`dirname $0`
rm -f $EF $LF
if test "${1}" == ""
then
        echo "usage: $F dotFile" | tee -a $LF $EF
        exit -1
fi
v=`grep -v " -> " $1 2>>$EF | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
tn=`grep taint $1 2>>$EF | sed -e "s/^  *//" -e "s/ .*$//"`
e=`grep enclave $1 2>>$EF | sed -e "s/^.*enclave=\"//" -e "s/\".*$//" | sort -u`
e=`echo enclaveNull $e`
echo -n "ENCLAVEREMOTELEVEL = ["
for v1 in $v
do
	echo -n "|"
	#if $v1 not in $t
	#	echo false for each enclave
	#else
	#	get the taint for $v1
	#	for each enclave
	#		get the remove level for this taint
	#		if enclave == taint
	#			echo true
	#		else
	#			echo false
	#
	
	#grep "${v1}" $1 2>>$EF | grep taint 1>out 2>err
	#if test "${?}" != "0"
	if [[ "$tn" == *"$v1"* ]]
	then
		t=`grep "${v1}" $1 2>>$EF | grep taint | sed -e "s/^.*taint=\"//" -e "s/\".*$//"`
		for e1 in $e
		do
			r=`python3 $myDir/getRemoteLevel.py $2 $t`
			if test "${e1}" == "${r}"
			then
				echo -n "true,"
			else
				echo -n "false,"
			fi
		done
	else
		for  e1 in $e
		do
			echo -n "false,"
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
