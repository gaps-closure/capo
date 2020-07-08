#pragma once

#include <vector>

#include "json.hpp"

using json = nlohmann::json;

using namespace std;

class GuardHint
{
  private:
    string operation;
    vector<int> gapstag;

  public:
    GuardHint() {
    };
    
    ~GuardHint() {};

    string getOperation() {
        return operation;
    }
    
    vector<int> getGapstag() {
        return gapstag;
    }


    json to_json(json &j) {
        j["operation"] = operation;
//        j["gapstag"] = guardhint.to_json(j);

        return j;
    }

    static GuardHint from_json(const json &j, int i, int k) {
        GuardHint guard;
        
        guard.operation = j[i]["cle-json"]["cdf"][k]["guardhint"]["operation"];
        
        if (j[i]["cle-json"]["cdf"][k]["guardhint"].find("gapstag")
            != j[i]["cle-json"]["cdf"][k]["guardhint"].end())  {
            for (int m = 0; m < j[i]["cle-json"]["cdf"][k]["guardhint"]["gapstag"].size(); m++) {
                int t = j[i]["cle-json"]["cdf"][k]["guardhint"]["gapstag"][m].get<int>();
                guard.gapstag.push_back(t);
            }
        }
        return guard;
    }
};

class Cdf
{
  private:
    string remotelevel;
    string direction;
    GuardHint guardhint;

  public:
    Cdf() {
    };
    
    ~Cdf() {};

    string getRemoteLevel() {
        return remotelevel;
    }
    
    string getDirection() {
        return direction;
    }

    GuardHint getGuardHint() {
        return guardhint;
    }

    json to_json(json &j) {
        j["remotelevel"] = remotelevel;
        j["direction"] = direction;
        j["guardhint"] = guardhint.to_json(j);

        return j;
    }

    static vector<Cdf> from_json(const json &j, int i) {
        vector<Cdf> cdfs;

        if (j[i]["cle-json"].find("cdf") != j[i]["cle-json"].end())  {
            for (int k = 0; k < j[i]["cle-json"]["cdf"].size(); k++) {
                Cdf cdf;
            
                cdf.remotelevel = j[i]["cle-json"]["cdf"][k]["remotelevel"];
                cdf.direction = j[i]["cle-json"]["cdf"][k]["direction"];
                cdf.guardhint = GuardHint::from_json(j, i, k);

                cdfs.push_back(cdf);
            }
        }

        return cdfs;
    }
};

class CleJson
{
  private:
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

    json to_json(json &j) {
        j["level"] = level;
//        j["cdf"] = cdf.to_json(j);

        return j;
    }

    static CleJson from_json(const json &j, int i) {
        CleJson cleJson;
        
        cleJson.level = j[i]["cle-json"]["level"];
        cleJson.cdf = Cdf::from_json(j, i);

        return cleJson;
    }
};

class Cle
{
  private:
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

    string getLabel() {
        return label;
    }
    
    CleJson getCleJson() {
        return cleJson;
    }

    json to_json(json &j) {
        j["cle-label"] = label;
        j["cle-json"] = cleJson.to_json(j);

        return j;
    }

    static Cle from_json(const json &j, int i) {
        Cle cle;
        
        cle.label = j[i]["cle-label"];
        cle.cleJson = CleJson::from_json(j, i);

        return cle;
    }
};
