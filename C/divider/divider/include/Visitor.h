#ifndef VISITOR_H
#define VISITOR_H

#include <iostream>
#include <filesystem>
#include <fstream>
#include <map>

#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Frontend/CompilerInstance.h"

#include "Topology.h"

using namespace clang;

class Visitor
    : public clang::RecursiveASTVisitor<Visitor> 
{
public:
    explicit Visitor(const clang::CompilerInstance &compiler, Topology &topology)
       : ctx(&compiler.getASTContext()), 
         langOpts(compiler.getLangOpts()),
         topology(topology) {
            
        init();
    }

    ~Visitor() {
        finish();
    }

    bool VisitCXXRecordDecl(clang::CXXRecordDecl *decl);
    bool VisitFunctionDecl(clang::FunctionDecl *decl);
    bool VisitVarDecl(clang::VarDecl *decl);
    bool VisitFieldDecl(clang::FieldDecl *decl);

private:
    clang::ASTContext *ctx;
    clang::LangOptions langOpts;
    std::string outputDir;
    Topology topology;
    map<string, ofstream *> fds;
    
    void init();
    bool output(clang::Decl *decl);
    void finish();
};

#endif
