#include <filesystem>
#include <iostream>
#include <fstream>

#include "Topology.h"

void Topology::parse(string &topology) 
{
    if (!filesystem::exists(topology)) {
        std::cout << "file does not exist: " << topology << endl;
        exit(1);
    }

    std::ifstream jStream(topology);
    json js;
    jStream >> js;

    for (auto &el : js.items()) {
        string key = el.key();
        auto val = el.value();

        if (!key.compare("source_path")) {
            sourcePath = val.get<string>();
        }
        else if (!key.compare("enclaves")) {
            parseEnclaves(val, enclaves);
        }
        else if (!key.compare("levels")) {
            parseStrings(val, levels);
        }
        else if (!key.compare("functions")) {
            parseAnnotations(val, functions);
        }
        else if (!key.compare("global_scoped_vars")) {
            parseAnnotations(val, globalScopedVars);
        }
        else {
            std::cout << "ERROR: unknown key: " << key << endl;
        }
    }
}

void Topology::parseAnnotations(nlohmann::basic_json<> values, vector<Annotation> &list)
{
    for (auto &el2 : values.items()) {
        Annotation annotation(el2.value());

        string &level = annotation.getLevel();
        string &name = annotation.getName();

        map<string, map<string, Annotation>>::iterator it = allAnnotations.find(level);
        if (it == allAnnotations.end()) {  
            map<string, Annotation> annoMap;
            annoMap[name] = annotation;

            allAnnotations[level] = annoMap;
        }
        else {
            map<string, Annotation> &annoMap = it->second;
            map<string, Annotation>::iterator it2 = annoMap.find(name);
            if (it2 == annoMap.end()) {
                annoMap[name] = annotation;
            }
            else {
                std::cout << "already exist: " << level << ":" << name << std::endl;
            }
        }

        list.push_back(annotation);
    } 
}

void Topology::parseEnclaves(nlohmann::basic_json<> values, vector<Enclave> &list)
{
    for (auto &el2 : values.items()) {
        Enclave enclave(el2.value());

        list.push_back(enclave);
    } 
}

void Topology::parseStrings(nlohmann::basic_json<> values, vector<string> &list)
{
    for (auto &el2 : values.items()) {
        list.push_back(el2.value());
    } 
}

bool Topology::isNameInLevel(string &name, string &level)
{
    map<string, map<string, Annotation>>::iterator it = allAnnotations.find(level);
    if (it == allAnnotations.end()) {  
        return false;
    }

    map<string, Annotation> &annoMap = it->second;
    map<string, Annotation>::iterator it2 = annoMap.find(name);
    if (it2 == annoMap.end())
        return false;
    else
        return true;
}

bool Topology::isInEnclave(string &name, string &level)
{
    for (Enclave enclave : enclaves) {
        if (enclave.getLevel().compare(level))
            continue;
        for (string assigned : enclave.getAssignedClasses()) {
            if (!assigned.compare(name)) {
                return true;
            }
        }
    }
    return false;
}
