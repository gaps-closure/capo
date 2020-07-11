#pragma once

#include <iostream>
#include <unordered_map>

#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/ErrorOr.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Metadata.h>
#include <llvm/IR/Use.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/Bitcode/BitcodeReader.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/IRReader/IRReader.h>

#include "Cle.h"
#include "Report.h"
#include "Annotation.h"

using namespace std;
using namespace llvm;

class Partition
{
  private:
    string name;
    
    unordered_map<string, Cle> cleMap;
//    unordered_map<string, string> annotationMap;

    unordered_map<string, Annotation> annotationMap;

    Expected<std::unique_ptr<Module>>* module;

    Report report;

  public:
    Partition() {
    };
    
    ~Partition() {};

    int getNumErrors() {
        int count = 0;
        for (Entry entry : report.getEntries())
            if (!entry.isPass())
                count++;

        return count;
    }

    unordered_map<string, Cle> &getCleMap() {
        return cleMap;
    }
    
    void readIRFile(char *filename);
    void readCleJson(char *filename);
    void find_local_annotations();
    void find_global_annotations();
    void find_rpc();
    MDNode* find_var(const Value* V, const Function* f);
    void gen_tag_map();
    string find_tag_annotation(const Instruction* V, const Function* f);
    vector<int> find_local_variable(const Instruction *rpc_call, Value *value);
    void verify_tag(string tag_ann, vector<int> tags, Entry &entry);
    
    void print();

    Report& getReport() {
        return report;
    }

    void setReport(const Report& report)
    {
        this->report = report;
    }

    const string &getName() const {
        return name;
    }

    void setName(string name) {
        this->name = name;
    }

    unordered_map<string, Annotation> &getAnnotationMap() {
        return annotationMap;
    }
};

