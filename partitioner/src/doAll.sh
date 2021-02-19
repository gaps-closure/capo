#example arg: example1.c
function checkRc {
	if test "$?" != "0"
	then
       	 	echo FAILED
	 	exit -1
	fi
}
myDir=`dirname $0`
echo "annotating dot file"
python3 $myDir/annotate.py $1
rm -rf /tmp/n /tmp/a
echo "NodeNULL" >  /tmp/n
cat /tmp/n $1.annotated.dot >/tmp/a
cp  /tmp/a $1.annotated.dot
rm /tmp/n /tmp/a
echo "Preparing input for minizinc"
echo "	getNodes"
$myDir/getNodes.sh $1.annotated.dot 1> $1.dzn
checkRc $? 
echo "	getEnclaves"
$myDir/getEnclaves.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createLLVMGlobalArray"
$myDir/createLLVMGlobalArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createLLVMVarArray"
$myDir/createLLVMVarArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createEntryArray"
$myDir/createEntryArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createFunctionArray"
$myDir/createFunctionArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createStaticVarArray"
$myDir/createStaticVarArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createLocalVarArray"
$myDir/createLocalVarArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createRawArray"
$myDir/createRawArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createDefUseArray"
$myDir/createDefUseArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createParameterArray"
$myDir/createParameterArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createGLOBALDEPArray"
$myDir/createGLOBALDEPArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createD_generalArray"
$myDir/createD_generalArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createFunctionCallArray"
$myDir/createFunctionCallArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createControlArray"
$myDir/createControlArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	createScopeArray"
$myDir/createScopeArray.sh $1.annotated.dot >> $1.dzn
checkRc $? 
echo "	getEnclaveNodes"
$myDir/getEnclaveNodes.sh $1.annotated.dot > $1.mzn
checkRc $? 
echo "	createEnclaveRemoteLevel"
$myDir/createEnclaveRemoteLevel.sh $1.annotated.dot $1.clemap.json >> $1.dzn
checkRc $? 
#for e in CONTROL D_ALIAS DATA_CALL_PARA DATA_READ DEF_USE D_general GLOBAL_DEP PARAMETER RAW SCOPE
#do
#	echo "	create $e ancestor array"
#	$myDir/createAncestorArray $e $1.annotated.dot 1>> $1.dzn 2>createAncestorArray.$e.err
#	if test "$?" != "0"
#	then
#		echo "$myDir/createAncestorArray $e $1.annotated.dot  FAILED:"
#		cat createAncestorArray.$e.err
#		exit -1
#	fi
#done
for e in CONTROL SCOPE
do
	echo "	create $e ENTRY DFS array"
	$myDir/createEntryPath $e $1.annotated.dot 1>> $1.dzn 2>createEntryPath.$e.err
	if test "$?" != "0"
	then
		echo "$myDir/createEntryPath $e $1.annotated.dot  FAILED:"
		cat createEntryPath.$e.err
		exit -1
	fi
done
/snap/bin/minizinc $1.dzn  $1.mzn $myDir/colorer.mzn | grep Node | sort -u > /tmp/e
python3 $myDir/rewritePDG.py $1.annotated.dot /tmp/e $1.clemap.json $1.colored.dot
exit -1
