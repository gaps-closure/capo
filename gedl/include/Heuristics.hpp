#ifndef _HEURISTICS_H_
#define _HEURISTICS_H_
#include <fstream>
#include <iostream>
#include <map>
#include <string>

#include "ArgumentWrapper.hpp"
#include "ProgramDependencyGraph.hpp"
#include "json.hpp"
namespace pdg {

class Heuristics {
 public:
  static void populateStringFuncs();
  static void populateMemFuncs();
  static void populateprintfFuncs();
  static void populateMapFrom(std::map<std::string, std::set<unsigned>>& map,
                              json::JSON json);
  static void addSizeAttribute(std::string funcName, int argNum,
                               llvm::CallInst* callInst, ArgumentWrapper* argW,
                               ProgramDependencyGraph* PDG);
  static void addStringAttribute(std::string funcName, int argNum,
                                 ArgumentWrapper* argW);
  static void checkPrintf(llvm::CallInst* callInst, int argNum,
                          ArgumentWrapper* argW);
  static std::set<unsigned> parseFormatString(const std::string& format,
                                              unsigned startIdx);

 private:
  static std::map<std::string, std::set<unsigned>> inStr;
  static std::map<std::string, std::set<unsigned>> outStr;
  static std::map<std::string, std::set<unsigned>> inMem;
  static std::map<std::string, std::set<unsigned>> outMem;
  static std::map<std::string, unsigned> printfFuncs;
  /*std::string inString = "{\n \
\"in\": [\n \
{\"name\": \"strlen\", \"idx\": [0]},\n \
{\"name\": \"strnlen\", \"idx\": [0]},\n \
{\"name\": \"strcmp\", \"idx\": [0,1]},\n \
{\"name\": \"strncmp\", \"idx\": [0,1]},\n \
{\"name\": \"strcoll\", \"idx\": [0]},\n \
{\"name\": \"strtok\", \"idx\": [0,1]},\n \
{\"name\": \"strchr\", \"idx\": [0]},\n \
{\"name\": \"strrchr\", \"idx\": [0]},\n \
{\"name\": \"strpbrk\", \"idx\": [0,1]},\n \
{\"name\": \"strspn\", \"idx\": [0,1]},\n \
{\"name\": \"strcspn\", \"idx\": [0,1]},\n \
{\"name\": \"strstr\", \"idx\": [0,1]},\n \
{\"name\": \"strdup\", \"idx\": [0]},\n \
{\"name\": \"strndup\", \"idx\": [0]},\n \
{\"name\": \"strcasecmp\", \"idx\": [0,1]},\n \
{\"name\": \"\01_open\", \"idx\": [0]},\n \
{\"name\": \"\01_fopen\", \"idx\": [0]},\n \
{\"name\": \"__vsnprintf_chk\", \"idx\": [4]},\n \
{\"name\": \"__strcat_chk\", \"idx\": [1] },\n \
{\"name\": \"__strncat_chk\", \"idx\": [1] },\n \
{\"name\": \"__strcpy_chk\", \"idx\": [1] },\n \
{\"name\": \"__strncpy_chk\", \"idx\": [1] }\n \
],\n \
\"out\": [\n \
{\"name\": \"__vsnprintf_chk\", \"idx\": [0]},\n \
{\"name\": \"__snprintf_chk\", \"idx\": [0]},\n \
{\"name\":\"__strcat_chk\", \"idx\": [0]},\n \
{\"name\":\"__strncat_chk\", \"idx\": [0]},\n \
{\"name\":\"__strcpy_chk\", \"idx\": [0]},\n \
{\"name\":\"__strncpy_chk\", \"idx\": [0]}\n \
]\n \
}";*/
};

}  // namespace pdg

#endif