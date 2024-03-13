#include <iostream>
#include <filesystem>
#include <fstream>

#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "clang/Tooling/Refactoring.h"

#include "llvm/Support/WithColor.h"
#include "llvm/Support/ToolOutputFile.h"

#include "Matcher.h"
#include "PPFrontendAction.h"
#include "Topology.h"

using namespace llvm;
using namespace clang;
namespace fs = std::filesystem;

static llvm::cl::OptionCategory ClosureDividerCategory("closure-divider options");

static cl::opt<bool> MainTuOnly {
    "main-tu-only",
    cl::desc("Only run on the main translation unit "
             "(e.g. ignore included header files)"),
    cl::init(true), 
    cl::cat(ClosureDividerCategory)
};

static cl::opt<std::string> topologyJson {
    "topology",
    cl::desc("the topology JSON file"),
    cl::init(""), 
    cl::cat(ClosureDividerCategory)
};

static cl::opt<std::string> outputDir {
    "output-dir",
    cl::desc("divided output directory"),
    cl::init("/tmp"), 
    cl::cat(ClosureDividerCategory)
};

static cl::opt<std::string> OutputFileName(
    "output", cl::init("-"),
    cl::desc("Output trace to the given file name or '-' for stdout."),
    cl::cat(ClosureDividerCategory));

static Topology topology;

[[noreturn]] static void error(Twine Message) {
    WithColor::error() << Message << '\n';
    exit(1);
}

class ClosurePluginAction : public PluginASTAction 
{
public:
    bool ParseArgs(const CompilerInstance &CI,
                   const std::vector<std::string> &args) override {
        return true;
    }

    std::unique_ptr<ASTConsumer> CreateASTConsumer(CompilerInstance &CI,
                                                   StringRef file) override {
        rewriter.setSourceMgr(CI.getSourceManager(),
                                         CI.getLangOpts());
        // return std::make_unique<ClosureDividerASTConsumer>(
        //     CI, topology, MainTuOnly,
        //     RewriterForCodeRefactor, ClassNameOpt, OldNameOpt, NewNameOpt);

        return std::make_unique<MatcherASTConsumer>(
            CI, topology, MainTuOnly, rewriter);
    }

private:
    Rewriter rewriter;
};

bool isInterested(fs::path path)
{
    string extension = path.extension();
    std::transform(extension.begin(), extension.end(), extension.begin(), [](unsigned char c){
            return std::tolower(c);
    });

    return !extension.compare(".cpp") ||
           !extension.compare(".c")   ||
           !extension.compare(".h")   ||
           !extension.compare(".hpp");
}

string createTargetDir(string &sourcePath, string &out_dir, string &level, fs::path &path)
{
    string fullpath = path.generic_string();
    string suffix = fullpath.substr(sourcePath.length() + 1);

    string dir = out_dir + "/" + level + "/";
    const size_t last_slash_idx = suffix.rfind('/');
    if (std::string::npos != last_slash_idx) {
        dir = dir + suffix.substr(0, last_slash_idx);
    }

    if (!dir.empty())
        fs::create_directories(dir);

    return suffix;
}

void divide(clang::tooling::CompilationDatabase &database, string topologyJson)
{
    topology.parse(topologyJson);
    topology.setOutputDir(outputDir);

    // for (auto level : topology.getLevels()) {
    //     std::filesystem::remove_all(outputDir + "/" + level);
    // }
    
    string sourcePath = topology.getSourcePath();

    if (!filesystem::exists(sourcePath)) {
        std::cout << "file does not exist: " << sourcePath << endl;
        exit(1);
    }

    using namespace clang::pp_divider;
    FilterType filters;
    StringRef Pattern("PragmaDirective");  // = Pattern.trim();
    bool Enabled = !Pattern.consume_front("-");
    Expected<GlobPattern> Pat = GlobPattern::create(Pattern);
    if (Pat)
        filters.emplace_back(std::move(*Pat), Enabled);
    else
        error(toString(Pat.takeError()));

    std::error_code EC;
    llvm::ToolOutputFile Out(OutputFileName, EC, llvm::sys::fs::OF_TextWithCRLF);
    if (EC) 
        error(EC.message());

    for (string level : topology.getLevels()) {
        llvm::outs() << outputDir << "/" << level << "\n";
        topology.setLevelInProgress(level);

        for (auto& pit: fs::recursive_directory_iterator(sourcePath)) {
            fs::path path = pit.path();
            if (is_directory(pit))
                continue;

            // suffix is a path starting from the point after the output directory
            // it is used in Matcher::isInFile()
            string suffix = createTargetDir(sourcePath, outputDir, level, path);
            topology.setFileInProcess(suffix);

            std::cout << "\t " << path.generic_string() << std::endl;
            if (!isInterested(path)) {
                fs::copy_file(path, topology.getOutputFile(), fs::copy_options::overwrite_existing);
                continue;
            }
            vector<string> cxxfile = { path.generic_string() };

            // clang::tooling::ClangTool tool(database, cxxfile);
            // tool.run(clang::tooling::newFrontendActionFactory<ClosurePluginAction>().get());

            Matcher::clearCleRange();

            // run the preprocessor callback to get the #pragma begin/end pair
            clang::tooling::ClangTool Toolx(database, cxxfile);
            PPFrontendActionFactory Factory(filters, Out.os());
            Toolx.run(&Factory);
           
            clang::tooling::RefactoringTool Tool(database, cxxfile);
            Tool.runAndSave(clang::tooling::newFrontendActionFactory<ClosurePluginAction>().get());
        }
    }
}

int main(int argc, const char **argv) 
{
    // cl::ZeroOrMore and run it without positional arguments leads to crash
    // use the first positional argument as topology.json for now
    Expected<tooling::CommonOptionsParser> eOptParser =
        clang::tooling::CommonOptionsParser::create(argc, argv, ClosureDividerCategory, cl::ZeroOrMore);
    //    eOptParser->getSourcePathList());
    if (auto E = eOptParser.takeError()) {
        errs() << "Problem constructing CommonOptionsParser "
               << toString(std::move(E)) << '\n';
        return EXIT_FAILURE;
    }

    // The first positional arugment is assumed to the topology.json.
    // Ideally it should be specified with a command line option. 
    // However, running the plugin without positional arguments leads to crash.
    divide(eOptParser->getCompilations(), eOptParser->getSourcePathList()[0]);

    return 0;
}
