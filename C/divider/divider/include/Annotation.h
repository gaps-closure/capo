#ifndef ANNOTATION_H
#define ANNOTATION_H

#include <string>
#include <vector>

#include "nlohmann/json.hpp"

using json = nlohmann::json;
using namespace std;

class Annotation
{
protected:
    string name;
    string level;
    string enclave;
    int line;

public:
Annotation() {}
    Annotation(nlohmann::basic_json<> value);

    bool matched(string &name, string &level) {
        return !this->name.compare(name) && !this->level.compare(level);
    }

    string &getName() {
        return this->name; 
    }

    string &getLevel() {
        return this->level; 
    }
    
    string &getEnclave() { 
        return this->enclave; 
    }

    int getLine() {
        return this->line; 
    }
};

#endif // ANNOTATION_H