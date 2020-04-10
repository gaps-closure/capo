import pydot
import networkx
import re

class DotReader():
    def __init__(self):
        self.pdg = None
        self.cdg = None
        self.ddg = None
        self.global_annotations = []

    def read_dot(self, fname_pdg, fname_cdg, fname_ddg):
        dd = pydot.graph_from_dot_file(fname_pdg)
        if len(dd) != 1:
            print("Expected exactly one PDG graph in file: " + fname_pdg)
            exit()
        self.pdg = dd[0]
        
        '''
        dd = pydot.graph_from_dot_file(fname_cdg)
        if len(dd) != 1:
            print("Expected exactly one CDG graph in file: " + fname_cdg)
            exit()
        self.cdg = dd[0]

        dd = pydot.graph_from_dot_file(fname_ddg)
        if len(dd) != 1:
            print("Expected exactly one DDG graph in file: " + fname_ddg)
            exit()
        self.ddg = dd[0]
        '''
        #self.find_global_annotations()
        
        
    def find_global_annotations(self):
        for n in self.get_pdg_nodes():
            if n.get_label() and "llvm.global.annotations" in n.get_label():
                tmp = n.get_label().split("{")
                if len(tmp) < 5:
                    print("Global annotation does not have at least one element: " + n.get_label())
                elif len(tmp) % 2 == 0:
                    print("Global annotation does not have expected structure: " + n.get_label())
                else:
                    for i in range(4, len(tmp), 2):
                        self.global_annotations.append(tmp[i])

                        
    def get_pdg(self):
        return self.pdg
    
    def get_pdg_nodes(self):
        return self.pdg.get_nodes()

    def find_nodes_for_irstring(self, irstr):
        '''
        return list of llvm.var.annotation nodes that contain the particular irstr
        global annotations are different
        '''
        re_str = ".+ @" + irstr + "[, ].+"
        ret = []
        for n in self.pdg.get_nodes():
            l = n.get_label()
            if l is not None and (not "llvm.global.annotations" in n.get_label()) and re.match(re_str, n.get_label()):
                ret.append(n)
        #ret = [n for n in self.pdg.get_nodes() \
        #         if n.get_label() is not None and \
        #             (not "llvm.global.annotations" in n.get_label()) and \
        #             re.match(re_str, n.get_label())]
        
        return ret

    def find_global_vars_for_irstring(self, irstr):
        '''
        returns list of global variable declarations as nodes if the var is annotated with irstring
        '''
        ret = []
        re_str = ".+ @(\w+)[, ].+ @" + irstr + "[, ].+"
        for ga in self.global_annotations:
            m = re.match(re_str, ga)
            if m:
                re_str2 = "\"{GLOBAL_VALUE:@" + m.group(1) + " = .+"
                for n in [x for x in self.get_pdg_nodes() if x.get_label()]:
                    m2 = re.match(re_str2, n.get_label())
                    if m2:
                       ret.append(n)
        return ret
             
    def get_fixed_node_label(self, n):
        l = n.get_label().strip()
        if l.startswith('"{'):
            return l[3:-3].strip()
        return l
        
if __name__ == "__main__":
    d = DotReader()
    d.read_dot("pdgragh.main.dot", "cdgragh.main.dot", "ddgragh.main.dot")
    print(len(d.get_pdg().get_node("Node0x55ec8ce8d2f0")))
    nlist = d.get_pdg().get_node_list();
    nlist2 = d.get_pdg().get_node_list();
    for n in nlist: n.set('asd', '1')
    for n1 in nlist:
        for n2 in nlist2:
            if n1 == n2:
                print("SAME:", [n1, n2])
            if n1.get_name() == n2.get_name():
                print(n1.get_name(), n2.get_name())
                print(n1.get('asd'), n2.get('asd'))
                #print(n1.__repr__(), n2.__repr__())
                #print(n1, n2)
    
