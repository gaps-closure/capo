LLVMVAR=`grep "llvm.var.annotation" $1 | sed -e "s/^\t//" -e "s/ .*$//"`
for v in $LLVMVAR
do
	echo $v
done
#exit
#LLVMGLOBAL=`grep "llvm.global.annotations" $1 | sed -e "s/^\t//" -e "s/ .*$//"`
#for v in $LLVMGLOBAL
#do
	#echo $v
#done
exit
grep CONTROL $1 | grep " -> " | grep -v $LLVMVAR | grep -v $LLVMGLOBAL | sed -e "s/^\t*//" -e "s/ -> /_/" -e "s/\[label.*$//"
