import json
import sys

class PolicyResolver():
    def __init__(self):
        self.desc = {}

    def read_json(self, fname):
        '''
        reads the JSON produced by the cle preprocessor
        '''
        with open(fname) as f:
            fs = f.read()
            desc1 = json.loads(fs)
        
        self.desc = [x for x in desc1 if 'cle-json' in x and 'level' in x['cle-json']]

    def get_labels(self):
        '''
        returns list of labels defined in the program
        '''
        ret = set()
        for l in self.desc:
            ret.add(l['cle-label'])
        return list(ret)

    def get_enclaves(self):
        '''
        returns list of security enclaves defined in the program
        '''
        ret = set()
        for l in self.desc:
            ret.add(l['cle-json']['level'])
        return list(ret)

    def path_exists(self, oe, e):
        '''
        returns True if there is a possibility that data can flow 
        from enclave oe to e
        '''
        #XXX to be done taking default policy into account
        for l in self.desc:
            if l['cle-json']['level'] == oe and 'cdf' in l['cle-json']:
                for c in l['cle-json']['cdf']:
                    if c['remotelevel'] == '=='+e and c['direction'] == 'egress':
                        return True
        return False
        
    def get_common_enclaves(self):
        '''
        returns list of enclaves into which the data may flow,
        even if it needs to be guarded
        '''
        #it is a reachability graph problem
        #XXX to be implemeted properly later
        ret = []
        encs = self.get_enclaves()
        for e in encs:
            #can it be reached from all other enclaves?
            e_reachable = True
            for oe in encs:
                if oe != e:
                    e_reachable = e_reachable and self.path_exists(oe, e)
            if e_reachable:
                ret.append(e)
        return ret

    def get_label_enclave(self, ll):
        '''
        returns map {label : enclave} where label is one of the labels defined by the programmer
        and enclave is the enclave name for that label
        '''
        ret = {}
        for l in ll:
            for o in self.desc:
                if o['cle-label'] == l:
                    ret[l] = o['cle-json']['level']
        return ret

if __name__ == "__main__":
    p = PolicyResolver()
    p.read_json(sys.argv[1])
    print(p.get_labels())
    print(p.get_enclaves())
    print(p.get_common_enclaves())
