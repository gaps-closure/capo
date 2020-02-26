import pydot
import networkx


class DotReader():
    def __init__(self):
        self.pdg = None
        self.cdg = None
        self.ddg = None

    def read_dot(self, fname_pdg, fname_cdg, fname_ddg):
        dd = pydot.graph_from_dot_file(fname_pdg)
        if len(dd) != 1:
            print("Expected exactly one PDG graph in file: " + fname_pdg)
            exit()
        self.pdg = dd[0]
        
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
        
    def get_pdg(self):
        return self.pdg
    
    def get_pdg_nodes(self):
        return self.pdg.get_nodes()

    def find_nodes_for_irstring(self, irstr):
        return [n for n in self.pdg.get_nodes() if n.get_label() is not None and irstr in n.get_label()]
            
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
    for n1 in nlist:
        for n2 in nlist:
            if n1 == n2:
                print("SAME:", [n1, n2])
            if n1.get_name() == n2.get_name():
                print(n1.get_name(), n2.get_name())
                print(n1.__repr__(), n2.__repr__())
                print(n1, n2)
    
