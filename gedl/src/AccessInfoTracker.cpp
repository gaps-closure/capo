#include "AccessInfoTracker.hpp"

#include <iostream>
#include <sstream>

using namespace llvm;

char pdg::AccessInfoTracker::ID = 0;
llvm::cl::opt<std::string> programName("prog", llvm::cl::desc("Name of partitioned program"), llvm::cl::value_desc("programName"));
llvm::cl::opt<std::string> schemaPath("schema", llvm::cl::desc("Relative path to gedl schema"), llvm::cl::value_desc("schemaPath"));


bool pdg::AccessInfoTracker::runOnModule(Module &M) {
  if (!USEDEBUGINFO) {
    errs() << "[WARNING] No debug information avaliable... \nUse [-debug 1] in "
              "the pass to generate debug information\n";
    exit(0);
  }
  if (programName.empty()) {
    errs() << "[WARNING] No program name provided. Use -p argument to provide program name for artifact generation.\n";
    exit(0);
  }

  auto &pdgUtils = PDGUtils::getInstance();
  PDG = &getAnalysis<pdg::ProgramDependencyGraph>();
  CG = &getAnalysis<CallGraphWrapperPass>().getCallGraph();

  // Populate function name sets for [string, size, count] attributes
  Heuristics::populateStringFuncs();
  Heuristics::populateMemFuncs();
  Heuristics::populateprintfFuncs();

  std::string enclaveFile = programName + ".gedl";
  edl_file.open(enclaveFile);

  //For loop for every function to construct a map of every domain and the filepath for every function
  for (Function &function : M) {
    if (function.isDeclaration()) continue;  // skip intrinsic funcs
    // Get func Metadata and filepath
    DISubprogram *funcMeta =
        dyn_cast<llvm::DISubprogram>(function.getMetadata(0));
    std::string funcFilepath =
        funcMeta->getDirectory().str() + "/" + funcMeta->getFilename().str();
    std::string domain = funcFilepath;
    std::string functionName = function.getName().str();

    //Strip out all information from filepath except bottom level directory for domain name
    if (domain.find("/") != std::string::npos){
      domain = domain.substr(0,domain.find_last_of("/"));
      domain = domain.substr(domain.find_last_of("/")+1, domain.length() - domain.find_last_of("/"));
    }
    //Create entry for domain if one does not already exist
    if (domainMap.find(domain) == domainMap.end()){
      domainMap.insert(make_pair(domain, funcFilepath));
    }
    funcMap.insert(make_pair(functionName, funcFilepath));
  }

  //Function to create lists for all defined functions and imported functions across all domains
  populateLists();

  //Function to create a map of callsites for imported functions 
  populateCallsiteMap(M);

  //Function to create a map of all function annotations
  populateAnnotationMap(M);
  
  edl_file << "{\n";
  std::ifstream schema;
  schema.open(schemaPath);
  if ((!(schemaPath.empty())) && schema){
    edl_file << "\"$schema\": \"" << schemaPath << "\",\n";
  }


  edl_file << "\"gedl\": [";
  int firstElem = 0;
  firstDomain = false;

  //Call create domain for each domain in the domainMap
  for(auto elem: domainMap){

    createDomain(elem.first,M);
    

  }
  edl_file << "\n]}";


  // Clear function lists
  lockFuncList.clear();
  blackFuncList.clear();
  staticFuncList.clear();
  importedFuncList.clear();
  definedFuncList.clear();
  kernelFuncList.clear();


  edl_file.close();

  std::ifstream temp(enclaveFile);
  std::stringstream buffer;
  buffer << temp.rdbuf();
  edl_file.open(enclaveFile);

  for (auto el : userDefinedTypes) {
    edl_file << el.second;
  }
  edl_file << buffer.str();

  
  edl_file.close();
  return false;
}

void pdg::AccessInfoTracker::createDomain(std::string domain, Module &M) {

  // Get the main Functions closure for root ECALLs
  auto main = M.getFunction(StringRef("main"));
  auto mainClosure = getTransitiveClosure(*main);
  PDG->buildPDGForFunc(main);

  // Open file for ecall wrapper functions
  if (false){
    ecallsH.open("Ecalls.h");
    ecallsH << "#pragma once\n";
    ecallsH << "#include \"Enclave_u.h\"\n#include \"sgx_urts.h\"\n#include "
              "\"sgx_utils.h\"\n";
    ecallsH << "extern sgx_enclave_id_t global_eid;\n";

    ecallsC.open("Ecalls.cpp");
    ecallsC << "#include \"Ecalls.h\"\n";
    ecallsC << "sgx_enclave_id_t global_eid = 0;\n";
  }

  std::set<std::string> imports;
  std::map<std::string, std::set<std::string>> importFuncs;
  //For every imported function across all domains, check if they match current domain
  for (auto funcNameDefinition : importedFuncList) {
    if (funcNameDefinition.substr(funcNameDefinition.find(":") + 1) == domain){
      std::string funcName = funcNameDefinition.substr(0,funcNameDefinition.find(":"));
      std::string importDomain = "";
      //If a function matches the current domain, check if it is defined in any other domain
      for (auto impName : definedFuncList) {
          if (impName.substr(0,impName.find(":")) == funcName){
              importDomain = impName.substr(impName.find(":") + 1);
              break;
          }
      }
      //If an imported function is defined in anothed domain: 
      if (importDomain != ""){
        //Add that domain to imports set of domains if it does not exist
        if (imports.find(importDomain) == imports.end()){
          imports.insert(importDomain);
        }
        //Add the function to the set of imported functions in the map for that domain
        if (importFuncs.count(importDomain) > 0){
          importFuncs[importDomain].insert(funcName);
        } else{
          std::set<std::string> temp;
          temp.insert(funcName);
          importFuncs[importDomain] = temp;
        }
      }
    }
  }
  int beginningTracker = 0;
  std::string currentImport = "";
  //For every domain that this domain imports a function from:
  for (std::string importDomain : imports){
    //If this is the first domain pair, do not add a comma
    if (firstDomain && !(imports.empty())){
      edl_file << ",";
    } else if(!imports.empty()){
        firstDomain = true;
    }
    beginningTracker = 0;
    currentImport = "";
    //For every imported function for the current imported domain:
    for (std::string funcName : importFuncs[importDomain]){
      //If this is the first function for this pair, do not add a comma
      if (beginningTracker == 0){
        beginningTracker = 1;
      }
      else{
        edl_file << ",\n";
      }
      
      //If this is the first function for this pair, create the caller, callee, and calls fields
      if (currentImport == ""){
        currentImport = importDomain;
        edl_file << "\n\t{\n\t\t\"caller\": \"" << domain << "\",\n\t\t\"callee\": \""<< importDomain << "\",\n";
        edl_file << "\t\t\"calls\": [\n\t\t\t{\n";
      } //If this is not the first function, just add a new open brace
      else{
        edl_file << "\t\t\t{\n";
      }
      edl_file << "\t\t\t\t\"func\":\t\t\"" << funcName;

      //This block of code gets all of the information for the function from its name, namely where it is called
      crossBoundary = false;
      curImportedTransFuncName = funcName;
      auto func = M.getFunction(StringRef(funcName));
      if (func->isDeclaration()) continue;
      auto transClosure = getTransitiveClosure(*func);
      for (std::string staticFuncName : staticFuncList) {
        Function *staticFunc = M.getFunction(StringRef(staticFuncName));
        if (staticFunc && !staticFunc->isDeclaration())
          transClosure.push_back(staticFunc);
      }
      //For every callsite calling this function, gather read/write info for how the function and its arguments are used
      for (auto iter = transClosure.rbegin(); iter != transClosure.rend();
          iter++) {
        auto transFunc = *iter;
        if (transFunc->isDeclaration()) continue;
        if (definedFuncList.find(transFunc->getName()) != definedFuncList.end() ||
            staticFuncList.find(transFunc->getName()) != staticFuncList.end())
          crossBoundary = true;
        getIntraFuncReadWriteInfoForFunc(*transFunc);
      }
      writeCALLWrapper(*func, ecallsH, ecallsC, "_ECALL");

      //Generate the argument and return information for the function
      if (std::find(mainClosure.begin(), mainClosure.end(), func) !=
          mainClosure.end())  // This function is in main Funcs closure
        generateIDLforFunc(*func, true);  // It is possibly a root ECALL
      else
        generateIDLforFunc(*func, false);
      edl_file << "\t\t\t\t\"occurs\": [\n";

      //For every callsite of the function, generate an occurs object with the filepath and linenums
      for (auto filePath : callsiteMap[funcName]){
        edl_file << "\t\t\t\t\t{\"file\": \"" << filePath << "\", \"lines\": [";
        int startLine = 0;

        //For every linenum for the filepath, insert the linenum in the field
        for (auto lineNum : callsiteLines[(funcName + ":" + filePath)]){
          if (startLine == 0){
            startLine = 1;
          } else{
            edl_file << ",";
          }
          edl_file << lineNum;
        }
        edl_file << "]}\n";
      }
      edl_file << "\t\t\t\t]\n\t\t\t}";
    }  
    edl_file << "\n\t\t]";
    if (true || !imports.empty()){
      edl_file << "\n\t}";
    }
  }

  ecallsH.close();
  ecallsC.close();
}

void pdg::AccessInfoTracker::writeCALLWrapper(Function &F,
                                              std::ofstream &header,
                                              std::ofstream &cpp,
                                              std::string suffix) {
  auto &pdgUtils = PDGUtils::getInstance();
  DIType *funcRetType = DIUtils::getFuncRetDIType(F);
  std::string retTypeName;
  if (funcRetType == nullptr)
    retTypeName = "void";
  else
    retTypeName = DIUtils::getDITypeName(funcRetType);

  header << retTypeName << " " << F.getName().str() << suffix << "( ";
  cpp << retTypeName << " " << F.getName().str() << suffix << "( ";
  std::vector<std::pair<std::string, std::string> > argVec;
  for (auto argW : pdgUtils.getFuncMap()[&F]->getArgWList()) {
    Argument &arg = *argW->getArg();
    Type *argType = arg.getType();
    auto &dbgInstList = pdgUtils.getFuncMap()[&F]->getDbgDeclareInstList();
    std::string argName = DIUtils::getArgName(arg, dbgInstList);
    if (PDG->isStructPointer(argType)) {
      header << " " << DIUtils::getArgTypeName(arg) << " " << argName;
      cpp << " " << DIUtils::getArgTypeName(arg) << " " << argName;
      argVec.push_back(make_pair(DIUtils::getArgTypeName(arg), argName));
    } else {
      if (argType->getTypeID() == 15) {
        header << DIUtils::getArgTypeName(arg) << " " << argName;
        cpp << DIUtils::getArgTypeName(arg) << " " << argName;
        argVec.push_back(make_pair(DIUtils::getArgTypeName(arg), argName));

      } else {
        header << DIUtils::getArgTypeName(arg) << " " << argName;
        cpp << DIUtils::getArgTypeName(arg) << " " << argName;
        argVec.push_back(make_pair(DIUtils::getArgTypeName(arg), argName));
      }
    }

    if (argW->getArg()->getArgNo() < F.arg_size() - 1 && !argName.empty()) {
      header << ", ";
      cpp << ", ";
    }
  }
  header << ");\n";
  cpp << ") {\n";
  if (retTypeName != "void") {
    cpp << "\t" << retTypeName << " res;\n";
  }
  if (suffix == "_ECALL") {
    cpp << "\t" << F.getName().str() << "(global_eid";
    if (retTypeName != "void") {
      cpp << ", &res";
    }
    for (auto arg : argVec) {
      cpp << ", " << arg.second;
    }
    cpp << ");\n";
  } else {
    cpp << "\t" << F.getName().str() << "(";
    if (retTypeName != "void") {
      cpp << "&res";
    }
    for (unsigned i = 0; i < argVec.size(); i += 1) {
      if (i == 0 && retTypeName == "void") {
        cpp << argVec[i].second;
      } else
        cpp << ", " << argVec[i].second;
    }
    cpp << ");\n";
  }

  if (retTypeName != "void") {
    cpp << "\treturn res;\n";
  }
  cpp << "}\n";
}

void pdg::AccessInfoTracker::populateLists() {
  for(auto elem: domainMap){
    std::string domain = elem.first;
    std::ifstream importedFuncs(domain + "/imported_func.txt");
    std::ifstream definedFuncs(domain + "/defined_func.txt");
    std::ifstream blackFuncs(domain + "/blacklist.txt");
    std::ifstream static_funcptr(domain + "/static_funcptr.txt");
    std::ifstream static_func(domain + "/static_func.txt");
    std::ifstream lock_funcs(domain + "/lock_func.txt");
    // process global shared lock
    for (std::string line; std::getline(lock_funcs, line);)
      lockFuncList.insert(line + ":" + domain);
    for (std::string line; std::getline(blackFuncs, line);)
      blackFuncList.insert(line + ":" + domain);
    for (std::string staticFuncLine, funcPtrLine;
        std::getline(static_func, staticFuncLine),
        std::getline(static_funcptr, funcPtrLine);) {
      staticFuncList.insert(staticFuncLine + ":" + domain);
      staticFuncptrList.insert(funcPtrLine + ":" + domain);
    }
    for (std::string line; std::getline(importedFuncs, line);)
      if (blackFuncList.find(line) == blackFuncList.end())
        importedFuncList.insert(line + ":" + domain);
    
    for (std::string line; std::getline(definedFuncs, line);){
      //Loop through every function that has been added to the list so far
      // if current function is present it is doubly defined
      for (auto dupFuncCheck : definedFuncList){
        if ((dupFuncCheck.substr(0,dupFuncCheck.find(":"))) == line){
            errs() << "Function " << line << "is located in more than one domain. Please remove or rename the instance in either " << domain << " or " << dupFuncCheck.substr(dupFuncCheck.find(":") + 1) << "\n";
            throw("Duplicate defined function");
        }
      }
      definedFuncList.insert(line + ":" + domain);
    }

    // importedFuncList.insert(staticFuncptrList.begin(),
    // staticFuncptrList.end());
    seenFuncOps = false;
    kernelFuncList = importedFuncList;

    importedFuncs.close();
    definedFuncs.close();
    blackFuncs.close();
    static_funcptr.close();
    static_func.close();
    lock_funcs.close();
  }
  
}

void pdg::AccessInfoTracker::populateAnnotationMap(Module &M){
  //Attempt to create global varialbe for all llvm global annotations
  if(GlobalVariable* Annotations = M.getGlobalVariable("llvm.global.annotations")) {
    //For every annotation, create a constant struct for all of its values
    for (Value *AnnotationsValue : Annotations->operands()) {
      if (ConstantArray *AnnotationsArray = dyn_cast<ConstantArray>(AnnotationsValue)) {
        for (Value *AnnotationsArrayValues : AnnotationsArray->operands()) {
          if (ConstantStruct *ValuesStruct = dyn_cast<ConstantStruct>(AnnotationsArrayValues)) {
            if (ValuesStruct->getNumOperands() >= 2) {
              //Get the global variable for the first annotation of the function
              if(GlobalVariable* LabelAnno = M.getGlobalVariable(ValuesStruct->getOperand(1)->getOperand(0)->getName(), true)) {
                for (Value *LabelValue : LabelAnno->operands()) {
                  //Create constant from the label's value
                  if (ConstantDataArray *LabelArray = dyn_cast<ConstantDataArray>(LabelValue)) {
                    //Get the label as a string and cut off the terminating /00
                    std::string LabelStringg = LabelArray->getAsString().substr(0,LabelArray->getAsString().size()-1);
                    //Add the function and label to the annotation map
                    annotationMap[ValuesStruct->getOperand(0)->getOperand(0)->getName()] = LabelStringg;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void pdg::AccessInfoTracker::populateCallsiteMap(Module &M) {
  //Loop through all instructions of every function in the program
  for (Function &function : M) {
    for (BasicBlock &bb : function){
      for (Instruction &inst : bb){
        //If the instruction can be cast to a CallInst, there is a call to another function here
        if (CallInst *callInst = dyn_cast<CallInst>(&inst)) {
          std::string callFuncName, filePath, lineNum;
          //Attempt to get the called function from the instruction
          if (callInst->getCalledFunction()) {
            Function *calledFunc = callInst->getCalledFunction();
            //Skip function declarations
            if (calledFunc->isDeclaration()) continue;
            callFuncName = calledFunc->getName().str();
            //Get the debug information from which filepath and linenum can be determined
            const llvm::DebugLoc &debugInfo = inst.getDebugLoc();
            filePath = debugInfo->getDirectory().str() + "/" + debugInfo->getFilename().str();
            lineNum = std::to_string(debugInfo->getLine());
          } //If the function call is indirect, get from stripped indirect called value
          else { 
            Value* indirectValue = callInst->getCalledValue();
            Value* strippedVal = indirectValue-> stripPointerCasts();
            StringRef iFuncName = strippedVal->getName();
            //Get the debug information from which filepath and linenum can be determined
            const llvm::DebugLoc &debugInfo = inst.getDebugLoc();
            callFuncName = iFuncName.str();
            filePath = debugInfo->getDirectory().str() + "/" + debugInfo->getFilename().str();
            lineNum = std::to_string(debugInfo->getLine());
          }
          //Add callsite filepath to map if an entry exists, otherwise create new entry with single filepath
          if (callsiteMap.count(callFuncName) > 0){
            callsiteMap[callFuncName].insert(filePath);
          } else{
            std::set<std::string> tempSet;
            tempSet.insert(filePath);
            callsiteMap[callFuncName] = tempSet;
          }
          //Add callsite linenum to map if an entry exists, otherwise create new entry with single linenum
          if (callsiteLines.count(callFuncName + ":" + filePath) > 0){
            callsiteLines[callFuncName + ":" + filePath].insert(lineNum);
          } else{
            std::set<std::string> tempSet;
            tempSet.insert(lineNum);
            callsiteLines[callFuncName + ":" + filePath] = tempSet;
          }
        }
      }
    }
  }
  /*for (auto elem : callsiteMap){
    for (auto elem2 : &elem){
      for (auto elem3 : elem2){
        std::count << elem3 << "\n";
      }
    }
  }*/
}

void pdg::AccessInfoTracker::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<pdg::ProgramDependencyGraph>();
  AU.addRequired<CallGraphWrapperPass>();
  AU.setPreservesAll();
}

std::vector<Function *> pdg::AccessInfoTracker::getTransitiveClosure(
    Function &F) {
  std::vector<Function *> transClosure;
  transClosure.push_back(&F);
  std::queue<CallGraphNode *> funcNodeQ;
  std::set<Function *> seen;
  funcNodeQ.push(CG->getOrInsertFunction(&F));
  while (!funcNodeQ.empty()) {
    if (transClosure.size() > 100) return transClosure;

    auto callNode = funcNodeQ.front();
    funcNodeQ.pop();
    if (!callNode) continue;

    for (auto calleeNodeI = callNode->begin(); calleeNodeI != callNode->end();
         calleeNodeI++) {
      if (!calleeNodeI->second->getFunction()) continue;
      auto funcName = calleeNodeI->second->getFunction()->getName();
      if (blackFuncList.find(funcName) != blackFuncList.end()) continue;
      Function *calleeFunc = calleeNodeI->second->getFunction();
      if (calleeFunc->isDeclaration()) continue;
      if (seen.find(calleeFunc) != seen.end()) continue;
      funcNodeQ.push(calleeNodeI->second);
      transClosure.push_back(calleeFunc);
      seen.insert(calleeFunc);
    }
  }
  return transClosure;
}

AccessType pdg::AccessInfoTracker::getAccessTypeForInstW(
    const InstructionWrapper *instW, ArgumentWrapper *argW) {
  auto &pdgUtils = PDGUtils::getInstance();
  auto dataDList = PDG->getNodeDepList(instW->getInstruction());
  AccessType accessType = AccessType::NOACCESS;
  for (auto depPair : dataDList) {
    InstructionWrapper *depInstW =
        const_cast<InstructionWrapper *>(depPair.first->getData());
    DependencyType depType = depPair.second;
    //errs() << "\n" << *(depInstW->getInstruction()) << "\n";
    // check for read
    if (!depInstW->getInstruction() || depType != DependencyType::DATA_DEF_USE)
      continue;

    if (isa<LoadInst>(depInstW->getInstruction()) ||
        isa<GetElementPtrInst>(depInstW->getInstruction()))
      accessType = AccessType::READ;

    // check for store instruction.
    //errs() << *(depInstW->getInstruction()) << "\n";
    if (StoreInst *st = dyn_cast<StoreInst>(depInstW->getInstruction())) {
      // if a value is used in a store instruction and is the store destination
      if (dyn_cast<Instruction>(st->getPointerOperand()) ==
          instW->getInstruction()) {
        //errs() << *(st->getValueOperand()) << "\n";
        if (isa<Argument>(st->getValueOperand()))  // ignore the store inst that
                                                   // store arg to stack mem
          break;
        accessType = AccessType::WRITE;
        break;
      }
    }
    // Heuristic checks for string-only functions
    if (CallInst *callInst = dyn_cast<CallInst>(depInstW->getInstruction())) {
      // Get the funcName this argument is used as parameter
      std::string funcName;
      if (callInst->getCalledFunction()) {
        funcName = callInst->getCalledFunction()->getName().str();
      } else {  // continue if function is inaccessible
        continue;
      }
      int argNum = -1;
      int curr = 0;
      for (auto arg = callInst->arg_begin(); arg != callInst->arg_end();
           ++arg) {
        if (instW->getInstruction() == *arg) {
          argNum = curr;
          break;
        }
        curr += 1;
      }
      assert(argNum != -1 &&
             "argument is not found in the callInst's arguments");
      if (DIUtils::isCharPointerTy(*argW->getArg())) {
        // Check if it is in the string funcs list
        Heuristics::addStringAttribute(funcName, argNum, argW);
        Heuristics::checkPrintf(callInst, argNum, argW);
        // Check whether the called function has string attribute for the arg
        if (pdgUtils.getFuncMap().find(callInst->getCalledFunction()) !=
            pdgUtils.getFuncMap().end()) {
          auto funcW = pdgUtils.getFuncMap()[callInst->getCalledFunction()];
          if (argNum < funcW->getArgWList().size()) {
            ArgumentWrapper *innerArgW = funcW->getArgWList()[argNum];
            if (innerArgW->getAttribute().isString())
              argW->getAttribute().setString();
          }
        }
      }
      if (DIUtils::isVoidPointerTy(*argW->getArg()))
        Heuristics::addSizeAttribute(funcName, argNum, callInst, argW, PDG);
    }
  }
  return accessType;
}

void pdg::AccessInfoTracker::getIntraFuncReadWriteInfoForArg(
    ArgumentWrapper *argW, TreeType treeTy) {
  auto argTree = argW->getTree(treeTy);
  if (argTree.size() == 0) return;
  // throw new ArgParameterTreeSizeIsZero("Argment tree is empty... Every param
  // should have at least one node...\n");

  auto func = argW->getArg()->getParent();
  auto treeI = argW->getTree(treeTy).begin();
  // if (!(*treeI)->getTreeNodeType()->isPointerTy())
  if ((*treeI)->getDIType() == nullptr) {
    //errs() << "Empty debugging info for " << func->getName() << " - "
    //       << argW->getArg()->getArgNo() << "\n";
    return;
  }
  if ((*treeI)->getDIType()->getTag() != dwarf::DW_TAG_pointer_type &&
      !DIUtils::isTypeDefPtrTy(*argW->getArg())) {
     //errs() << func->getName() << " - " << argW->getArg()->getArgNo()
     //       << " Find non-pointer type parameter, do not track...\n";
    return;
  }
  AccessType accessType = AccessType::NOACCESS;
  auto &pdgUtils = PDGUtils::getInstance();
  int count = -1;
  if (DIUtils::isTypeDefPtrTy(*argW->getArg())) {
    argW->getAttribute().setIsPtr();
    // it can also be readonly
    if (DIUtils::isTypeDefConstPtrTy(*argW->getArg())) {
      argW->getAttribute().setReadOnly();
    }
  }
  for (auto treeI = argW->tree_begin(TreeType::FORMAL_IN_TREE);
       treeI != argW->tree_end(TreeType::FORMAL_IN_TREE); ++treeI) {
    count += 1;
    auto valDepPairList =
        PDG->getNodesWithDepType(*treeI, DependencyType::VAL_DEP);
    for (auto valDepPair : valDepPairList) {
      auto dataW = valDepPair.first->getData();
      AccessType accType = getAccessTypeForInstW(dataW, argW);

      if (static_cast<int>(accType) >
          static_cast<int>((*treeI)->getAccessType())) {
        auto &dbgInstList =
            pdgUtils.getFuncMap()[func]->getDbgDeclareInstList();
        std::string argName =
            DIUtils::getArgName(*(argW->getArg()), dbgInstList);

        if (accType == AccessType::WRITE) {
          argW->getAttribute().setOut();
        }
        if (count == 1 && accType == AccessType::READ) {
          argW->getAttribute().setIn();
        }
         //errs() << argName << " n" << count << "-"
         //       << getAccessAttributeName(treeI) << " => "
         //       << getAccessAttributeName((unsigned)accType) << "\n";

        (*treeI)->setAccessType(accType);
      }
    }
  }
  //Here is where return with pointer fails
  auto &dbgInstList2 =
            pdgUtils.getFuncMap()[func]->getDbgDeclareInstList();
  std::string argName2 =
      DIUtils::getArgName(*(argW->getArg()), dbgInstList2);
  errs() << "\nArgname:" << argName2 << "\n";
    for (auto func : pdgUtils.getFuncMap()) {
    if (!func.second->hasTrees()) {
      PDG->buildPDGForFunc(func.second->getRetW()->getFunc());
    }
    for (auto ecallInst :
         pdgUtils.getFuncMap()[func.first]->getCallInstList()) {
      if (ecallInst->getCalledFunction() != argW->getFunc()) continue;
      //errs() << *(ecallInst) << "\n"; 
      if (ecallInst->getNumArgOperands() < argW->getArg()->getArgNo()) continue;
      errs() << "Failed in arg8\n";
      Value *v = ecallInst->getOperand(argW->getArg()->getArgNo());
      if (isa<Instruction>(v) || isa<Argument>(v)) {
        // V is used in inst
        if (dyn_cast<Instruction>(v)) {
          // Get static array information
          if (GetElementPtrInst *getEl =
                  dyn_cast<GetElementPtrInst>(dyn_cast<Instruction>(v))) {
            Type *T = dyn_cast<PointerType>(getEl->getPointerOperandType())
                          ->getElementType();
            if (isa<ArrayType>(T)) {
              argW->getAttribute().setCount(
                  std::to_string(T->getArrayNumElements()));
            }
          }
        }
      }
    }
  }
}

void pdg::AccessInfoTracker::getIntraFuncReadWriteInfoForFunc(Function &F) {
  auto &pdgUtils = PDGUtils::getInstance();
  FunctionWrapper *funcW = pdgUtils.getFuncMap()[&F];
  // for arguments
  if (!pdgUtils.getFuncMap()[&F]->hasTrees()) {
    PDG->buildPDGForFunc(&F);
  }
  for (auto argW : funcW->getArgWList())
    getIntraFuncReadWriteInfoForArg(argW, TreeType::FORMAL_IN_TREE);
  // for return value
  ArgumentWrapper *retW = funcW->getRetW();
  getIntraFuncReadWriteInfoForArg(retW, TreeType::FORMAL_IN_TREE);
}

pdg::ArgumentMatchType pdg::AccessInfoTracker::getArgMatchType(Argument *arg1,
                                                               Argument *arg2) {
  Type *arg1_type = arg1->getType();
  Type *arg2_type = arg2->getType();

  if (arg1_type == arg2_type) return pdg::ArgumentMatchType::EQUAL;

  if (arg1_type->isPointerTy())
    arg1_type = (dyn_cast<PointerType>(arg1_type))->getElementType();

  if (arg1_type->isStructTy()) {
    StructType *arg1_st_type = dyn_cast<StructType>(arg1_type);
    for (unsigned i = 0; i < arg1_st_type->getNumElements(); ++i) {
      Type *arg1_element_type = arg1_st_type->getElementType(i);
      bool type_match = (arg1_element_type == arg2_type);

      if (arg2_type->isPointerTy()) {
        bool pointed_type_match =
            ((dyn_cast<PointerType>(arg2_type))->getElementType() ==
             arg1_element_type);
        type_match = type_match || pointed_type_match;
      }

      if (type_match) return pdg::ArgumentMatchType::CONTAINED;
    }
  }

  return pdg::ArgumentMatchType::NOTCONTAINED;
}

int pdg::AccessInfoTracker::getCallParamIdx(
    const InstructionWrapper *instW, const InstructionWrapper *callInstW) {
  Instruction *inst = instW->getInstruction();
  Instruction *callInst = callInstW->getInstruction();
  if (inst == nullptr || callInst == nullptr) return -1;

  if (CallInst *CI = dyn_cast<CallInst>(callInst)) {
    int paraIdx = 0;
    for (auto arg_iter = CI->arg_begin(); arg_iter != CI->arg_end();
         ++arg_iter) {
      if (Instruction *tmpInst = dyn_cast<Instruction>(&*arg_iter)) {
        if (tmpInst == inst) return paraIdx;
      }
      paraIdx++;
    }
  }
  return -1;
}

void pdg::AccessInfoTracker::generateRpcForFunc(Function &F, bool root) {
  auto &pdgUtils = PDGUtils::getInstance();
  DIType *funcRetType = DIUtils::getFuncRetDIType(F);
  if (DIUtils::isStructPointerTy(funcRetType) ||
      DIUtils::isStructTy(funcRetType)) {
    DIUtils::insertStructDefinition(funcRetType, userDefinedTypes);
  } else if (DIUtils::isEnumTy(funcRetType)) {
    DIUtils::insertEnumDefinition(funcRetType, userDefinedTypes);
  } else if (DIUtils::isUnionTy(funcRetType) ||
             DIUtils::isUnionPointerTy(funcRetType)) {
    DIUtils::insertUnionDefinition(funcRetType, userDefinedTypes);
  }
  std::string retTypeName;
  if (funcRetType == nullptr)
    retTypeName = "void";
  else
    retTypeName = DIUtils::getDITypeName(funcRetType);
  //Check if function return type is a pointer or a type unsupported by IDL and give a warning if it is
  if (retTypeName.find("*") != std::string::npos){ 
    llvm::errs() << "Return type " + retTypeName + " of function " + F.getName().str() + " is invalid: return type cannot be a pointer. Correct by changing function to void type and passing an argument to be modified as the return.\n\n";
    throw("Return type invalid (pointer)");
  }
  if (std::find(std::begin(acceptedTypes),std::end(acceptedTypes),retTypeName) == std::end(acceptedTypes)){
    llvm::errs() << "Return type " + retTypeName + " of function " + F.getName().str() + " is invalid: return type is unsupported, please change to supported type.\n\n";
  }
  //Add return field to gedl
  edl_file << "\",\n\t\t\t\t\"return\":\t{\"type\": \"" << retTypeName << "\"},\n\t\t\t\t";
  
  //Check if the annotation doesn't exist or could not be found and give a warning
  if (annotationMap.find(F.getName().str()) == annotationMap.end()){
    llvm::errs() << "Function " + F.getName().str() + " does not have a valid CLE label, or the label cannot be detected. Please add a label to the function then either rerun make or manually insert into GEDL";
    edl_file << "\"clelabel\":\t[user_check],\n\t\t\t\t\"params\": [\n";
  } else{
      //If annotation was found, add clelabel field
      edl_file << "\"clelabel\":\t\"" << annotationMap[F.getName().str()] << "\",\n\t\t\t\t\"params\": [\n";
  }

  // For every parameter, check if it is pointer or not and create an appropriate gedl line
  for (auto argW : pdgUtils.getFuncMap()[&F]->getArgWList()) {
    Argument &arg = *argW->getArg();
    Type *argType = arg.getType();
    auto &dbgInstList = pdgUtils.getFuncMap()[&F]->getDbgDeclareInstList();
    std::string argName = DIUtils::getArgName(arg, dbgInstList);
    std::string argTypeName = DIUtils::getArgTypeName(arg).substr(0,DIUtils::getArgTypeName(arg).find("*"));
    
    //Check if the argument is of an IDL supported type. If not, print a warning and set type to [user_check]
    if (std::find(std::begin(acceptedTypes),std::end(acceptedTypes),argTypeName) == std::end(acceptedTypes)){
      errs() << "Invalid type for argument " << argName << " for function " << F.getName().str() << " in file " << funcMap[F.getName().str()] << " please change to a supported type and rerun or modify in .gedl file.\n";
      argTypeName = "[user_check]";
    }
    //If the argument is a pointer type:
    if (argType->getTypeID() == 15 &&
        !(DIUtils::isUnionTy(DIUtils::getArgDIType(
            arg)))){  // Reject non pointer unions explicitly

      //Gather list of attributes and create type and name fields
      std::string attributesAll = argW->getAttribute().dump();
      edl_file << "\t\t\t\t\t{\"type\": \"" << argTypeName;
      edl_file << "\", \"name\": \"" << argName << "\", \"dir\": \"";

      //From attributes, create field for argument direction, setting to [user_check] and generating warning if it is undetermined
      if (attributesAll.find("in") != std::string::npos && attributesAll.find("out") != std::string::npos)
        edl_file << "inout\",";
      else if (attributesAll.find("out") != std::string::npos)
        edl_file << "out\",";
      else if (attributesAll.find("in") != std::string::npos)
        edl_file << "in\",";
      else {
        errs() << "Direction for argument " << argName << " for function " << F.getName().str() << " in file " << funcMap[F.getName().str()] << " could not be conclusively determined. Please correct in .gedl to in/out/inout.\n";
        edl_file << "[user_check]\",";
      }
      edl_file << " \"sz\":";
      //From attributes determine arguments size or if it is a string, if undetermined mark as [user_check] and give a warning
      if (attributesAll.find("string") != std::string::npos)
        edl_file << "\"string\"}";
      else if (attributesAll.find("count") != std::string::npos)
        edl_file << "" << argW->getAttribute().getCount()  << "}";
      else if (attributesAll.find("size") != std::string::npos)
        edl_file << "" << argW->getAttribute().getSize()  << "}";
      else{
        errs() << "Size of argument " << argName << " for function " << F.getName().str() << " in file " << funcMap[F.getName().str()] << " could not be conclusively determined. Marking as \"user_check\", please manually specify size or rewrite function code to comply with Capo requirements and run again.\n";
        edl_file << "\"user_check\"}";
      }

    }
    else{
      //If argument is not a pointer, create simple field entry
      edl_file << "\t\t\t\t\t{\"type\": \"" << argTypeName;
      edl_file << "\", \"name\": \"" << argName << "\", \"dir\": \"in\"}";
    }
    //If there are more arguments to add, insert a comma
    if (argW->getArg()->getArgNo() < F.arg_size() - 1 && !argName.empty())
      edl_file << ", ";
    edl_file << "\n";
  }
  edl_file << "\t\t\t\t],\n";
}

void pdg::AccessInfoTracker::generateIDLforFunc(Function &F, bool root) {
  // if a function is defined on the same side, no need to generate IDL rpc for
  // this function.
  auto &pdgUtils = PDGUtils::getInstance();
  FunctionWrapper *funcW = pdgUtils.getFuncMap()[&F];
  for (auto argW : funcW->getArgWList()) {
    generateIDLforArg(argW, TreeType::FORMAL_IN_TREE);
  }
  generateIDLforArg(funcW->getRetW(), TreeType::FORMAL_IN_TREE);
  generateRpcForFunc(F, root);
}

void pdg::AccessInfoTracker::generateIDLforArg(ArgumentWrapper *argW,
                                               TreeType treeTy,
                                               std::string funcName,
                                               bool handleFuncPtr) {
  auto &pdgUtils = PDGUtils::getInstance();
  if (argW->getTree(TreeType::FORMAL_IN_TREE).size() == 0 ||
      argW->getArg()->getArgNo() == 100)  // No need to handle return args
    return;

  Function &F = *argW->getArg()->getParent();
  auto check = argW->tree_begin(treeTy);

  if (funcName.empty()) funcName = F.getName().str();

  auto &dbgInstList = pdgUtils.getFuncMap()[&F]->getDbgDeclareInstList();
  std::string argName = DIUtils::getArgName(*(argW->getArg()), dbgInstList);
  std::string sharedFieldPrefix = curImportedTransFuncName + argName;
  auto curDIType = (*check)->getDIType();
  if (DIUtils::isStructPointerTy(curDIType) || DIUtils::isStructTy(curDIType)) {
    DIUtils::insertStructDefinition(DIUtils::getArgDIType(*argW->getArg()),
                                    userDefinedTypes);
  } else if (DIUtils::isEnumTy(curDIType)) {
    DIUtils::insertEnumDefinition(DIUtils::getArgDIType(*argW->getArg()),
                                  userDefinedTypes);
  } else if (DIUtils::isUnionTy(curDIType) ||
             DIUtils::isUnionPointerTy(curDIType)) {
    DIUtils::insertUnionDefinition(DIUtils::getArgDIType(*argW->getArg()),
                                   userDefinedTypes);
  } else if (DIUtils::isTypeDefTy(curDIType)) {
    auto base = dyn_cast<DIDerivedType>(curDIType)->getBaseType();
    if (DISubroutineType *diSub =
            dyn_cast<DISubroutineType>(DIUtils::getLowestDIType(base))) {
      llvm::errs() << "Function pointer typedef found for " << *base << "\n";
    } else {
      DIFile *file = curDIType->getFile();
      if (file == nullptr) file = base->getFile();
      if (file != nullptr &&
          file->getFilename().str().find("/usr/include") != 0) {
        userDefinedTypes.insert({file->getFilename().str(),
                                 "include \"" + file->getFilename().str() +
                                     "\" // For param: " + argName + "\n"});
      }
    }
  }
}

std::string pdg::getAccessAttributeName(
    tree<InstructionWrapper *>::iterator treeI) {
  int accessIdx = static_cast<int>((*treeI)->getAccessType());
  return getAccessAttributeName(accessIdx);
}

std::string pdg::getAccessAttributeName(unsigned accessIdx) {
  std::vector<std::string> access_attribute = {"[-]", "[in]", "[out]"};
  return access_attribute[accessIdx];
}

static RegisterPass<pdg::AccessInfoTracker> AccessInfoTracker(
    "accinfo-track", "Argument access information tracking Pass", false, true);