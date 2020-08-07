#include "Cle.h"

using namespace std;
using json = nlohmann::json;


void to_json(json& j, const GuardDirective& p);
void to_json(json& j, const Cdf& p);
void to_json(json& j, CleJson& p);
void to_json(json& j, Cle& p);
void from_json(const json& j, GuardDirective& p);
void from_json(const json& j, Cdf& p);
void from_json(const json& j, CleJson& p);
void from_json(const json& j, Cle& p);
