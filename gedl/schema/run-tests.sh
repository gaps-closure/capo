#!/bin/bash
auditfile="tests.audit"
testscript="./validate-gedl.py"

rm $auditfile

echo "running tests, saving all output to $auditfile"
echo
echo -------------
echo

echo "Negative tests (these should fail)"
for f in $(ls "tests-negative/"*.json)
do
    echo "run " $f "..."
    
    echo "" >> $auditfile
    echo "############### $f ###############" >> $auditfile
    echo "" >> $auditfile
    
    if $($testscript $f >> $auditfile)
    then
        echo "TEST FAILED (running $f) see $auditfile for details"
        exit -1
    else
        echo "TEST PASSED (running $f)"
    fi
done

echo
echo -------------
echo

echo "Valid tests (these should succeed)"
for f in $(ls "tests-valid/"*.json)
do
    echo "run " $f "..."
    
    echo "" >> $auditfile
    echo "############### $f ###############" >> $auditfile
    echo "" >> $auditfile
    
    if $($testscript $f >> $auditfile)
    then
        echo "TEST PASSED (running $f)"
    else
        echo "TEST FAILED (running $f) see $auditfile for details"
        exit -1
    fi
done

echo
echo -------------
echo
echo "ALL TESTS DONE SUCCESSFULLY"
echo
exit 1
