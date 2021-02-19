F=`basename $0`
LF=`echo $F.out`
EF=`echo $F.err`
rm -f $EF $LF
if test "${1}" == ""
then
        echo "usage: $F dotFile" | tee -a $LF $EF
        exit -1
fi
en=`grep enclave $1 2>>$EF | sed -e "s/^  *//" -e "s/ .*enclave=\"/,/" -e "s/\".*$//"`
for i in $en
do
	t1=`echo $i | sed -e "s/,.*$//"`
	t2=`echo $i | sed -e "s/^.*,//"`
	echo "constraint nodeEnclave[$t1]=$t2;"
done
if test -s $EF
then
        echo -e "\033[31;1;4m$0 $1 FAILED:\033[0m" 1>&2
        cat $EF 1>&2
        exit -1
fi
rm -f $EF $LF
exit 0
