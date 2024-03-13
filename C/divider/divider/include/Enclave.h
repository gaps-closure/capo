#ifndef ENCLAVE_H
#define ENCLAVE_H

#include <string>
#include <vector>

#include "nlohmann/json.hpp"

using json = nlohmann::json;
using namespace std;

class Enclave
{
protected:
    string name;
    string level;
    vector<string> assignedClasses;

public:
    Enclave() {}
    Enclave(nlohmann::basic_json<> value);

    string &getName() {
        return this->name; 
    }

    string &getLevel() {
        return this->level; 
    }
    
    vector<string> &getAssignedClasses() { 
        return this->assignedClasses; 
    }
};

#endif // ENCLAVE_H