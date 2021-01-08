#example arg: example1.c
echo "annotating dot file"
python3 annotate.py $1
echo "getNodes"
./getNodes.sh $1.annotated.dot > $1.dzn
echo "getEnclaves"
./getEnclaves.sh $1.annotated.dot >> $1.dzn
echo "createEntryArray"
./createEntryArray.sh $1.annotated.dot >> $1.dzn
echo "createFunctionArray"
./createFunctionArray.sh $1.annotated.dot >> $1.dzn
echo "createStaticVarArray"
./createStaticVarArray.sh $1.annotated.dot >> $1.dzn
echo "createLocalVarArray"
./createLocalVarArray.sh $1.annotated.dot >> $1.dzn
echo "createRawArray"
./createRawArray.sh $1.annotated.dot >> $1.dzn
echo "createDefUseArray"
./createDefUseArray.sh $1.annotated.dot >> $1.dzn
echo "createParameterArray"
./createParameterArray.sh $1.annotated.dot >> $1.dzn
echo "createGLOBALDEPArray"
./createGLOBALDEPArray.sh $1.annotated.dot >> $1.dzn
echo "createD_generalArray"
./createD_generalArray.sh $1.annotated.dot >> $1.dzn
echo "createFunctionCallArray"
./createFunctionCallArray.sh $1.annotated.dot >> $1.dzn
echo "createControlCallArray"
./createControlArray.sh $1.annotated.dot >> $1.dzn
echo "createScopArray"
./createScopeArray.sh $1.annotated.dot >> $1.dzn
echo "create CONTROL ancestor array"
./createAncestorArray CONTROL $1.annotated.dot >> $1.dzn
echo "create SCOPE  ancestor array"
./createAncestorArray SCOPE  $1.annotated.dot >> $1.dzn
echo "getEnclaveNodes"
./getEnclaveNodes.sh $1.annotated.dot > $1.mzn
echo "createEnclaveRemoteLevel"
./createEnclaveRemoteLevel.sh $1 >> $1.dzn
#/snap/bin/minizinc $1.dzn  $1.mzn colorer.mzn
