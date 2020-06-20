#include <fstream>
#include "PDGHelper.h"
using namespace llvm;
using namespace pdg;

std::map<const Function *, FunctionWrapper *> pdg::funcMap;
std::map<const CallInst *, CallWrapper *> pdg::callMap;
std::set<InstructionWrapper *> pdg::instnodes;
std::set<InstructionWrapper *> pdg::globalList;
std::map<const Instruction *, InstructionWrapper *> pdg::instMap;
std::map<const Function *, std::set<InstructionWrapper *>> pdg::funcInstWList;

static std::list<std::string> ac_func_strings;
static bool ac_func_strings_read = false;

static void make_func_strings() {
  ac_func_strings_read = true;
  std::ifstream in("FUNC_STR.TXT");
  if (!in) {
    errs() << "Can't open FUNC_STR.TXT file\n";
    return;
  }
  std::string str;
  while (std::getline(in, str)) {
    if (str.size() > 0) ac_func_strings.push_back(str);
  }
  in.close();
}

static bool do_function(const std::string & fname) {
  if (!ac_func_strings_read) make_func_strings();
  if (ac_func_strings.empty()) return true; //no function defined, use all
  for (std::string & str : ac_func_strings) {
    if (fname.find(str) != std::string::npos) return true;
  }
  return false;
}

void pdg::constructInstMap(llvm::Function &F) {
        errs() << "AC_CIM:" << F.getName() << ":" << do_function(F.getName()) << "\n";
	if (! do_function(F.getName())) return;
        for (llvm::inst_iterator I = inst_begin(F), IE = inst_end(F); I != IE; ++I) {
            // llvm::errs() << "Current InstMap Size: " << instMap.size() << "\n";
            // if not in instMap yet, insert

            if (instMap.find(&*I) == instMap.end()) {
                InstructionWrapper *iw = new InstructionWrapper(&*I, &F, INST);
                instnodes.insert(iw);
                // instMap is used to store instruction that have seen
                instMap[&*I] = iw;
                // added in funcInstWList, indicate which instruction belongs to which
                // function
                funcInstWList[&F].insert(iw);
            }
        }
}

void pdg::constructFuncMap(Module &M) {
        for (Module::iterator F = M.begin(), E = M.end(); F != E; ++F) {
            Function *f = dyn_cast<Function>(F);
	    errs() << "AC_CFM:" << f->getName() << "\n";
            if (do_function(f->getName())) //AC
	      constructInstMap(*f);
            if (funcMap.find(f) == funcMap.end()) // if not in funcMap yet, insert
            {
                FunctionWrapper *fw = new FunctionWrapper(f);
                funcMap[f] = fw;
		InstructionWrapper * riw = new InstructionWrapper(f, ENTRY);//AC
		instnodes.insert(riw);//AC
		fw->setEntry(riw);//AC
		funcInstWList[f].insert(riw);//AC
            }
        }
}

void pdg::cleanupGlobalVars() {
    funcMap.clear();
    callMap.clear();
    instnodes.clear();
    globalList.clear();
    instMap.clear();
    funcInstWList.clear();
}

