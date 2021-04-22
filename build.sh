#!/bin/bash

BUILD="$(pwd)/build"
PACKAGE_DIR="packages"
LLVM_URL="https://github.com/gaps-closure/capo/releases/download/T0.1/LLVM-10.0.0svn-Linux.deb"
LLVM_DIR=llvm-project
PRE_DOWNLOADED_DEBS=($LLVM_URL)
PY_MODULES=(clang lark-parser pydot decorator networkx)
DEB_PACKAGES=(xdot)

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -chl ] \\"
  echo "          [ -b BRANCH ]"
  echo "-b BRANCH Build LLVM from the BRANCH branch of the source"
  echo "-c        Clean up"
  echo "-l        Install LLVM, after build or after downloading the pre-built binary"
  echo "-h        Help"
  exit 1
}

handle_opts() {
  local OPTIND
  while getopts "b:clh" options; do
    case "${options}" in
      b) LLVM_BRANCH=${OPTARG}  ;;
      c) CLEAN=1                ;;
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
      exit 1
  fi

  echo "Installing $message from $PKG"
  sudo dpkg -i $PKG
}    

install_cmake() {
  CMAKE=$(cmake --version)
  if [ $? -ne 0 ]; then
      echo "installing cmake"
      sudo snap install cmake --classic
  fi
}

build_llvm () {
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
      cmake -G 'Unix Makefiles' -DLLVM_ENABLE_PROJECTS='clang;libclc;libcxx;libcxxabi;lld' -DCLANG_PYTHON_BINDINGS_VERSIONS='2.7;3.8' -DLLVM_TARGETS_TO_BUILD='X86' -DCMAKE_BUILD_TYPE=Release ../llvm
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
}

install_llvm () {
  if [[ $INSTALL_LLVM ]]; then
      LLVM_DEB="${LLVM_URL##*/}"
      # if build llvm is specified, the package should be in the $PACKAGE_DIR
      if [ ! -f $PACKAGE_DIR/$LLVM_DEB ]; then
          wget -nv $LLVM_URL
          LLVM_DEB="${LLVM_URL##*/}"
          mkdir -p $PACKAGE_DIR
          mv $LLVM_DEB $PACKAGE_DIR
      fi
      #install_deb "Qualatype LLVM" "$PACKAGE_DIR/$LLVM_DEB"
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
    PIP3=pip3
    RTN=$(pip3 --version)
    if [ $? -eq 0 ]; then
        echo "pip3 is installed"
    else
        sudo apt install -y python3-pip
	# do the following if the above does not work
        #curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
        #python3 get-pip.py --user
        #PIP3=$HOME/.local/bin/pip3
    fi
    
    for m in "${PY_MODULES[@]}"
    do
        $PIP3 list | grep $m
        if [ $? -eq 0 ]; then
            echo "$m is already installed"
        else
            echo "$m not installed; installing it"
            sudo $PIP3 install $m
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

rm -rf $BUILD cle 

if [[ $CLEAN ]]; then
    rm -rf $BUILD cle $PACKAGE_DIR
    clean_pdg
    clean_partitioner
else
    install_cmake
    
    build_llvm
    install_llvm

    check_py_module
    check_packages

    build_pdg
    build_partitioner
fi
