#!/bin/bash

BUILD="$(pwd)/build"
# PACKAGE_DIR="packages"

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -ch ] \\"
  echo "-c        Clean up"
  echo "-h        Help"
  exit 1
}

handle_opts() {
  local OPTIND
  while getopts "b:ch" options; do
    case "${options}" in
      c) CLEAN=1                ;;
      h) usage_exit             ;;
      :) usage_exit "Error: -${OPTARG} requires an argument." ;;
      *) usage_exit             ;;
    esac
  done
}

# build_llvm () {
#   if [[ $LLVM_BRANCH ]]; then
#       if [ ! "$(ls -A $LLVM_DIR)" ]; then
#           git submodule init
#           git submodule update
#       fi
#       pushd $LLVM_DIR

#       echo "Checking out LLVM $LLVM_BRANCH branch"
#       git checkout $LLVM_BRANCH
#       mkdir build
#       cd build
#       cmake -G 'Unix Makefiles' -DLLVM_ENABLE_PROJECTS='clang;libclc;libcxx;libcxxabi;lld' -DCLANG_PYTHON_BINDINGS_VERSIONS='2.7;3.8' -DLLVM_TARGETS_TO_BUILD='X86' -DCMAKE_BUILD_TYPE=Release ../llvm
#       make -j24
#       cpack

#       mkdir -p ../../$PACKAGE_DIR

#       LLVM_DEB="${LLVM_URL##*/}"
#       mv $LLVM_DEB ../../$PACKAGE_DIR
#       file="${LLVM_DEB%.deb}"
#       mv ${file}.rpm ../../$PACKAGE_DIR
#       mv ${file}.sh ../../$PACKAGE_DIR
      
#       popd
#   fi
# }


build_pdg () {
  echo "Building PDG"

  TMP_DIR=$(pwd)
  cd pdg2
  rm -rf build
  mkdir build
  cd build
  cmake ..
  make -j 8
  cd $TMP_DIR
}

clean_pdg () {
  echo "Cleaning PDG"
  TMP_DIR=$(pwd)
  cd pdg2
  rm -rf build
  cd $TMP_DIR
}




build_partitioner_verifier_gedl () {
  echo "Bulding others"

  TMP_DIR=$(pwd)
  cd partitioner/src
  make 
  cd $TMP_DIR
  cd compliance
  make 
  cd $TMP_DIR
  cd gedl
  rm -rf build
  mkdir build
  cd build
  cmake ..
  make -j 8
  cd $TMP_DIR
}


clean_partitioner_verifier_gedl () {
  echo "Cleaning others"

  TMP_DIR=$(pwd)
  cd partitioner/src
  make clean
  cd $TMP_DIR
  cd compliance
  make clean
  cd $TMP_DIR
  cd gedl
  rm -rf build
}


handle_opts "$@"

echo "BUILD=${BUILD}"

rm -rf $BUILD cle 

if [[ $CLEAN ]]; then
    rm -rf $BUILD cle $PACKAGE_DIR
    clean_pdg
    clean_partitioner_verifier_gedl
else
    build_pdg
    build_partitioner_verifier_gedl
fi
