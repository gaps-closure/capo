#pragma once

#include <vector>

#include "json.hpp"

using json = nlohmann::json;

using namespace std;

class Annotation
{
public:
    string label;
    string module;
    string instruction;

    Annotation(string module, string label, string instruction) {
        this->module = module;
        this->label = label;
        this->instruction = instruction;
    }
    
    Annotation() {
    }

    ~Annotation() {
    }

    string getInstruction() const {
        return instruction;
    }

    void setInstruction(string instruction) {
        this->instruction = instruction;
    }

    string getLabel() const {
        return label;
    }

    void setLabel(string label) {
        this->label = label;
    }

    string getModule() const {
        return module;
    }

    void setModule(string module) {
        this->module = module;
    }
};
