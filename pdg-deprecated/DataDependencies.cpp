#include "DataDependencies.h"
//#include "FlowDependenceAnalysis.h"

using namespace llvm;

char pdg::DataDependencyGraph::ID = 0;

//AC
pdg::InstructionWrapper * getInstMap(llvm::Instruction * inst) {
  errs() << "AC_GIM1: " << "\n";
  if (inst == nullptr) return nullptr;
  errs() << "AC_GIM2: " << *inst << "\n";
  errs() << "AC_GIM3: " << (pdg::instMap[inst] == nullptr? "instW is null" : "instMap") << "\n";
  if (pdg::instMap[inst] != nullptr) return pdg::instMap[inst];
  errs() << "AC_GIM4: " << inst->getFunction()->getName() << "\n";
  errs() << "AC_GIM5: " << pdg::funcMap[inst->getFunction()]->getEntry() << "\n";
  return pdg::funcMap[inst->getFunction()]->getEntry();
}
//AC end

void pdg::DataDependencyGraph::initializeMemoryDependencyPasses() {
  AA = &getAnalysis<AAResultsWrapperPass>().getAAResults();
  MD = &getAnalysis<MemoryDependenceWrapperPass>().getMemDep();
}

void pdg::DataDependencyGraph::constructFuncMapAndCreateFunctionEntry() {
  if (funcMap[func]->getEntry() == NULL) {
    InstructionWrapper *root = new InstructionWrapper(func, ENTRY);
    instnodes.insert(root);
    funcInstWList[func].insert(root);
    funcMap[func]->setEntry(root);
  }
}

void pdg::DataDependencyGraph::collectDefUseDependency(llvm::Instruction *inst) {
  // check for def-use dependencies
  for (Instruction::const_op_iterator cuit = inst->op_begin();
       cuit != inst->op_end(); ++cuit) {
    if (Instruction *pInst = dyn_cast<Instruction>(*cuit)) {
      //Value *tempV = dyn_cast<Value>(*cuit);
      //DDG->addDependency(instMap[pInst], instMap[inst], DATA_DEF_USE);//AC orig
      DDG->addDependency(getInstMap(pInst), getInstMap(inst), DATA_DEF_USE);//AC
    }
  }
}

void pdg::DataDependencyGraph::collectCallInstDependency(llvm::Instruction *inst) {
  if(isa<CallInst>(inst)) {
    DEBUG(dbgs() << "This is a call Inst (DDG)" << "\n");
  }
}

std::vector<Instruction *> pdg::DataDependencyGraph::getDependencyInFunction(Instruction *pLoadInst) {
  std::vector<Instruction *> _flowdep_set;
  std::list<StoreInst *> StoreVec = funcMap[func]->getStoreInstList();

  // for each Load Instruction, find related Store Instructions(alias considered)
  LoadInst *LI = dyn_cast<LoadInst>(pLoadInst);

  MemoryLocation LI_Loc = MemoryLocation::get(LI);
//  for (int j = 0; j < StoreVec.size(); j++) {
  for (StoreInst* SI : StoreVec) {
//    StoreInst *SI = dyn_cast<StoreInst>(StoreVec[j]);
    MemoryLocation SI_Loc = MemoryLocation::get(SI);
    AliasResult AA_result = AA->alias(LI_Loc, SI_Loc);
    DEBUG(dbgs() << "  considering: " << *SI << "\n");
    DEBUG(dbgs() << "    locations AA: " << AA_result << "\n");
    if (AA_result != NoAlias && AA_result != MayAlias) {
      _flowdep_set.push_back(SI);
    }
  }
  return _flowdep_set;
}

void pdg::DataDependencyGraph::collectRAWDependency(llvm::Instruction *inst) {
  // dealing with dependencies in a function
  DEBUG(dbgs() << "Debugging flowdep_set for function: " << func->getName() << " for inst:" << *inst << "\n");
  std::vector<Instruction *> flowdep_set = getDependencyInFunction(inst);
  for (unsigned i = 0; i < flowdep_set.size(); i++) {
    DEBUG(dbgs() << "      adding dep: " << *flowdep_set[i] << "\n");
    //DDG->addDependency(instMap[flowdep_set[i]], instMap[inst], DATA_RAW);//AC orig
    DDG->addDependency(getInstMap(flowdep_set[i]), getInstMap(inst), DATA_RAW);//AC
  }
  flowdep_set.clear();
}

void pdg::DataDependencyGraph::collectNonLocalDependency(llvm::Instruction *inst) {
  // dealing with non local pointer dependency, nonLocalPointer dep is stored in result small vector
  SmallVector<NonLocalDepResult, 20> result;
  // the return result is NonLocalDepResult. can use getAddress function
  MD->getNonLocalPointerDependency(inst, result);
  // now result stores all possible
  DEBUG(dbgs() << "SmallVecter size = " << result.size() << '\n');

  for (NonLocalDepResult &I : result) {
    const MemDepResult &nonLocal_res = I.getResult();
    //AC orig
    //InstructionWrapper *itInst = instMap[inst];
    //InstructionWrapper *parentInst = instMap[nonLocal_res.getInst()];
    InstructionWrapper *itInst = getInstMap(inst);
    InstructionWrapper *parentInst = getInstMap(nonLocal_res.getInst());
    //AC end
    
    if (nullptr != nonLocal_res.getInst()) {
      DEBUG(dbgs() << "nonLocal_res.getInst(): " << *nonLocal_res.getInst()
                   << '\n');
      DDG->addDependency(itInst, parentInst, DATA_GENERAL);
    } else {
      DEBUG(dbgs() << "nonLocal_res.getInst() is a nullptr" << '\n');
    }
  }

}

void pdg::DataDependencyGraph::collectDataDependencyInFunc() {
  for (inst_iterator instIt = inst_begin(func), E = inst_end(func); instIt != E;
       ++instIt) {
    if (instMap[&*instIt] == nullptr) return;
    DDG->getNodeByData(instMap[&*instIt]);
    llvm::Instruction *pInstruction = dyn_cast<Instruction>(&*instIt);
    collectDefUseDependency(pInstruction);
    collectCallInstDependency(pInstruction);
    if (isa<LoadInst>(pInstruction)) {
      collectRAWDependency(pInstruction);
      collectNonLocalDependency(pInstruction);
    }
  }
}

bool pdg::DataDependencyGraph::runOnFunction(llvm::Function &F) {
  DEBUG(dbgs() << "++++++++++++++++++++++++++++++ DataDependency::runOnFunction "
          "+++++++++++++++++++++++++++++" << '\n');
  DEBUG(dbgs() << "Function name:" << F.getName().str() << '\n');
  func = &F;
  constructFuncMap(*func->getParent());
  initializeMemoryDependencyPasses();
  constructFuncMapAndCreateFunctionEntry();
  constructInstMap(F);
  collectDataDependencyInFunc();
  return false;
}

void pdg::DataDependencyGraph::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<AAResultsWrapperPass>();
  AU.addRequired<MemoryDependenceWrapperPass>();
  AU.setPreservesAll();
}

void pdg::DataDependencyGraph::print(raw_ostream &OS, const Module *) const {
  DDG->print(OS, (getPassName().data()));
}

static RegisterPass<pdg::DataDependencyGraph>
        DDG("ddg", "Data Dependency Graph Construction", false, true);

//pdg::DataDependencyGraph *CreateDataDependencyGraphPass() {
//  return new pdg::DataDependencyGraph();
//}
