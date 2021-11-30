#include "Cle.h"

using namespace std;
using json = nlohmann::json;


void to_json(json& j, const GuardDirective& p) {
    string x = p.getOperation();

    std::vector<int> g = p.getGapstag();
    json j2 = g;

    j = json{
            {"operation", x},
            {"gapstag", j2}
    };
}


void to_json(json& j, const Cdf& p) {
    string r = p.getRemoteLevel();
    string d = p.getDirection();
    GuardDirective g = p.getGuardDirective();

    j = json{
            {"remotelevel", r },
            {"direction", d },
            {"guarddirective", g },
    };
}

void to_json(json& j, CleJson& p)
{
    std::vector<Cdf> x = p.getCdf();
    json j2 = x;

    j = json{
            {"level", p.getLevel()},
            {"cdf", j2}
    };
}

void to_json(json& j, Cle& p)
{
    CleJson cleJson = p.getCleJson();

    json j2;
    to_json(j2, cleJson);

    j = json{
        {"cle-label", p.getLabel()},
        {"cle-json", j2}
    };
}

void from_json(const json& j, GuardDirective& p)
{
    j.at("operation").get_to(p.operation);
    j.at("gapstag").get_to(p.gapstag);
}

void from_json(const json& j, Cdf& p)
{
    j.at("remotelevel").get_to(p.remotelevel);
    j.at("direction").get_to(p.direction);
    j.at("guarddirective").get_to(p.guarddirective);
}

void from_json(const json& j, CleJson& p)
{
    j.at("level").get_to(p.level);

    try {
        j.at("cdf").get_to(p.cdf);
    }
    catch (...) {
    }
}

void from_json(const json& j, Cle& p)
{
    j.at("cle-label").get_to(p.label);
    j.at("cle-json").get_to(p.cleJson);
}
