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
#include "cle_json.h"
#include "util.h"

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
void trim(std::string &s)
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

void setResult(Entry &entry, bool pass, string &reason)
{
    entry.setPass(pass);
    entry.setReason(reason);
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
