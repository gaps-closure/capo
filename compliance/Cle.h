#pragma once

#include <vector>

#include "json.hpp"

using json = nlohmann::json;

using namespace std;

class GuardHint
{
public:
    string operation;
    vector<int> gapstag;

    GuardHint() {
    };
    
    ~GuardHint() {};

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
    GuardHint guardhint;

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

    GuardHint getGuardHint() const {
        return guardhint;
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
