#!/bin/bash

BUILD="$(pwd)/build"
PACKAGE_DIR="packages"
LLVM_URL="https://github.com/gaps-closure/capo/releases/download/T0.1/LLVM-10.0.0svn-Linux.deb"
LLVM_DIR=llvm-project
PRE_DOWNLOADED_DEBS=($LLVM_URL)
PY_MODULES=(clang lark-parser pydot decorator)
DEB_PACKAGES=(xdot)

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -hcdl ] \\"
  echo "          [ -b BRANCH ]"
  echo "-h        Help"
  echo "-b BRANCH Build LLVM from the BRANCH branch of the source"
  echo "-c        Clean up"
  echo "-d        Dry run"
  echo "-l        Install LLVM, after build or after downloading the pre-built binary"
  exit 1
}

handle_opts() {
  local OPTIND
  while getopts "b:cdlh" options; do
    case "${options}" in
      b) LLVM_BRANCH=${OPTARG}  ;;
      c) CLEAN=1                ;;
      d) DRY_RUN="--dry-run"    ;;
      l) INSTALL_LLVM=1         ;;
      h) usage_exit             ;;
      :) usage_exit "Error: -${OPTARG} requires an argument." ;;
      *) usage_exit             ;;
    esac
  done
}

install_deb() {
  message=$1
  PKG=$2

  if [ ! -f $PKG ]; then
      echo "*** package not found: $PKG"
      if [[ $DRY_RUN ]]; then
          return
      else
          exit 1
      fi
  fi

  echo "Installing $message"
  sudo dpkg $DRY_RUN -i $PKG
}    

install_llvm () {
  if [[ $LLVM_BRANCH ]]; then
      if [ ! "$(ls -A $LLVM_DIR)" ]; then
          git submodule init
          git submodule update
      fi
      pushd $LLVM_DIR

      echo "Checking out LLVM $LLVM_BRANCH branch"
      git checkout $LLVM_BRANCH
      mkdir build
      cd build
      cmake -G 'Unix Makefiles' -DLLVM_ENABLE_PROJECTS='clang;libclc;libcxx;libcxxabi;lld' -DCLANG_PYTHON_BINDINGS_VERSIONS='2.7;3.5' -DLLVM_TARGETS_TO_BUILD='X86' -DCMAKE_BUILD_TYPE=Release ../llvm
      make -j24
      cpack

      mkdir -p ../../$PACKAGE_DIR

      LLVM_DEB="${LLVM_URL##*/}"
      mv $LLVM_DEB ../../$PACKAGE_DIR
      file="${LLVM_DEB%.deb}"
      mv ${file}.rpm ../../$PACKAGE_DIR
      mv ${file}.sh ../../$PACKAGE_DIR
      
      popd
  fi

  if [[ $INSTALL_LLVM ]]; then
      if [ ! -f $PACKAGE_DIR/$LLVM_DEB ]; then
          wget $LLVM_URL
          LLVM_DEB="${LLVM_URL##*/}"
          mkdir -p $PACKAGE_DIR
          mv $LLVM_DEB $PACKAGE_DIR
      fi
      install_deb "Qualatype LLVM" "$PACKAGE_DIR/$LLVM_DEB"
  fi
}

build_pdg () {
  echo "Building PDG"

  TMP_DIR=$(pwd)
  cd pdg
  make
  #mv build/libpdg.so $BUILD
  cd $TMP_DIR
}

clean_pdg () {
  echo "Cleaning PDG"

  TMP_DIR=$(pwd)
  cd pdg
  make clean
  cd $TMP_DIR
}

build_quala () {
  echo "Bulding Quala"

  TMP_DIR=$(pwd)
  cd quala/examples/tainting
  make

  cd ../nullness
  make
  cd $TMP_DIR
}

clean_quala () {
  echo "Cleaning Quala"

  TMP_DIR=$(pwd)
  cd quala/examples/tainting
  make clean

  cd ../nullness
  make clean
  cd $TMP_DIR
}

build_partitioner () {
  echo "Bulding partitioner"

  TMP_DIR=$(pwd)
  cd partitioner/src
  make

  cd $TMP_DIR
}

clean_partitioner () {
  echo "Cleaning Partitioner"

  TMP_DIR=$(pwd)
  cd partitioner/src
  make clean

  cd ../example
  make clean
  cd $TMP_DIR
}

check_py_module () {
    for m in "${PY_MODULES[@]}"
    do
        pip3 list | grep $m
        if [ $? -eq 0 ]; then
            echo "$m is already installed"
        else
            echo "$m not installed; installing it"
            sudo pip3 install $m
        fi
    done
}

check_packages () {
    for m in "${DEB_PACKAGES[@]}"
    do
        apt list | grep -w $m
        if [ $? -eq 0 ]; then
            echo "$m is already installed"
        else
            echo "$m not installed; installing it"
            sudo apt-get install -y $m
        fi
    done
}

download_packages () {
    rm -rf packages
    mkdir -p packages
    
    for m in "${PRE_DOWNLOADED_DEBS[@]}"
    do
        echo "Downloading $m"
        wget $m
        mv $LLVM_DEB $PACKAGE_DIR
    done
}

handle_opts "$@"

echo "BUILD=${BUILD}"

if [[ $CLEAN ]]; then
    rm -rf $BUILD cle $PACKAGE_DIR
    clean_pdg
    clean_quala
    clean_partitioner
else
    if [ ! "$(ls -A pdg)" ]; then
        git submodule init
        git submodule update
    fi

    check_py_module
    check_packages

    install_llvm

    build_pdg
    build_quala
    build_partitioner
fi
