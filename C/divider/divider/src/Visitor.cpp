#include <iostream>

#include "clang/AST/AST.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/Sema/Sema.h"

#include "Visitor.h"
#include "Attr.h"
#include "Topology.h"

using namespace clang;
using namespace std;

void Visitor::init()
{
    for (auto level : topology.getLevels()) {
        string file = topology.getOutputDir() + "/" + level + "/" + topology.getFileInProcess();

        ofstream *fd = new ofstream();
        fd->open(file, ios::out | ios::trunc);

        fds[level] = fd;
    }
}

bool Visitor::output(Decl *Decl)
{
    if (Decl->hasAttrs()) {
        auto attr = Decl->getAttr<clang::AnnotateAttr>();
        // std::cout << attr->getAnnotation().str() << std::endl;
        string enclave = attr->getAnnotation().str();
        std::transform(enclave.begin(), enclave.end(), enclave.begin(), [](unsigned char c){
            return std::tolower(c);
        });

        auto pos = fds.find(enclave);
        if (pos == fds.end()) {
            std::cout << "Error: null file output stream for " << enclave << endl;
            return false;
        }
        else {
            SourceManager &SrcMgr = ctx->getSourceManager();
            SourceRange sr = Decl->getSourceRange();
            *pos->second << Lexer::getSourceText(CharSourceRange::getTokenRange(sr),
                                        SrcMgr,
                                        langOpts).str() << endl;   
            return false;
        }
    }
    else {
        for (auto it = fds.begin(); it != fds.end(); it++) {
            if (it->second == nullptr)
                continue;
            SourceManager &SrcMgr = ctx->getSourceManager();
            SourceRange sr = Decl->getSourceRange();
            *it->second << Lexer::getSourceText(CharSourceRange::getTokenRange(sr),
                                        SrcMgr,
                                        langOpts).str() << endl;   
        }
        return false;
    }
}

void Visitor::finish()
{
    for (auto it = fds.begin(); it != fds.end(); it++) {
        if (it->second != nullptr)
            it->second->close();
    }
}

bool Visitor::VisitCXXRecordDecl(CXXRecordDecl *Decl) 
{
    return output(Decl);

    // // Skip anonymous records, e.g. unions:
    // //    * https://en.cppreference.com/w/cpp/language/union
    // if (0 == Decl->getNameAsString().size())
    //     return true;

    // // checkNameStartsWithUpperCase(Decl);
    // // checkNoUnderscoreInName(Decl);
    // return true;
}

bool Visitor::VisitFunctionDecl(FunctionDecl *Decl) 
{
    return output(Decl);

    // Skip user-defined conversion operators/functions:
    //    * https://en.cppreference.com/w/cpp/language/cast_operator
    // if (isa<CXXConversionDecl>(Decl))
    //     return true;

    // checkNameStartsWithLowerCase(Decl);
    // checkNoUnderscoreInName(Decl);
    // return true;
}

bool Visitor::VisitVarDecl(VarDecl *Decl) 
{
    return output(Decl);

    // Skip anonymous function parameter declarations
    // if (isa<ParmVarDecl>(Decl) && (0 == Decl->getNameAsString().size()))
    //     return true;

    // checkNameStartsWithUpperCase(Decl);
    // checkNoUnderscoreInName(Decl);
    // return true;
}

bool Visitor::VisitFieldDecl(FieldDecl *Decl) 
{
    return output(Decl);

    // Skip anonymous bit-fields:
    //  * https://en.cppreference.com/w/c/language/bit_field
    // if (0 == Decl->getNameAsString().size())
    //     return true;

    // checkNameStartsWithUpperCase(Decl);
    // checkNoUnderscoreInName(Decl);

    // return true;
}

// class ClosureASTAction : public PluginASTAction 
// {
// public:
//     std::unique_ptr<ASTConsumer>
//     CreateASTConsumer(CompilerInstance &Compiler,
//                       llvm::StringRef InFile) override {
//         Topology topology;
//         return std::make_unique<ClosureDividerASTConsumer>(
//             Compiler, topology, MainTuOnly);
//     }

//     bool ParseArgs(const CompilerInstance &ci,
//                    const std::vector<std::string> &args) override {
//         for (StringRef arg : args) {
//             if (arg.startswith("-main-tu-only="))
//                 MainTuOnly = arg.substr(strlen("-main-tu-only=")).equals_insensitive("true");
//             else if (arg.startswith("-help"))
//                 PrintHelp(llvm::errs());
//             else
//                 return false;
//         }
//         return true;
//     }

//     void PrintHelp(llvm::raw_ostream &ros) {
//         ros << "Help for ClosureDivider plugin goes here\n";
//     }

// private:
//     bool MainTuOnly = true;
// };

// static clang::FrontendPluginRegistry::Add<ClosureASTAction>
//     X(/*Name=*/"ClosureDivider",
//       /*Description=*/"Checks whether class, variable and function names "
//                       "adhere to LLVM's guidelines");

static ParsedAttrInfoRegistry::Add<AttrInfo> Y("cle", "cle annotator");
