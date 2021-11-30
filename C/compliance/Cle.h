#pragma once

#include <vector>

#include "json.hpp"

using json = nlohmann::json;

using namespace std;

class GuardDirective
{
public:
    string operation;
    vector<int> gapstag;

    GuardDirective() {
    };
    
    ~GuardDirective() {};

    string getOperation() const {
        return operation;
    }
    
    vector<int> getGapstag() const {
        return gapstag;
    }
};

class Cdf
{
public:
    string remotelevel;
    string direction;
    GuardDirective guarddirective;

  public:
    Cdf() {
    };
    
    ~Cdf() {};

    string getRemoteLevel() const {
        return remotelevel;
    }
    
    string getDirection() const {
        return direction;
    }

    GuardDirective getGuardDirective() const {
        return guarddirective;
    }
};

class CleJson
{
public:
    string level;
    vector<Cdf> cdf;

  public:
    CleJson() {
    };
    
    ~CleJson() {};

    string getDirection() {
        return level + " -> " + cdf[0].getRemoteLevel();
    }

    string getLevel() {
        return level;
    }
    
    vector<Cdf> getCdf() {
        return cdf;
    }
};

class Cle
{
public:
    string label;
    CleJson cleJson;
    

  public:
    Cle() {
    };
    
    ~Cle() {};

    string getDirection() {
        return cleJson.getDirection();
    }

    string getLevel() {
        return cleJson.getLevel();
    }

    string &getLabel() {
        return label;
    }
    
    CleJson getCleJson() {
        return cleJson;
    }
};
