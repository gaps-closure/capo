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
d=`expr \`date +"%s"\` - $NOW`; echo "ELAPSED TIME $d"
python3 $myDir/annotate.py $1
df=`basename $1`
bf=`dirname $1`
llf=`echo $df | sed -e "s/^/$bf\//" -e "s/\.c/.mod.ll/"`
#a hack to get a node whose name is NodeNULL
echo "adding NodeNull to dot file"
annFile=/tmp/$df.annotated.dot
rm -rf /tmp/n $annFile
echo "NodeNULL" >  /tmp/n
cat /tmp/n $1.annotated.dot > $annFile
rm /tmp/n
echo "reverting to original edge/node names in dot file"
$myDir/fixDotFileNames.sh $annFile
echo "Preparing input for minizinc"
d=`expr \`date +"%s"\` - $NOW`; echo "ELAPSED TIME $d"
echo "	getNodes"
$myDir/getNodes.sh $annFile 1> $1.dzn
checkRc $? 
d=`expr \`date +"%s"\` - $NOW`; echo "ELAPSED TIME $d"
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
	d=`expr \`date +"%s"\` - $NOW`; echo "ELAPSED TIME $d"
	$myDir/createNodeType.sh $annFile $type >> $1.dzn
	checkRc $? 
done
echo "	createStaticVarArray"
d=`expr \`date +"%s"\` - $NOW`; echo "ELAPSED TIME $d"
$myDir/createStaticVarArray.sh $annFile >>$1.dzn
checkRc $? 
echo "	createLocalVarArray"
d=`expr \`date +"%s"\` - $NOW`; echo "ELAPSED TIME $d"
$myDir/createLocalVarArray.sh $annFile >>$1.dzn
checkRc $? 
#for type in RAW DEF_USE PARAMETER GLOBAL_DEP D_general CONTROL SCOPE
for type in CONTROL CALL
do
	d=`expr \`date +"%s"\` - $NOW`; echo "ELAPSED TIME $d"
	echo "  createEdgeArray $type"
	$myDir/createEdgeArray.sh $annFile $type $type >> $1.dzn
	checkRc $? 
done
$myDir/createFunctionCallArray.sh $annFile >> $1.dzn
d=`expr \`date +"%s"\` - $NOW`; echo "ELPASED TIME: $d"
echo "	getEnclaveNodes"
$myDir/getEnclaveNodes.sh $annFile > $1.mzn
checkRc $? 
#echo "	createEnclaveRemoteLevel"
#$myDir/createEnclaveRemoteLevel.sh $annFile $1.clemap.json >> $1.dzn
#checkRc $? 
echo "solving constraints"
/snap/bin/minizinc $1.dzn  $1.mzn $myDir/colorer.mzn > $1.enclaveAssign
checkRc $? 
grep "ASSIGN:" $1.enclaveAssign | sort -u -o $1.enclaveAssign
checkRc $? 
echo "rewritingPDG.py"
echo "python3 $myDir/rewritePDG.py $annFile $llf $1.enclaveAssign $1.clemap.json $1.colored.dot $bf/topology.json.minizinc"

exit -1
