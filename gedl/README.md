# GEDL Generation for Cross-Domain Function Context Extraction

This project is an automatization tool for extracting cross-domain function information necessary for remote procedural call generation, data serialization and marshalling, and cross-domain callsite wrapping. GEDL generates PROG.gedl json formatted file.

## Origin

GEDL is derived from a Penn State University project for generating Intel SGX wrappings and EDL files:
(https://github.com/eralpsahin/edl)


## Requirements
- [LLVM and Clang 9.0.1](https://releases.llvm.org/download.html)
- Make sure that LLVM is added to $PATH.
- Input is a single directory divided into one subdirectory for each domain.
- All functions are CLE Annotated and Preprocessed (Clang attributes for CLE annotations are pushed/popped)
- The following Makefile variables are set:
  - ODIR = /path/to/output/directory
  - EDIR := /path/to/input/directory
  - PROG := ProgramName
  - HEURISTICS_DIR:= /path/to/heuristics/directory
  - SCHEMA_PATH:= /path/to/json/schema.json
  - CLE_PRE=/path/to/cle-preprocessor/src
  - HAL_PATH=/path/to/CLOSURE/HAL
  - IPC_MODE=Singlethreaded/Multithreaded
  - INURI="inputURI"
  - OUTURI="outputURI"

## Getting Started
Once the requirements are met, for quickly getting started, run the following commands from the main gedl directory to build the library:
- `mkdir build`
- `cd build`
- `cmake ..`
- `make`

Then run  `make gedl` from the Makefile to generate GEDL file.

Above commands will generate the following files.
- `$(ODIR)/$(PROG).gedl`
- `$(ODIR)/gedl.ll`

From the GEDL, you need the remainder of CLOSURE tools to generate working cross-enclave code. The next step is to run IDL generation python script and RPC generation python script on the $(PROG).gedl file.

## More information about each step

### 1. Preprocessing annotation on C files
- Running `make preproc` will run the MULES CLE Preprocessor on all C files in the inpput directory. 
- The preprocessor will add Clang attributes for CLE annotations

### 2. Compiling a C code to LLVM IR
- Running `make compencs` will use Clang to interate through each C file in each subdirectory and compile into llvm linked files using the CLANG_FLAGS

### 3. Linking Subdirectory LLVM Linked Files
- Running `make perencll` will use llvm-link to link every .ll file in each subdirectory into one .ll file for each subdirectory
- Then it will run an opt pass using GEDL library on each combined .ll file to generate lists of defined and imported functions for each enclave

### 4. Linking GEDL LLVM Linked File
- Running `make gedlir` will use llvm-link to link the core .ll file for each subdirectory into a core gedl.ll file in $(ODIR)

### 5. Generating GEDL
-Running `make gedl` will run an opt pass using GEDL library on the gedl.ll file to generate the $(PROG).gedl file in $(ODIR)

## Additional Files
- IDLGenerator.py is used to generate $(PROG).idl for use with HAL Autogen CLOSURE Tool 
- RPCGenerator.py is used to generate *_rpc.c, *_rpc.h, and *.c files for compilation by MBIG CLOSURE tool

