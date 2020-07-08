#include <iostream>
#include <vector>
#include <string>
#include <exception>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <unistd.h>
#include <dirent.h>
#include <algorithm>

#include "json.hpp"

using namespace std;
using json = nlohmann::json;

#include "Partition.h"
#include "Report.h"

extern int verbose;

// trim from start (in place)
static inline void ltrim(std::string &s)
{
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](int ch) {
        return !std::isspace(ch);
    }));
}

// trim from end (in place)
static inline void rtrim(std::string &s)
{
    s.erase(std::find_if(s.rbegin(), s.rend(), [](int ch) {
        return !std::isspace(ch);
    }).base(), s.end());
}

// trim from both ends (in place)
static inline void trim(std::string &s)
{
    ltrim(s);
    rtrim(s);
}

void print_map(const char *name, unordered_map<string, string> &map)
{
   cout << name << endl;
   
   for_each(map.begin(),
            map.end() ,
            [](std::pair<std::string, string > element) {
               std::cout << "    " << element.first << " : "<< element.second << std::endl;
            });
   cout << endl;
}

string toString(vector<int> v)
{
    string rtn;
    for (int i : v)
        rtn += to_string(i) + " ";

    return rtn;
}


struct Point { float x, y, z; };

void to_json(json& j, const Point& p)
{
    j = {{"x", p.x}, {"y", p.y}, {"z", p.z}};
}

void to_json(json& j, const GuardHint& p) {
    string x = p.getOperation();

    std::vector<int> g = p.getGapstag();
    json j2 = g;

    j = json{
            {"operation", x},
            {"gapstag", j2}
    };
}


void to_json(json& j, const Cdf& p) {
    string r = p.getRemoteLevel();
    string d = p.getDirection();
    GuardHint g = p.getGuardHint();

    j = json{
            {"remotelevel", r },
            {"direction", d },
            {"guardhint", g },
    };
}

void to_json(json& j, CleJson& p)
{
    std::vector<Cdf> x = p.getCdf();
    json j2 = x;

    j = json{
            {"level", p.getLevel()},
            {"cdf", j2}
    };
}

void to_json(json& j, Cle& p) {
    CleJson cleJson = p.getCleJson();

    json j2;
    to_json(j2, cleJson);

    j = json{
        {"cle-label", p.getLabel()},
        {"cle-json", j2}
    };
}

void print_map_obj(const char *name, unordered_map<string, Cle> &map)
{
   cout << name << endl;
   
   for_each(map.begin(),
            map.end() ,
            [](std::pair<std::string, Cle > element) {
               Cle cle = element.second;
               json clejson;
               to_json(clejson, cle);
               std::cout << clejson.dump(4) << endl;
            });
   cout << endl;
}

MDNode* Partition::find_var(const Value* V, const Function* f)
{
   for (auto iter2 = f->getBasicBlockList().begin();
        iter2 != f->getBasicBlockList().end(); iter2++) {
      const BasicBlock &bb = *iter2;
         
      for (auto iter3 = bb.begin(); iter3 != bb.end(); iter3++) {
         const Instruction &inst = *iter3;

         if (const DbgDeclareInst* DbgDeclare = dyn_cast<DbgDeclareInst>(&inst)) {
            if (DbgDeclare->getAddress() == V)
               return DbgDeclare->getVariable();
         }
         else if (const DbgValueInst* DbgValue = dyn_cast<DbgValueInst>(&inst)) {
            if (DbgValue->getValue() == V)
               return DbgValue->getVariable();
         }
      }
   }
   return NULL;
}

/*
 * In a call to xdc_asyn_send, its 3rd argument is a local tag variable, which is an alloca instruction.
 * There is an llvm.dbg.declare call (DbgDeclareInst) corresponding to the alloca but it may appear 
 * anywhere in the caller function's basic blocks.
 * Search for DbgDeclareInst instructions, check if it is for an AllocaInst and if so compare 
 * that alloca with the alloca of interest and if equal get the variable name.
 * Find the uses of the alloca instruction to get to the tag_write.
 */
vector<int> Partition::find_local_variable(const Instruction *rpc_call, Value *value)
{
   vector<int> tags;  // return value
   AllocaInst *AI = dyn_cast<AllocaInst>(value);
   if (!AI)
      return tags;
   
   if (AI->hasName() ) {
      errs() << AI->getName() << "\n";
      return tags;
   }

   Function *Caller = AI->getParent()->getParent();
   // Search for llvm.dbg.declare
   for (BasicBlock& BB : *Caller) {
      for (Instruction &I : BB) {
         DbgDeclareInst *dbg = dyn_cast<DbgDeclareInst>(&I);
         if (!dbg)
            continue;
         
         AllocaInst *dbgAI = dyn_cast<AllocaInst>(dbg->getAddress());
         if (dbgAI != AI)
            continue;
               
         //if (DILocalVariable *varMD = dbg->getVariable())
         //   errs() << varMD->getName() << "\n";

         Instruction *inst = dbgAI;
         // errs() << "\t\tDef:" << *inst << "\n";

         for (User *U : inst->users()) {
            if (Instruction *Inst = dyn_cast<Instruction>(U)) {
               if (rpc_call == Inst)
                  continue;
               // errs() << "\t\tUse:" << *Inst << "\n";


               const CallInst *call = dyn_cast<CallInst>(Inst);
               if (!call)
                  continue;
            
               Function *func = call->getCalledFunction();
               string item = "";

               if (func->getName().compare("tag_write")) {
                  continue;
               }

               // errs() << "\t\tTag:  ";
               for (int i = 1; i < 4; i++) {
                  Value *val11 = call->getArgOperand(i);
                  if (llvm::ConstantInt* CI = dyn_cast<llvm::ConstantInt>(val11)) {
                     // errs() << CI->getSExtValue() << ", ";
                     tags.push_back(CI->getSExtValue());
                  }
                  else {
                     // errs() << "NonConstatnt" << ", ";
                     tags.clear();
                  }
               }
               // errs() << "\n";
               return tags;
            }
         }
      }
   }
   return tags;
}

void Partition::find_local_annotations()
{
   for (Module::const_iterator I = (**module)->getFunctionList().begin(),
           E = (**module)->getFunctionList().end(); I != E; ++I) {
      const Function &f = *I;
      StringRef fname = f.getName();

      for (auto iter2 = f.getBasicBlockList().begin();
           iter2 != f.getBasicBlockList().end(); iter2++) {
         const BasicBlock &bb = *iter2;
         
         for (auto iter3 = bb.begin(); iter3 != bb.end(); iter3++) {
            const Instruction &inst = *iter3;

            const CallInst *call = dyn_cast<CallInst>(&inst);
            if (!call)
               continue;
            
            Function *func = call->getCalledFunction();
            string item = "";

            if (func->getName().compare("llvm.var.annotation")) {
               continue;
            }
            
            Instruction *target = dyn_cast<Instruction>(call->getOperand(0));
            if (!target)
               continue;
            
            Value *targetGV = dyn_cast<Value>(target->getOperand(0));
            if (targetGV) {
               MDNode *md = find_var(targetGV, &f);
               if (md) {
                  DIVariable *div = dyn_cast<DIVariable>(md);
                  item = div->getName();
               }
               else {
                  cout << "ERROR: cannot find local variable name. missing debug symbols?" << endl;
                  item = "XXX";
               }
            }
                  
            ConstantExpr *ce = cast<ConstantExpr>(call->getOperand(1));
            if (!ce)
               continue;
            
            if (ce->getOpcode() != Instruction::GetElementPtr)
               continue;
            
            GlobalVariable *annoteStr = dyn_cast<GlobalVariable>(ce->getOperand(0));
            if (!annoteStr)
               continue;
            
            ConstantDataSequential *data = dyn_cast<ConstantDataSequential>(annoteStr->getInitializer());
            if (!data)
               continue;

            if (data->isString()) {
               string val = data->getAsString().str();
               // the string constnts in .ll file has an extra \00 at the end
               val = val.substr(0, val.length() -1);
               annotationMap[fname.str() + "." + item] = val;
            }
         }
      }
   }
}

void Partition::find_global_annotations()
{
   GlobalVariable* GA = (**module)->getGlobalVariable("llvm.global.annotations");
   if (!GA) {
      return;
   }
   
   ConstantArray *CA = dyn_cast<ConstantArray>(GA->getOperand(0));  // the list 

   for (auto OI = CA->op_begin(); OI != CA->op_end(); ++OI) {
      ConstantStruct *CS = dyn_cast<ConstantStruct>(OI->get());

      Value *targetGV = dyn_cast<Value>(CS->getOperand(0)->getOperand(0));
      string item = "";
      if (targetGV) {
         item = targetGV->getName().str();
      }

      GlobalVariable *AnnotationGL = dyn_cast<GlobalVariable>(CS->getOperand(1)->getOperand(0));
      StringRef annotation = dyn_cast<ConstantDataArray>(AnnotationGL->getInitializer())->getAsCString();

      if (item.length() > 0) {
         string val = annotation.str();
         trim(val);
         annotationMap[item] = val;
      }
      
      GlobalVariable *fileGV = dyn_cast<GlobalVariable>(CS->getOperand(2)->getOperand(0));
      StringRef fname = dyn_cast<ConstantDataArray>(fileGV->getInitializer())->getAsCString();
   }

   //for (Module::global_iterator I = (*module)->global_begin(), E = (*module)->global_end(); I != E; ++I) {
   //   if (I->getName() == "llvm.global.annotations") {
   //   }
   //}

   //   print_functions(module);
}

string Partition::find_tag_annotation(const Instruction* value, const Function* f)
{
   const BitCastInst *AI = dyn_cast<BitCastInst>(value);
   if (!AI)
      return nullptr;
   
   const Value* arg2 = dyn_cast<Value>(AI->getOperand(0));
   if (!arg2)
      return nullptr;
            
   // errs() << *arg2 << "\n";

   string item = "";
   MDNode *md = find_var(arg2, f);
   if (md) {
      DIVariable *div = dyn_cast<DIVariable>(md);
      item = div->getName();
   }
   else {
      cout << "ERROR: cannot find local variable name. missing debug symbols?" << endl;
      item = "XXX";
   }

   return f->getName().str() + "." + item;
}

void setResult(Entry &entry, bool pass, string &reason)
{
    entry.setPass(pass);
    entry.setReason(reason);
}

void Partition::verify_tag(string tag_ann, vector<int> tags, Entry &entry)
{
   string label = annotationMap[tag_ann];

/*
   for (std::pair<std::string, Cle> element : cleMap) {
      string labelx = element.first;
      Cle cle = cleMap[label]; //element.second;

      if (labelx.compare(label) == 0)
         std::cout << "XXX: " << label 
                   << ": " << cle.getCleJson().getLevel() << endl;
   }
*/      
   std::unordered_map<std::string, Cle>::const_iterator cle_iter = cleMap.find(label);
   if (cle_iter == cleMap.end()) {
      string reason = "no CLE for " + label;
      setResult(entry, false, reason);
      return;
   }      

   Cle cle = cleMap[label];
   vector<Cdf> cdfs = cle.getCleJson().getCdf();
   if (cdfs.size() > 1) {
      string reason = "multiple CDF";
      setResult(entry, false, reason);
      return;
   }
   
   entry.setEnclave(cle.getDirection());

   Cdf cdf = cdfs[0];
   vector<int> spec = cdf.getGuardHint().getGapstag();
   if (spec != tags) {
      string reason = "mismatched tag, " + toString(spec) + " v.s. " + toString(tags);
      setResult(entry, false, reason);
   }
   else {
       string reason = "tag matched, " + toString(spec);
       setResult(entry, true, reason);
   }
}

void Partition::find_rpc()
{
   for (Module::const_iterator I = (**module)->getFunctionList().begin(),
           E = (**module)->getFunctionList().end(); I != E; ++I) {
      const Function &f = *I;
      StringRef fname = f.getName();

      for (auto iter2 = f.getBasicBlockList().begin();
           iter2 != f.getBasicBlockList().end(); iter2++) {
         const BasicBlock &bb = *iter2;
         
         for (auto iter3 = bb.begin(); iter3 != bb.end(); iter3++) {
            const Instruction &inst = *iter3;

            const CallInst *call = dyn_cast<CallInst>(&inst);
            if (!call)
               continue;
            
            Function *func = call->getCalledFunction();
            string item = "";

            if (func->getName().compare("xdc_asyn_send")) {
               continue;
            }

            Entry entry;
            entry.setModule((**module)->getName().str());
            entry.setFunction(f.getName().str());

            std::string str;
            llvm::raw_string_ostream rso(str);
            call->print(rso);
            entry.setInstruction(str);
            
            Value *tagValue = call->getArgOperand(2);   // tag variable
            vector<int> tags = find_local_variable(&inst, tagValue);

            string tag_ann = "";
            Value *val11 = call->getArgOperand(1);   // tag annotation
            if (const Instruction* DbgValue = dyn_cast<Instruction>(val11)) {
               tag_ann = find_tag_annotation(DbgValue, &f);

               entry.setVariable(tag_ann);
               verify_tag(tag_ann, tags, entry);
            }
            report.addEntry(entry);
         }
      }
   }
}

void Partition::readCleJson(char *filename)
{
   std::ifstream cleStream(filename);
   json cleJson;
   cleStream >> cleJson;

   if (verbose)
      std::cout << "File: " << filename << endl;
   // cout << cleJson.size() << endl;
   for (int i = 0; i < cleJson.size(); i++) {
      string label = cleJson[i]["cle-label"];
      Cle cle = Cle::from_json(cleJson, i);

      cleMap[label] = cle;
   }
}

void Partition::readIRFile(char *filename)
{
   SMDiagnostic Err;
   LLVMContext context;
   
   Expected<std::unique_ptr<Module>> m = parseIRFile(filename, Err, context);
   if (!m) {
      Err.print(filename, errs());
      exit(1);
   }

   this->module = &m;
   
   // std::cout << "File: " << (**module)->getName().str() << std::endl;
   // std::cout << "Target triple: " << (*module)->getTargetTriple() << std::endl;

   find_global_annotations();
   find_local_annotations();
   find_rpc();
}

void Partition::print()
{
   print_map_obj("CLE", cleMap);
   print_map("Annotations", annotationMap);
}

void print_functions(Expected<std::unique_ptr<Module> > &Mod)
{
   for (Module::const_iterator I = (*Mod)->getFunctionList().begin(),
        E = (*Mod)->getFunctionList().end(); I != E; ++I) {
      const Function &f = *I;
      std::cout << " Function: " << f.getName().str() << std::endl;
      
      for (auto iter2 = f.getBasicBlockList().begin();
           iter2 != f.getBasicBlockList().end(); iter2++) {
         const BasicBlock &bb = *iter2;
         std::cout << "  BasicBlock: " << bb.getName().str() << std::endl;
         
         for (auto iter3 = bb.begin(); iter3 != bb.end(); iter3++) {
            const Instruction &inst = *iter3;
            std::cout << "   Instruction " << &inst << " : " << inst.getOpcodeName();
/*
            ConstantExpr *ce =  cast<ConstantExpr>(inst.getOperand(1));
            if (ce) {
               if (ce->getOpcode() == Instruction::GetElementPtr) {
                  if (GlobalVariable *annoteStr =
                      dyn_cast<GlobalVariable>(ce->getOperand(0))) {
                     if (ConstantDataSequential *data =
                         dyn_cast<ConstantDataSequential>(
                            annoteStr->getInitializer())) {
                        if (data->isString()) {
                           errs() << "Found data " << data->getAsString();
                        }
                     }
                  }
               }
            }
*/          
            unsigned int  i = 0;
            unsigned int opnt_cnt = inst.getNumOperands();
            for (; i < opnt_cnt; ++i) {
               Value *opnd = inst.getOperand(i);
               std::string o;
               //          raw_string_ostream os(o);
               //         opnd->print(os);
               //opnd->printAsOperand(os, true, m);
               if (opnd->hasName()) {
                  o = opnd->getName();
                  std::cout << " " << o << "," ;
               }
               else {
                  std::cout << " ptr" << opnd << ",";
               }
            }
            std:: cout << std::endl;
         }
      }
   }
}
