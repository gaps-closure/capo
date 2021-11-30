#!/bin/bash

OPT=/usr/local/bin/opt
CLANG=/usr/local/bin/clang
PYTHON=/usr/bin/python3

BUILD=~/gaps/build
PDGLIB=$BUILD/src/capo/pdg/build/libpdg.so
PREPROC=$BUILD/src/mules/cle-preprocessor/src/qd_cle_preprocessor.py
CLPFD=$BUILD/src/capo/partitioner/src/clp/conflict_free_partition.py

INPDIR=$BUILD/apps/tests/test3/refactored
INPF=test3_refactored

# XXX: This may change when we cut over to 10.0.1 
OPTVERSION=`$OPT --version | sed -e 's/^.*10.0.0svn$/10.0.0svn/' | grep "10.0.0svn"`
OPTBUILD=`$OPT --version | sed -e 's/^.*DEBUG.*$/DEBUG/' | grep DEBUG`

if [ "$OPTVERSION" != "10.0.0svn" ] || [ "$OPTBUILD" != "DEBUG" ]
then
  echo "Require opt from LLVM Version 10.0.0svn DEBUG build"
  exit 0
fi

prep_sample() {
  cp $INPDIR/${INPF}.c .
  $PYTHON $PREPROC -f ${INPF}.c
  $CLANG -g -S -emit-llvm ${INPF}.mod.c
  $OPT --load $PDGLIB -dot-pdg ${INPF}.mod.ll
}

mkdir -p ./scratch
cd ./scratch
# prep_sample
$PYTHON $CLPFD -c ${INPF}.c.clemap.json

