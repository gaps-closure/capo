#import networkx

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
        
    def propagate_enclave(self, node, enclave):
        '''
        Sequential passes, up the USE_DEF to color up to the definition, then down USE_DEF to color usage
        XXX: stops when first conflict encountered?
        '''
        ret = set()
        ret.update(self.propagate_enclave_oneway(node, enclave, dir='dst', label=['DEF_USE']))
        for n in [x for x in self.get_dot_node_list() if x.get('enclave') == enclave]:
            for dn in self.get_neighbors(n, dir = 'src', label=['DEF_USE', 'RAW']):
                #print("Down node:", dn.get_label())
                c = self.propagate_enclave_oneway(dn, enclave, dir='src', label=['DEF_USE', 'RAW'])
                ret.update(c)
        return ret
        
    def propagate_enclave_oneway(self, node, enclave, dir=None, label=None, stop_at_function=False):
        #print("Node start: %s " % node.get_label())
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
        for n in self.get_neighbors(node, dir=dir, label=label):
            c = self.propagate_enclave_oneway(n, enclave, dir=dir, label=label)
            ret.update(c)
        return ret

    def get_neighbors(self, node, dir=None, label=None):
        '''
        all nodes (objects, not names) connected to this node, if dir is None
        nodes having this node as source if dir == 'src'
        nodes having his node as destination if dir == 'dst'
        Only edges that have labels that contain at least one of the terms in 'label' argument are considered
        '''
        edges = self.get_edges(node, dir, label)
        ret = set()
        for e in edges:
            if e.get_source() == node.get_name(): ret.add(e.get_destination())
            else: ret.add(e.get_source())
        return [self.get_dot_node(x) for x in ret]

    def get_edges(self, node, dir=None, label=None):
        '''
        all edges connected to this node, if dir is None
        edges having this node as source if dir == 'src'
        edges having his node as destination if dir == 'dst'
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
                    if dir is None or dir == 'dst':
                        ret.add(e)
                if e.get_source() == node.get_name():
                    if dir is None or dir == 'src':
                        ret.add(e)
        #print("RET:", ret)
        return list(ret)

    def find_root_declaration(self, n):
        up_n = self.get_neighbors(n, dir='dst', label=['DEF_USE'])
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
