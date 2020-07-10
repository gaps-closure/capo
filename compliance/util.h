void trim(std::string &s);
void print_map(const char *name, unordered_map<string, Annotation> &map);
string toString(vector<int> v);
void print_map_obj(const char *name, unordered_map<string, Cle> &map);
void setResult(Entry &entry, bool pass, string &reason);
void print_functions(Expected<std::unique_ptr<Module> > &Mod);
