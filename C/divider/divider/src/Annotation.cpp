#include <filesystem>
#include <iostream>
#include <fstream>

#include "Annotation.h"

Annotation::Annotation(nlohmann::basic_json<> value)
{
    for (auto &el : value.items()) {
        string key = el.key();
        auto val = el.value();

        if (!key.compare("name")) {
            name = val.get<string>();
        }
        else if (!key.compare("level")) {
            level = val.get<string>(); 
        }
        else if (!key.compare("enclave")) {
            enclave = val.get<string>();
        }
        else if (!key.compare("line")) {
            line = val.get<int>();
        }
        else if (!key.compare("line")) {
            std::cout << "ERROR: Annotation unknown key: " << key << endl;
        }
    }
}
