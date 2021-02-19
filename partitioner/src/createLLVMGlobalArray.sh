F=`basename $0`
LF=`echo $F.out`
EF=`echo $F.err`
rm -f $LF $EF
if test "${1}" == ""
then
        echo "usage: $F dotFile" | tee -a $LF $EF
        exit -1
fi
v=`grep -v " -> " $1 2>>$EF | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
echo "LLVMGLOBAL = ["
for i in $v
do
	grep $i $1 2>>$EF | grep llvm.global.annotations  1>out 2>err
	if test "${?}" == "0"
	then
		echo "true,"
	else
		echo "false,"
	fi
done
echo "];"


if test -s $EF
then
        echo -e "\033[31;1;4m$0 $1 FAILED:\033[0m" 1>&2
        cat $EF 1>&2
        exit -1
fi
rm -f $EF $LF
exit 0
