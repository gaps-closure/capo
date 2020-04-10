#import networkx
from sympy.functions.elementary.tests.test_trigonometric import nn

class GraphHelper():
    def __init__(self, dot_graph):
        self.dot = dot_graph
        self.dot_nodes = {n.get_name() : n for n in self.dot.get_nodes()}
        self.dot_edges = self.dot.get_edges()
        #self.nxg = networkx.drawing.nx_pydot.from_pydot(dot_graph)

    def get_dot_node_list(self):
        return self.dot_nodes.values()

    def get_dot_node(self, name):
        return self.dot_nodes.get(name)

    def balanced_coloring(self, encs, enc):
        '''
        encs is a list of enclaves, enc is the one to which data can flow
        '''
        ret = set()
        #first up 'DEF_USE' to color definition from annotations
        remaining_enc = list(encs)
        remaining_enc.remove(enc)
        #for ee in [enc, *remaining_enc]:
        for n in [x for x in self.get_dot_node_list() if x.get('annotation')]:
            ret.update(self.propagate_enclave_oneway(n, n.get('annotation'), direction='dst', label=['DEF_USE']))
        #then down to color usage
        for n in [x for x in self.get_dot_node_list() if x.get('enclave')]:
            for dn in self.get_neighbors(n, direction = 'src', label=['DEF_USE', 'RAW']):
                #print("Down node:", dn.get_label())
                c = self.propagate_enclave_oneway(dn, n.get('enclave'), direction='src', label=['DEF_USE', 'RAW'])
                ret.update(c)
        #then up again to color structures
        '''
        for n in [x for x in self.get_dot_node_list() if x.get('enclave')]:
            for dn in self.get_neighbors(n, direction = 'dst', label=['DEF_USE', 'RAW']):
                #print("Down node:", dn.get_label())
                c = self.propagate_enclave_oneway(dn, n.get('enclave'), direction='dst', label=['DEF_USE', 'RAW'])
                ret.update(c)
        '''
        return ret
    
    def propagate_enclave(self, node, enclave):
        '''
        Sequential passes, up the USE_DEF to color up to the definition, then down USE_DEF to color usage
        XXX: stops when first conflict encountered?
        '''
        ret = set()
        ret.update(self.propagate_enclave_oneway(node, enclave, direction='dst', label=['DEF_USE']))
        for n in [x for x in self.get_dot_node_list() if x.get('enclave') == enclave]:
            for dn in self.get_neighbors(n, direction = 'src', label=['DEF_USE', 'RAW']):
                #print("Down node:", dn.get_label())
                c = self.propagate_enclave_oneway(dn, enclave, direction='src', label=['DEF_USE', 'RAW'])
                ret.update(c)
        return ret
        
    def propagate_enclave_oneway(self, node, enclave, direction=None, label=None, stop_at_function=False):
        #print("Node start: %s " % node.get_label())
        #treat global annotation node as non-existing for coloring purposes
        if 'llvm.global.annotations' in node.get_label(): return []
        existing_enc = node.get('enclave')
        if existing_enc is not None:
            #print("ee", existing_enc)
            if existing_enc != enclave:
                #print("Node: %s has conflict" % str(node))
                return [node]
            return []
        node.set('enclave', enclave)
        node.set_fillcolor(enclave)
        node.set_style('filled')
        if stop_at_function and node.get_label().startswith('"{\<\<ENTRY\>\>'): return set()
        ret = set()
        for n in self.get_neighbors(node, direction=direction, label=label):
            c = self.propagate_enclave_oneway(n, enclave, direction=direction, label=label)
            ret.update(c)
        return ret
    
    def find_users(self, node):
        ret = set()
        for n in self.get_neighbors(node, 'src', ['DEF_USE']):
            if n not in ret:
                ret.add(n)
                nn = self.find_users(n)
                ret.update(nn)
        return ret
        

    def get_neighbors(self, node, direction=None, label=None):
        '''
        all nodes (objects, not names) connected to this node, if direction is None
        nodes having this node as source if direction == 'src'
        nodes having his node as destination if direction == 'dst'
        Only edges that have labels that contain at least one of the terms in 'label' argument are considered
        '''
        edges = self.get_edges(node, direction, label)
        ret = set()
        for e in edges:
            if e.get_source() == node.get_name(): ret.add(e.get_destination())
            else: ret.add(e.get_source())
        return [self.get_dot_node(x) for x in ret]

    def get_edges(self, node, direction=None, label=None):
        '''
        all edges connected to this node, if direction is None
        edges having this node as source if direction == 'src'
        edges having this node as destination if direction == 'dst'
        Only edges that have labels that contain at least one of the terms in 'label' argument are considered
        '''
        ret = set()
        for e in self.dot_edges:
            el = e.get_label()
            in_label = False
            if label is None:
                in_label = True
            else:
                for l in label:
                    in_label = in_label or (el is not None and l in el)
                    #print("l, el, in_label:", l, el, in_label)
            if in_label:
                if e.get_destination() == node.get_name():
                    if direction is None or direction == 'dst':
                        ret.add(e)
                if e.get_source() == node.get_name():
                    if direction is None or direction == 'src':
                        ret.add(e)
        #print("RET:", ret)
        return list(ret)

    def find_root_declaration(self, n):
        up_n = self.get_neighbors(n, direction='dst', label=['DEF_USE'])
        if len(up_n) == 0: return n
        if len(up_n) == 1: return self.find_root_declaration(up_n[0])
        print("More than one definition?")
        return None #this should not happen
    
    def print_info(self):
        #for n in self.dot.get_nodes():
        #    print(n, self.get_edges(n)))
        pass

if __name__ == "__main__":
    import dot_reader
    dot = dot_reader.DotReader()
    dot.read_dot("pdgragh.main.dot", "cdgragh.main.dot", "ddgragh.main.dot")
    gops = GraphHelper(dot.get_pdg())
    gops.print_info()
