/*
 * Copyright (c) 2023 Peraton Labs
 * SPDX-License-Identifier: Apache-2.0
 * @author tchen
 */

#ifndef TOPOLOGY_H
#define TOPOLOGY_H

#include <string>
#include <vector>
#include <map>

#include "nlohmann/json.hpp"

#include "Annotation.h"
#include "Enclave.h"

using json = nlohmann::json;
using namespace std;

class Topology
{
protected:
    string sourcePath;
    vector<Enclave> enclaves;
    vector<string> levels;
    vector<Annotation> functions;
    vector<Annotation> globalScopedVars;

    // levels -> (name -> annotation)
    map<string, map<string, Annotation>> allAnnotations;

    // not in JSON
    string outputDir;
    string fileInProcess;
    string levelInProgress;

public:
    Topology() {
    }

    string getOutputFile() {
        return outputDir + "/" + levelInProgress + "/" + fileInProcess;
    }

    bool isNameInLevel(string &name, string &level);
    bool isInEnclave(string &name, string &level);

    void parse(string &topology);
    void parseAnnotations(nlohmann::basic_json<> values, vector<Annotation> &list);
    void parseStrings(nlohmann::basic_json<> values, vector<string> &list);
    void parseEnclaves(nlohmann::basic_json<> values, vector<Enclave> &list);

    string &getSourcePath() { 
        return this->sourcePath; 
    }

    vector<Enclave> &getEnclaves() { 
        return this->enclaves; 
    }
    
    vector<string> &getLevels() {
        return this->levels; 
    }

    vector<Annotation> &getFunctions() { 
        return this->functions; 
    }

    vector<Annotation> &getGlobalScopedVars() {
        return this->globalScopedVars; 
    }

    string &getOutputDir() {
        return this->outputDir;
    }

    void setOutputDir(string &outputDir) {
        this->outputDir = outputDir;
    }

    string &getFileInProcess() {
        return this->fileInProcess;
    }

    void setFileInProcess(string fileInProcess) {
        this->fileInProcess = fileInProcess;
    }

    void setLevelInProgress(string levelInProgress) {
        this->levelInProgress = levelInProgress;
    }

    string &getLevelInProgress() {
        return this->levelInProgress;
    }
};

#endif