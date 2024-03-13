#include <iostream>
#include <regex>
#include <fstream>

#include "clang/AST/AST.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/Sema/Sema.h"

#include "Attr.h"
#include "Matcher.h"
#include "Topology.h"

using namespace clang;
using namespace std;
using namespace ast_matchers;

vector<ClePair> Matcher::cleRange;

MatcherASTConsumer::MatcherASTConsumer(
    clang::CompilerInstance &compiler,
    Topology &topology,
    bool mainFileOnly, 
    clang::Rewriter &rewriter)
    : sm(compiler.getSourceManager()), 
      mainTUOnly(mainFileOnly),
      matcherHandler(compiler, rewriter, topology) 
{
    const auto matcherForMemberAccess = cxxMemberCallExpr(
        callee(memberExpr(member(hasName("oldName"))).bind("MemberAccess")),
        thisPointerType(cxxRecordDecl(isSameOrDerivedFrom(hasName("className")))));
    finder.addMatcher(matcherForMemberAccess, &matcherHandler);

    const auto matcherForMemberDecl = cxxRecordDecl(
        allOf(isSameOrDerivedFrom(hasName("className")),
                hasMethod(decl(namedDecl(hasName("oldName"))).bind("MemberDecl"))));
    finder.addMatcher(matcherForMemberDecl, &matcherHandler);

    // const auto method = cxxMethodDecl(
    //     hasDescendant(decl(namedDecl(hasName(oldName))).bind("method")));
    // const auto method = cxxMethodDecl(hasName(oldName)).bind("method");   // ok
        // hasDescendant(cxxMethodDecl(hasName(oldName)))).bind("method");
    // const auto functionDecl(hasDescendant(callExpr().bind("functionCall")));

    // const auto funcDecl = functionDecl().bind("FunctionDecl");
    // finder.addMatcher(funcDecl, &matcherHandler);

    for (Annotation annotation: topology.getFunctions()) {
        // llvm::outs() << "#### " << annotation.getName() << "\n";
        string funcName = annotation.getName();
        const auto funcDecl = functionDecl(hasName(funcName)).bind("FunctionDecl");
        finder.addMatcher(funcDecl, &matcherHandler);

        // const auto funcCall = callExpr(callee(functionDecl(hasName(funcName)))).bind("FunctionCall");
        // finder.addMatcher(funcCall, &matcherHandler);
    }
    // const auto funcCall = callExpr(callee(functionDecl(hasName(annotation.getName()))),
    //                                    argumentCountIs(0)).bind("FunctionCall");

    for (Annotation annotation: topology.getGlobalScopedVars()) {
        string varName = annotation.getName();
        const auto vDecl = varDecl(hasName(varName), 
                                   hasGlobalStorage(),
                                   isDefinition()).bind("VarDecl");
        finder.addMatcher(vDecl, &matcherHandler);

        // const auto varRef = declRefExpr(varDecl(hasName(varName))).bind("varRef");
        // const auto varRef =  declRefExpr(to(varDecl(hasName(varName)))).bind("VarRef");
        // finder.addMatcher(varRef, &matcherHandler);
    }

    const auto fdDecl = fieldDecl().bind("FieldDecl");
    finder.addMatcher(fdDecl, &matcherHandler);

    const auto mdDecl = cxxMethodDecl().bind("CXXMethodDecl");
    finder.addMatcher(mdDecl, &matcherHandler);

    const auto recordDecl = cxxRecordDecl().bind("CXXRecordDecl");
    finder.addMatcher(recordDecl, &matcherHandler);
}

void Matcher::run(const MatchFinder::MatchResult &result) 
{
    const clang::SourceManager &sm = *result.SourceManager;

    const MemberExpr *memberAccess = result.Nodes.getNodeAs<clang::MemberExpr>("MemberAccess");
    if (memberAccess) {
        // printf("access............\n");
        SourceRange callExprSrcRange = memberAccess->getMemberLoc();
        rewriter.ReplaceText(callExprSrcRange, "XXX");
    }

    const NamedDecl *memberDecl = result.Nodes.getNodeAs<clang::NamedDecl>("MemberDecl");
    if (memberDecl && isInFile(sm, memberDecl)) {
        showLoc("decl", sm, memberDecl);

        SourceRange memberDeclSrcRange = memberDecl->getLocation();
        rewriter.ReplaceText(CharSourceRange::getTokenRange(memberDeclSrcRange), "XXX");
    }

    const FunctionDecl *func = result.Nodes.getNodeAs<clang::FunctionDecl>("FunctionDecl");
    if (func && isInFile(sm, func)) {  // func->hasAttrs() && 
        matchFunctionDecl(sm, func);
    }

    // const CallExpr *call = result.Nodes.getNodeAs<clang::CallExpr>("FunctionCall");
    // if (call) { // && isInFile(sm, call)) {  // func->hasAttrs() && 
    //     matchFunctionCall(sm, call);
    // }

    const VarDecl *var = result.Nodes.getNodeAs<clang::VarDecl>("VarDecl");
    if (var && isInFile(sm, var) && !var->isLocalVarDecl()) { // && var->hasAttrs() ) {
        matchVarDecl(sm, var); 
    }

    // const DeclRefExpr *varRef = result.Nodes.getNodeAs<clang::DeclRefExpr>("VarRef");
    // if (varRef) { // && isInFile(sm, varRef)) { // && var->hasAttrs() ) {
    //     matchVarRef(sm, varRef); 
    // }

    const FieldDecl *field = result.Nodes.getNodeAs<clang::FieldDecl>("FieldDecl");
    if (field && field->hasAttrs() && isInFile(sm, field)) {
        // showLoc("FieldDecl......", sm, field);
    }

    const CXXMethodDecl *method = result.Nodes.getNodeAs<clang::CXXMethodDecl>("CXXMethodDecl");
    if (method && method->hasAttrs() && isInFile(sm, method)) {
        showLoc("CXXMethodDecl......", sm, method);
        // SourceRange methodRange = method->getSourceRange();
        // rewriter.ReplaceText(methodRange, "XXX");
    }

    const CXXRecordDecl *record = result.Nodes.getNodeAs<clang::CXXRecordDecl>("CXXRecordDecl");
    if (record && isInFile(sm, record)) { // && record->hasAttrs()) {
        matchRecordDecl(sm, record); 
    }
}

bool Matcher::matchFunctionDecl(const clang::SourceManager &sm, const FunctionDecl *func)
{
    string &level = topology.getLevelInProgress();
    string funcName = func->getNameInfo().getAsString();

    if (topology.isNameInLevel(funcName, level))
        return true;    // keep it

    // showLoc("FunctionDecl......", sm, func);

    const FunctionDecl* def = NULL;
    func->hasBody(def);
    // if (!func->hasBody(def))
        // return true;

    SourceRange range = func->getSourceRange();
    int idx = isEnclosedInCle(range);
    if (idx >= 0) {
        ClePair clePair = cleRange[idx];
        replace(sm, clePair.getBegin());
        replace(sm, clePair.getEnd());
    }

    replace(sm, range);

    // From clang doxygen:
    /// "The function body might be in any of the (re-)declarations of this
    /// function. The variant that accepts a FunctionDecl pointer will set that
    /// function declaration to the actual declaration containing the body (if
    /// there is one)"
    // For example:
    // static void mg_sendnsreq();
    // static void mg_sendnsreq() {}
    // The following tries to erase the ; in the above example.
    if (def != func) {
        SourceLocation loc = findSemiAfterLocation(func->getEndLoc(), *ctx, true);
        rewriter.ReplaceText (loc, 1, " ");
    }

    return true;
}

bool Matcher::matchFunctionCall(const clang::SourceManager &sm, const CallExpr *call)
{
    const FunctionDecl *callee = call->getDirectCallee();
    string funcName = callee->getNameInfo().getAsString();
    string &level = topology.getLevelInProgress();

    if (topology.isNameInLevel(funcName, level))
        return true;    // keep it

    SourceRange range = call->getSourceRange();
    // check if containing function has been erasded
    bool erased = false;
    for (SourceRange sr : parentRanges) {
        if (sr.fullyContains(range)) {
            erased = true;
            break;
        }
    }
    if (!erased) {
        // showLoc("FunctionCall......", sm, call);
        StringRef prefix("_err_handler_rpc_");
        rewriter.InsertTextBefore(call->getBeginLoc(), prefix);
    }
    return true;
}

bool Matcher::matchVarDecl(const clang::SourceManager &sm, const VarDecl *var)
{
    string &level = topology.getLevelInProgress();
    string varName = var->getName().str();

    if (topology.isNameInLevel(varName, level))
        return true;    // keep it

    SourceRange range = var->getSourceRange();

    // showLoc("VarDecl......", sm, var);

    int idx = isEnclosedInCle(range);
    if (idx >= 0) {
        ClePair clePair = cleRange[idx];
        replace(sm, clePair.getBegin());
        replace(sm, clePair.getEnd());
    }

    replace(sm, range);

    SourceLocation loc = findSemiAfterLocation(var->getEndLoc(), *ctx, true);
    rewriter.ReplaceText (loc, 1, " ");

    return true;
}

bool Matcher::matchVarRef(const clang::SourceManager &sm, const DeclRefExpr *varRef)
{
    return true;  // TODO

    string &level = topology.getLevelInProgress();
    string varName = varRef->getNameInfo().getAsString();

    showLoc("VarRef......", sm, varRef);
    if (topology.isNameInLevel(varName, level))
        return true;    // keep it

    SourceRange range = varRef->getSourceRange();
    LangOptions langOpts;
    // TODO: the following line leads to crash
    std::string original = rewriter.getRewrittenText(range);
    
    // TODO: not complete because of the crash above
    llvm::outs() << Lexer::getSourceText(CharSourceRange::getTokenRange(range), sm, langOpts).str() << "\n";   

    StringRef prefix("_err_handler_rpc_");
    rewriter.InsertTextBefore(varRef->getBeginLoc(), prefix);
    // rewriter.ReplaceText(CharSourceRange::getTokenRange(range), "XXX");
    return true;
}

bool Matcher::matchRecordDecl(const clang::SourceManager &sm, const CXXRecordDecl *record)
{
    string &level = topology.getLevelInProgress();
    string className = record->getNameAsString();

    if (topology.isInEnclave(className, level) || !record->hasDefinition())
        return true;    // keep it

    // showLoc("RecordDecl......", sm, record);
    replace(sm, record->getSourceRange());

    SourceLocation loc = findSemiAfterLocation(record->getEndLoc(), *ctx, true);
    rewriter.ReplaceText (loc, 1, " ");

    return true;
}

/// \arg Loc is the end of a statement range. This returns the location
/// of the semicolon following the statement.
/// If no semicolon is found or the location is inside a macro, the returned
/// source location will be invalid.
SourceLocation Matcher::findSemiAfterLocation(SourceLocation loc,
    ASTContext &Ctx,
    bool IsDecl) 
{
    SourceManager &SM = Ctx.getSourceManager();
    if (loc.isMacroID()) {
        if (!Lexer::isAtEndOfMacroExpansion(loc, SM, Ctx.getLangOpts(), &loc))
            return SourceLocation();
    }
    loc = Lexer::getLocForEndOfToken(loc, /*Offset=*/0, SM, Ctx.getLangOpts());

    // Break down the source location.
    std::pair<FileID, unsigned> locInfo = SM.getDecomposedLoc(loc);

    // Try to load the file buffer.
    bool invalidTemp = false;
    StringRef file = SM.getBufferData(locInfo.first, &invalidTemp);
    if (invalidTemp) 
        return SourceLocation();

    const char *tokenBegin = file.data() + locInfo.second;

    // Lex from the start of the given location.
    Lexer lexer(SM.getLocForStartOfFile(locInfo.first), Ctx.getLangOpts(),
                file.begin(), tokenBegin, file.end());
    Token tok;
    lexer.LexFromRawLexer(tok);
    if (tok.isNot(tok::semi)) {
        if (!IsDecl) 
            return SourceLocation();
        // Declaration may be followed with other tokens; such as an __attribute,
        // before ending with a semicolon.
        return findSemiAfterLocation(tok.getLocation(), Ctx, /*IsDecl*/ true);
    }
    return tok.getLocation();
}

void Matcher::onEndOfTranslationUnit() 
{
    string file = topology.getOutputFile();
    llvm::outs() << "\t \t" << file << "\n";

    std::error_code error_code;
    llvm::raw_fd_ostream outFile(file, error_code, llvm::sys::fs::OF_None);
    rewriter.getEditBuffer(rewriter.getSourceMgr().getMainFileID()).write(outFile);
    outFile.close();

    // rewriter.getEditBuffer(rewriter.getSourceMgr().getMainFileID())
    //         .write(llvm::outs());
}

bool Matcher::isInFile(const clang::SourceManager &sm, const Decl *decl)
{
    string file = sm.getFilename(decl->getLocation()).str();
    string &target = topology.getFileInProcess();

    return (file.length() >= target.length() &&
            !file.compare(file.length() - target.length(), target.length(), target));
}

int Matcher::isEnclosedInCle(SourceRange &range)
{
    int line = sm.getSpellingLineNumber(range.getBegin());

    for (size_t i = 0; i < cleRange.size(); i++) {
        ClePair clePair = cleRange[i];
        SourceRange open = clePair.getBegin();
        int lineOpen = sm.getSpellingLineNumber(open.getBegin());

        SourceRange close = clePair.getEnd();
        int lineClose = sm.getSpellingLineNumber(close.getBegin());

        if (line > lineOpen && line < lineClose) {
            return i;
        }
    }
    return -1;
}

void Matcher::addCleRangeOpen(SourceRange range, string pragma) 
{
    cleRange.push_back(ClePair(range, range, pragma));
}

void Matcher::addCleRangeClose(SourceRange range, string pragma) 
{
    if (cleRange.size() <= 0) {
         llvm::outs() << "ERROR: missing CLE begin\n";
         return;
    }
    ClePair &last = cleRange[cleRange.size() - 1];
    string pragma_begin = last.getPragma();
    if (pragma_begin.find("#pragma cle begin ") == string::npos) {
        llvm::outs() << "ERROR: pragma not matched: " << pragma_begin << " v.s. " << pragma << "\n";
        return;
    }
    string name_begin = pragma_begin.substr(pragma_begin.find_last_of(" "));
    string name_end = pragma.substr(pragma.find_last_of(" "));

    if (name_begin.compare(name_end)) {
        llvm::outs() << "ERROR: unmatched pragmas: " << pragma_begin << " v.s. " << pragma << "\n";
    }
    last.setEnd(range);
}

void Matcher::replace(const clang::SourceManager &sm, SourceRange range)
{
    SourceRange expansion_range(sm.getExpansionLoc(range.getBegin()),
                                sm.getExpansionLoc(range.getEnd()));

    std::string original = rewriter.getRewrittenText(expansion_range);
    // erase all other than whitespace; 
    // keep source range line numbers intact for matchFunctionCall()
    std::regex non_ws("[^\\s]");
    string modified = std::regex_replace(original, non_ws, " ");
    rewriter.ReplaceText(CharSourceRange::getTokenRange(expansion_range), modified);

    parentRanges.push_back(range);
}

void Matcher::showLoc(string msg, const clang::SourceManager &sm, const Decl *decl)
{
    showLoc(msg, sm, decl->getBeginLoc(), decl->getEndLoc());

    auto attr = decl->getAttr<clang::AnnotateAttr>();
    if (attr != nullptr)
        std::cout << attr->getAnnotation().str() << std::endl;
}

void Matcher::showLoc(string msg, const clang::SourceManager &sm, const Expr *expr)
{
    showLoc(msg, sm, expr->getBeginLoc(), expr->getEndLoc());

    // auto attr = expr->getAttr<clang::AnnotateAttr>();
    // if (attr != nullptr)
    //     std::cout << attr->getAnnotation().str() << std::endl;    
}

// Get a "file:line:column" source location string.
static std::string getSourceLocationString(const clang::SourceManager &sm, SourceLocation loc, bool filename) 
{
    if (loc.isInvalid())
        return std::string("(none)");

    if (loc.isFileID()) {
        PresumedLoc PLoc = sm.getPresumedLoc(loc);

        if (PLoc.isInvalid()) {
            return std::string("(invalid)");
        }

        std::string Str;
        llvm::raw_string_ostream SS(Str);

        // The macro expansion and spelling pos is identical for file locs.
        SS << (filename ? PLoc.getFilename() : "") << (filename ? ":" : "")
           << PLoc.getLine() << ':'
           << PLoc.getColumn();

        std::string result = SS.str();
        // YAML treats backslash as escape, so use forward slashes.
        std::replace(result.begin(), result.end(), '\\', '/');

        return result;
    }
    return std::string("(nonfile)");
}

void Matcher::showLoc(string msg, const clang::SourceManager &sm, 
    SourceLocation begin, SourceLocation end)
{
    llvm::outs() << msg 
                 << getSourceLocationString(sm, begin, true)
                 << "-"
                 << getSourceLocationString(sm, end, false)
                 << "\n";
}

static ParsedAttrInfoRegistry::Add<AttrInfo> Y("cle", "cle annotator");
