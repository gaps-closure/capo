#include <filesystem>
#include <iostream>
#include <fstream>

#include "Enclave.h"

Enclave::Enclave(nlohmann::basic_json<> value)
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
        else if (!key.compare("assignedClasses")) {
            for (auto &el2 : val.items()) {
                assignedClasses.push_back(el2.value());
            } 
        }
        else if (!key.compare("line")) {
            std::cout << "ERROR: Enclave unknown key: " << key << endl;
        }
    }
}
