NOW=`date +"%s"`
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
df=`basename $1`
bf=`dirname $1`
annFile=/tmp/$df.annotated.dot
rm -rf /tmp/n $annFile
echo "NodeNULL" >  /tmp/n
cat /tmp/n $1.annotated.dot > $annFile
rm /tmp/n
echo "Preparing input for minizinc"
echo "	getNodes"
$myDir/getNodes.sh $annFile 1> $1.dzn
checkRc $? 
echo "	getEnclaves"
$myDir/getEnclaves.sh $annFile >> $1.dzn
checkRc $? 
#echo "	createLLVMGlobalArray"
#$myDir/createLLVMGlobalArray.sh $annFile >> $1.dzn
#checkRc $? 
#echo "	createLLVMVarArray"
#$myDir/createLLVMVarArray.sh $annFile >> $1.dzn
#checkRc $? 
for type in ENTRY FUNCTION
do
	echo "	createNodeType $type"
	$myDir/createNodeType.sh $annFile $type >> $1.dzn
	checkRc $? 
done
echo "	createStaticVarArray"
$myDir/createStaticVarArray.sh $annFile >>$1.dzn
checkRc $? 
echo "	createLocalVarArray"
$myDir/createLocalVarArray.sh $annFile >>$1.dzn
checkRc $? 
#for type in RAW DEF_USE PARAMETER GLOBAL_DEP D_general CONTROL SCOPE
for type in CONTROL 
do
	echo "  createEdgeArray $type"
	$myDir/createEdgeArray.sh $annFile $type $type >> $1.dzn
	checkRc $? 
done
$myDir/createFunctionCallArray.sh $annFile >> $1.dzn
echo "	getEnclaveNodes"
$myDir/getEnclaveNodes.sh $annFile > $1.mzn
checkRc $? 
#echo "	createEnclaveRemoteLevel"
#$myDir/createEnclaveRemoteLevel.sh $annFile $1.clemap.json >> $1.dzn
#checkRc $? 
/snap/bin/minizinc $1.dzn  $1.mzn $myDir/colorer.mzn | grep Node | sort -u > /tmp/e
python3 $myDir/rewritePDG.py $annFile $1.mod.ll /tmp/e $1.clemap.json $1.colored.dot $bf/topology.json.minizinc
exit -1
