F=`basename $0`
myDir=`dirname $0`
NOW=`date +"%s"`
LF=`echo $F.$NOW.out`
EF=`echo $F.$NOW.err`
rm -f $EF $LF
nodeFile=/tmp/nodes.$NOW
mergeFile=/tmp/merge.$NOW
if test "${1}" == ""
then
        echo "usage: $F dotFile" | tee -a $LF $EF
        exit -1
fi
grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//" > $nodeFile
grep annotation= $1 |grep -v "GLOBAL_VALUE:" | grep "dbginfo="| grep "True 0" | sed -e "s/^  *//" -e "s/ .*//" > $mergeFile
echo "LOCALVAR = ["
$myDir/mergeNodeFiles $nodeFile $mergeFile 2>>$EF
echo "];"
if test -s $EF
then
        echo -e "\033[31;1;4m$0 $1 FAILED:\033[0m" 1>&2
        cat $EF 1>&2
        exit -1
fi
rm -f $EF $LF $mergeFile $nodeFile
exit 0
