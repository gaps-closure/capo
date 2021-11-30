#pragma once

#include <vector>

using namespace std;

extern int verbose;

class Entry
{
  private:
    bool pass;    // true
    string reason;

    string module;
    string function;
    string instruction;
    string variable;
    string enclave;

  public:
    Entry() {
    };
    
    ~Entry() {
    }

    void print() {
        cout << (pass ? "Pass: " : "Fail: ")
             << variable
             << " " << reason
             << " " << enclave << endl;
        if (verbose) {
            cout << "\t" << module << endl
                 << "\t" << instruction << endl;
        }
    }

    string getEnclave() const {
        return enclave;
    }

    void setEnclave(string enclave) {
        this->enclave = enclave;
    }

    string getFunction() const {
        return function;
    }

    void setFunction(string function) {
        this->function = function;
    }

    string getInstruction() const {
        return instruction;
    }

    void setInstruction(string instruction) {
        this->instruction = instruction;
    }

    string getModule() const {
        return module;
    }

    void setModule(string module) {
        this->module = module;
    }

    string getVariable() const {
        return variable;
    }

    void setVariable(string variable) {
        this->variable = variable;
    }

    bool isPass() const {
        return pass;
    }

    void setPass(bool verdict) {
        this->pass = verdict;
    }

    string getReason() const
    {
        return reason;
    }

    void setReason(string reason)
    {
        this->reason = reason;
    }
};

class Report
{
public:
    void print() const {
        for (Entry entry: entries)
            entry.print();
    }

    void addEntry(Entry &entry) {
        entries.push_back(entry);
    }

    vector<Entry> getEntries() const {
        return entries;
    }

    void setEntries(vector<Entry> entries) {
        this->entries = entries;
    }

private:
    vector<Entry> entries;
};
