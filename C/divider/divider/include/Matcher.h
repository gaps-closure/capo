#ifndef MATCHER_H
#define MATCHER_H

#include <vector>

#include "clang/AST/ASTConsumer.h"
#include "clang/Frontend/CompilerInstance.h"

#include "clang/Basic/SourceManager.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/Rewrite/Core/Rewriter.h"
#include "clang/Rewrite/Frontend/FixItRewriter.h"
// #include "clang/Lex/Preprocessor.h"

#include "Topology.h"

using namespace clang;
using namespace ast_matchers;

class ClePair
{
private:
    SourceRange begin;
    SourceRange end;
    string pragma;

public:
    ClePair(SourceRange begin, SourceRange end, string pragma) {
        this->begin = begin;
        this->end = end;
        this->pragma = pragma;
    }

    SourceRange &getBegin() {
        return begin;
    }

    SourceRange &getEnd() {
        return end;
    }

    void setEnd(SourceRange end) {
        this->end = end;
    }

    string &getPragma() {
        return pragma;
    }
};

class Matcher
    : public clang::ast_matchers::MatchFinder::MatchCallback 
{
public:
    explicit Matcher(const clang::CompilerInstance &compiler,
                                   clang::Rewriter &rewriter, Topology topology)
        :ctx(&compiler.getASTContext()), 
         langOpts(compiler.getLangOpts()),
         rewriter(rewriter), 
         topology(topology),
         sm(compiler.getSourceManager()) {
        // compiler.getPreprocessor().SetSuppressIncludeNotFoundError(true);
    }
    
    void onEndOfTranslationUnit() override;
    void run(const clang::ast_matchers::MatchFinder::MatchResult &) override;
    bool isInFile(const clang::SourceManager &sm, const Decl *decl);

    static void addCleRangeOpen(SourceRange range, string pargma);
    static void addCleRangeClose(SourceRange range, string pargma);

    static vector<ClePair> &getCleRange() {
        return cleRange;
    }

    static void clearCleRange() {
        cleRange.clear();
    }

private:
    clang::ASTContext *ctx;
    clang::LangOptions langOpts;
    clang::Rewriter rewriter;
    Topology topology;
    vector<SourceRange> parentRanges;
    SourceManager &sm;
    static vector<ClePair> cleRange;

    bool matchFunctionDecl(const clang::SourceManager &sm, const FunctionDecl *func);
    bool matchFunctionCall(const clang::SourceManager &sm, const CallExpr *expr);

    bool matchVarDecl(const clang::SourceManager &sm, const VarDecl *var);
    bool matchVarRef(const clang::SourceManager &sm, const DeclRefExpr *varRef);

    bool matchRecordDecl(const clang::SourceManager &sm, const CXXRecordDecl *record);

    void showLoc(string msg, const clang::SourceManager &sm, const Decl *decl);
    void showLoc(string msg, const clang::SourceManager &sm, const Expr *expr);
    void showLoc(string msg, const clang::SourceManager &sm, SourceLocation begin, SourceLocation end);

    void replace(const clang::SourceManager &sm, SourceRange range);
    int isEnclosedInCle(SourceRange &range);
    SourceLocation findSemiAfterLocation(SourceLocation loc, ASTContext &Ctx, bool IsDecl);
};

class MatcherASTConsumer : public clang::ASTConsumer 
{
public:
    explicit MatcherASTConsumer(clang::CompilerInstance &compiler, Topology &topology,
                                       bool mainFileOnly, clang::Rewriter &rewriter);

    void HandleTranslationUnit(clang::ASTContext &ctx) {
        finder.matchAST(ctx);
    }

private:
    clang::SourceManager &sm;
    // Should this plugin be only run on the main translation unit?
    bool mainTUOnly = true;

    clang::ast_matchers::MatchFinder finder;
    Matcher matcherHandler;
};

#endif
