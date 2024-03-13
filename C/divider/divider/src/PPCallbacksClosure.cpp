#include "clang/Basic/FileManager.h"
#include "clang/Lex/MacroArgs.h"
#include "llvm/Support/raw_ostream.h"

#include "PPCallbacksClosure.h"
#include "Matcher.h"

namespace clang {
namespace pp_divider {

PPCallbacksClosure::PPCallbacksClosure(const FilterType &filters, Preprocessor &preprocessor)
    : filters(filters), preprocessor(preprocessor) 
{
}

PPCallbacksClosure::~PPCallbacksClosure()
{
}

// invoked when start reading any pragma directive.
void PPCallbacksClosure::PragmaDirective(SourceLocation loc, PragmaIntroducerKind introducer)
{
    SourceManager &sm = preprocessor.getSourceManager();
    unsigned line = sm.getExpansionLineNumber(loc);
    SourceLocation line_after = sm.translateLineCol(sm.getMainFileID(), line + 1, 1);
    SourceRange range(loc, line_after);
    CharSourceRange csr(range, false);

    std::string pragma = getSourceString(csr).str();
    if (pragma.rfind("#pragma cle begin ", 0) == 0) {
        Matcher::addCleRangeOpen(range, pragma);
    }
    else if (pragma.rfind("#pragma cle end ", 0) == 0) {
        Matcher::addCleRangeClose(range, pragma);
    }
}

// Get the raw source string of the range.
llvm::StringRef PPCallbacksClosure::getSourceString(CharSourceRange range) 
{
    const char *begin = preprocessor.getSourceManager().getCharacterData(range.getBegin());
    const char *end = preprocessor.getSourceManager().getCharacterData(range.getEnd());

    return llvm::StringRef(begin, end - begin);
}

} // namespace pp_divider
} // namespace clang
