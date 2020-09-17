import re

class GraphHelper():
    
    class ConflictPair:
        def __init__(self, src, dst, edge):
            '''
            src and dst are nodes that conflict.
            '''
            self.src = src
            self.dst = dst
            self.edge = edge

        def get_src(self):
            return self.src
        
        def get_dst(self):
            return self.dst
        
        def get_edge(self):
            return self.edge
        
        def __str__(self):
            return "Conflict between nodes: " + str(self.src) + " and " + str(self.dst) + " via " + str(self.edge)
        
        def has_same_nodes(self, other):
            if other is None: return False
            if type(other) is type(self):
                return (self.get_src() == other.get_src() and self.get_dst() == other.get_dst()) or \
                     (self.get_dst() == other.get_src() and self.get_src() == other.get_dst())
            return False
        
        def is_in_set(self, cpset):
            if cpset is None: return False
            for c in cpset: 
                if self.has_same_nodes(c): return True
            return False      
              
        def is_data_dep(self):
            l = self.edge.get_label()
            if l:
                return 'D_general' in l or 'DEF_USE' in l or 'RAW' in l or 'D_ALIAS' in l or 'PARAMETER' in l
            else:
                return False
        @staticmethod
        def set_merge(to_set, from_set):
            tm = [x for x in from_set if not x.is_in_set(to_set)]
            to_set.update(tm)
     
    def __init__(self, dot_graph):
        self.dot = dot_graph

    def get_dot_node_list(self):
        return self.dot.get_nodes()

    def get_dot_node(self, name):
        return self.dot.get_node(name)

    def balanced_coloring(self, encs, enc):
        '''
        encs is a list of enclaves, enc is the one to which data can flow
        '''
        ret = set()
        
        remaining_enc = list(encs)
        remaining_enc.remove(enc)
        
        #then down to color usage
        for ee in [enc, *remaining_enc]:
            for n in [x for x in self.get_dot_node_list() if x.get('enclave') and x.get('enclave') == ee]:
                for dn in self.get_neighbors(n, direction = 'src', label=['DEF_USE', 'RAW', 'PARAMETER', 'CONTROL', 'GLOBAL_DEP', 'D_general']):
                    #print("Down node:", dn.get_label())
                    c = self.propagate_enclave_oneway(dn, n.get('enclave'), direction='src', label=['DEF_USE', 'RAW', 'PARAMETER', 'CONTROL', 'GLOBAL_DEP', 'D_general'], from_node=n)
                    GraphHelper.ConflictPair.set_merge(ret, c)
        #then up again to color structures
        
        for ee in [enc, *remaining_enc]:
            for n in [x for x in self.get_dot_node_list() if x.get('enclave') and x.get('enclave') == ee]:
                for dn in self.get_neighbors(n, direction = 'dst', label=['DEF_USE', 'RAW', 'CONTROL']):
                    #print("Down node:", dn.get_label())
                    c = self.propagate_enclave_oneway(dn, n.get('enclave'), direction='dst', label=['DEF_USE', 'RAW', 'CONTROL'], from_node=n)
                    GraphHelper.ConflictPair.set_merge(ret, c)
        
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
                c = self.propagate_enclave_oneway(dn, enclave, direction='src', label=['DEF_USE', 'RAW'], from_node=n)
                GraphHelper.ConflictPair.set_merge(ret, c)
        return ret
        
    def propagate_enclave_oneway(self, node, enclave, direction=None, label=None, stop_at_function=False, from_node=None):
        #print("Node start: %s " % node.get_label())
        #treat global annotation node as non-existing for coloring purposes
        if 'llvm.global.annotations' in node.get_label(): return []
        #treat local annotation node as non-existing for coloring purposes
        if 'llvm.var.annotation' in node.get_label(): return []
        existing_enc = node.get('enclave')
        if existing_enc is not None:
            #print("ee", existing_enc)
            if existing_enc != enclave:
                #print("Node: %s has conflict" % str(node))
                if direction == 'src':
                    n1 = from_node
                    n2 = node
                else:
                    n1 = node
                    n2 = from_node
                edgs = [e for e in self.dot.get_edges_by_src(n1.get_name()) if e.get_dst() == n2.get_name()]
                #print("eee1", edgs, set(edgs))
                if len(edgs) < 1:
                    print("ERROR in edge analysis: ")
                return [GraphHelper.ConflictPair(n1, n2, edgs[0])]
            return []
        node.set('enclave', enclave)
        node.set('fillcolor', enclave)
        node.set('style', 'filled')
        if stop_at_function and node.is_entry(): return set()
        ret = set()
        for n in self.get_neighbors(node, direction=direction, label=label):
            c = self.propagate_enclave_oneway(n, enclave, direction=direction, label=label, from_node=node)
            GraphHelper.ConflictPair.set_merge(ret, c)
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
            if e.get_src() == node.get_name(): ret.add(e.get_dst())
            else: ret.add(e.get_src())
        return [self.get_dot_node(x) for x in ret]

    def get_edges(self, node, direction=None, label=None):
        '''
        all edges connected to this node, if direction is None
        edges having this node as source if direction == 'src'
        edges having this node as destination if direction == 'dst'
        Only edges that have labels that contain at least one of the terms in 'label' argument are considered
        '''
        ret = set()
        if direction:
            if direction == 'src':
                elist = self.dot.get_edges_by_src(node.get_name())
            else:
                elist = self.dot.get_edges_by_dst(node.get_name())
        else:
            elist = self.dot.get_edges_by_src(node.get_name())
            elist.extend(self.dot.get_edges_by_dst(node.get_name()))
        for e in elist:
            el = e.get_label()
            in_label = False
            if label is None:
                in_label = True
            else:
                for l in label:
                    in_label = in_label or (el is not None and l in el)
                    #print("l, el, in_label:", l, el, in_label)
            if in_label:
                ret.add(e)
        #print("RET:", ret)
        return list(ret)

    def find_root_declaration(self, n):
        up_n = self.get_neighbors(n, direction='dst', label=['DEF_USE'])
        if len(up_n) == 0: return n
        if len(up_n) == 1: return self.find_root_declaration(up_n[0])
        print("More than one definition?")
        return None #this should not happen
    
    def find_dbg_declare(self, n):
        down_n = self.get_neighbors(n, direction='src', label=['DEF_USE'])
        for dn in down_n:
            #print("DOWN_N", str(dn))
            if 'llvm.dbg.declare' in dn.get_label():
                #print("DOWN_N RETURNING:", str(dn))
                return dn
        for dn in down_n:
            #print("DOWN_N Trying:", str(dn))
            ret = self.find_dbg_declare(dn)
            #print("DOWN_N Ret is:", str(ret))
            if ret is not None:
                #print("DOWN_N Returning ret:", str(ret))
                return ret
            #print("DOWN_N Returning None")
        return None
    
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
