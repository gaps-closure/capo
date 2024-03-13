#ifndef ATTR_H
#define ATTR_H

#include "llvm/IR/Attributes.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Attributes.h"

using namespace clang;

struct AttrInfo : public ParsedAttrInfo 
{
    AttrInfo() {
        NumArgs = 1;
        static constexpr Spelling S[] = {{ParsedAttr::AS_GNU, "cle_annotate"},
                                        {ParsedAttr::AS_C2x, "cle_annotate"},
                                        {ParsedAttr::AS_CXX11, "cle_annotate"},
                                        {ParsedAttr::AS_CXX11, "cle::annotate"}};
        Spellings = S;
    }

    AttrHandling handleDeclAttribute(Sema &sema, Decl *decl, const ParsedAttr &attr) const override {
        llvm::StringRef name;
        if(auto lit = dyn_cast<StringLiteral>(attr.getArgAsExpr(0))) {
            name = lit->getBytes();
        } else {
            unsigned id = sema.getDiagnostics().getCustomDiagID(
            DiagnosticsEngine::Error, "first argument to the 'cle_annotate'"
                                      "attribute must be a string literal");
            sema.Diag(attr.getLoc(), id);
            return AttributeNotApplied;
        }
        decl->addAttr(clang::AnnotateAttr::Create(sema.Context, name, AttributeCommonInfo(decl->getSourceRange())));
        return AttributeApplied;
    }
};

#endif