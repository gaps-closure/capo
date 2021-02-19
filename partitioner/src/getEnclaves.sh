F=`basename $0`
LF=`echo $F.out`
EF=`echo $F.err`
rm -f $LF $EF
if test "${1}" == ""
then
	echo "usage: $F dotFile" | tee -a $LF $EF
	exit -1
fi
echo "Enclaves = {"
echo "enclaveNull,"
e=`grep enclave $1 2>>$EF| sed -e "s/^.*enclave=\"//" -e "s/\".*$//" | sort -u` 1>>$LF 2>>$EF
for i in $e
do
	echo "$i,"
done
echo "};"
if test -s $EF
then
        echo -e "\033[31;1;4m$0 $1 FAILED:\033[0m" 1>&2
        cat $EF 1>&2
        exit -1
fi
rm -f $EF $LF
exit 0
