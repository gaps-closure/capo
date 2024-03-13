#ifndef PP_CALLBACKS_CLOSURE_H
#define PP_CALLBACKS_CLOSURE_H

#include <vector>

#include "clang/Lex/PPCallbacks.h"
#include "clang/Lex/Preprocessor.h"
#include "llvm/Support/GlobPattern.h"

namespace clang {
namespace pp_divider {

using FilterType = std::vector<std::pair<llvm::GlobPattern, bool>>;

class PPCallbacksClosure : public PPCallbacks 
{
public:
    PPCallbacksClosure(const FilterType &filters, Preprocessor &preprocessor);
    ~PPCallbacksClosure() override;

    // callback
    void PragmaDirective(SourceLocation loc, PragmaIntroducerKind introducer) override;

    llvm::StringRef getSourceString(CharSourceRange range);

    // List of (Glob,Enabled) pairs used to filter callbacks.
    const FilterType &filters;

    Preprocessor &preprocessor;
};

} // namespace pp_divider
} // namespace clang

#endif // PP_CALLBACKS_H
