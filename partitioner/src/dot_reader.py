import re
import collections

def token_with_escape(a, escape = '\\', separator = ',', quote='"'):
    result = []
    token = ''
    state = 0#0 is normal, 1 is escaped, 2 is quoted, 3 is quoted and escaped
    for c in a:
        if state == 0:
            if c == escape:
                state = 1
            elif c == separator:
                result.append(token)
                token = ''
            elif c == quote:
                state = 2
            else:
                token += c
        elif state == 1:
            token += c
            state = 0
        elif state == 2:
            if c == escape:
                state = 3
                token += c
            elif c == quote:
                state = 0
            else:
                token += c
        elif state == 3:
            token += c
            state = 2
    result.append(token)
    return result

class DotNode():
    def __init__(self, name, args=None):
        self.name = name
        self.properties = args or {'label' : "UNKNOWN1"}
        l_tmp = self.get_label()
        self.is_entry_p = "\<\<ENTRY\>\>" in l_tmp
        self.is_global_value_p = "GLOBAL_VALUE" in l_tmp
        
    def get_name(self):
        return self.name
    
    def get_label(self):
        return self.properties.get('label', "")
    
    def set(self, name, value):
        self.properties[name] = value
        
    def get(self, name):
        return self.properties.get(name)
    
    def is_entry(self):
        return self.is_entry_p
    
    def is_global_value(self):
        return self.is_global_value_p
    
    def __str__(self):
        attr = [x + '="' + str(self.properties[x]) + '"' for x in self.properties]
        return "%s [%s]"%(self.name, ",".join(attr))
    
    
class DotEdge():
    def __init__(self, src, dst, args=None):
        self.src = src
        self.dst = dst
        self.properties = args or {'label' : "UNKNOWN3"}
        
    def get_src(self):
        return self.src
    
    def get_dst(self):
        return self.dst
    
    def get_label(self):
        return self.properties.get('label')
    
    def set(self, name, value):
        self.properties[name] = value
        
    def get(self, name):
        return self.properties.get(name)
    
    def __str__(self):
        attr = [x + '="' + str(self.properties[x]) + '"' for x in self.properties]
        return "%s -> %s[%s]"%(self.src, self.dst, ",".join(attr))
    
class DotGraph():
    def __init__(self, nodes, edges):
        self.nodes = []
        self.nodes_by_name = {}
        self.entry_nodes = []
        self.edges = []
        self.edges_by_src = collections.defaultdict(list)
        self.edges_by_dst = collections.defaultdict(list)
        for n in nodes:
            self.add_node(n)
        for e in edges:
            self.add_edge(e)   
            
    def add_node(self, n):
        self.nodes.append(n)
        self.nodes_by_name[n.get_name()] = n
        if n.is_entry():
            self.entry_nodes.append(n)
            
    def add_edge(self, e):
        self.edges.append(e)
        self.edges_by_src[e.get_src()].append(e)
        self.edges_by_dst[e.get_dst()].append(e)
   
    def get_nodes(self):
        return self.nodes
    
    def get_edges(self):
        return self.edges
    
    def get_node(self, name):
        return self.nodes_by_name.get(name)
    
    def get_edges_by_src(self, src):
        return self.edges_by_src.get(src, [])
    
    def get_edges_by_dst(self, dst):
        return self.edges_by_dst.get(dst, [])
    
    def get_entry_nodes(self):
        return self.entry_nodes
    
    def __str__(self):
        return "DotGraph: %d nodes, %d edges"%(len(self.nodes), len(self.edges))
     
    def write(self, fname):
        with open(fname, "w") as f:
            f.write("digraph \"Program Dependency Graph for 'main' function\" {\n")
            f.write("  label=\"Program Dependency Graph for 'main' function\";\n")
            f.write("  graph [ splines=true ]\n")
            #nodes and edges
            for n in self.nodes:
                f.write("    ")
                f.write(str(n))
                f.write(";\n")
            for e in self.edges:
                f.write("    ")
                f.write(str(e))
                f.write(";\n")                
            f.write("}\n")
        
    @classmethod
    def read_from_file(cls, fname):
        nodes = []
        edges = []
        node_re = re.compile(r'(Node0x[0-9a-fA-F]{12}) \[(.+)\];')
        edge_re = re.compile(r'(Node0x[0-9a-fA-F]{12}) -> (Node0x[0-9a-fA-F]{12})(?:\[(.+)\])?;')
        num = 0
        with open(fname) as f:
            for line in f:
                num += 1
                line = line.strip()
                if line and len(line) > 0:
                    #node?
                    m = node_re.match(line)
                    if m:
                        name = m.group(1)
                        argsstr = token_with_escape(m.group(2))
                        argstu = [t.split("=", 1) for t in argsstr]
                        args = {t[0].strip() : t[1].strip() for t in argstu}
                        n = DotNode(name, args)
                        nodes.append(n)
                    else:
                        #maybe edge
                        m = edge_re.match(line)
                        if m and m.group(3):
                            src = m.group(1)
                            dst = m.group(2)
                            argsstr = token_with_escape(m.group(3))
                            argstu = [t.split("=") for t in argsstr]
                            args = {t[0].strip() : t[1].strip() for t in argstu}
                            n = DotEdge(src, dst, args)
                            edges.append(n)
        return DotGraph(nodes, edges)
        
        
        
class DotReader():
    def __init__(self):
        self.pdg = None
        self.global_annotations = []

    def read_dot(self, fname_pdg):
        self.pdg = DotGraph.read_from_file(fname_pdg)
        self.add_scope_edges()
        self.find_global_annotations()
        
    def add_scope_edges(self):
        n_set = [ x for x in self.pdg.get_nodes() if x.is_global_value()]
        f_set = self.pdg.get_entry_nodes()
        for n in n_set:
            m = re.match(r'.+GLOBAL_VALUE:@(\w+)\.(\w+)', n.get_label())
            if m and m.group(1) != 'llvm':
                scope_n = m.group(1)
                for f in f_set:
                    m2 = re.match(r'.+ENTRY\\>\\>.+name: \\"([^\"]+)\\",', f.get_label())
                    if m2 and scope_n == m2.group(1):
                        self.pdg.add_edge(DotEdge(f.get_name(), n.get_name(), {'label' :'{SCOPE}'}))
        
        
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
        #print("GLOBAL ANNOS:", self.global_annotations)

                        
    def get_pdg(self):
        return self.pdg
    
    def get_pdg_nodes(self):
        return self.pdg.get_nodes()

    def find_nodes_for_irstring(self, irstr_l):
        '''
        return list of llvm.var.annotation nodes that contain the particular irstr
        global annotations are different
        '''
        ret = []
        for irstr in irstr_l:
            re_str = ".+ @" + irstr + "[, ].+"
            for n in self.pdg.get_nodes():
                l = n.get_label()
                if l is not None and (not "llvm.global.annotations" in l) and re.match(re_str, l):
                    ret.append(n)
            #ret = [n for n in self.pdg.get_nodes() \
            #         if n.get_label() is not None and \
            #             (not "llvm.global.annotations" in n.get_label()) and \
            #             re.match(re_str, n.get_label())]
        
        return ret

    def find_global_vars_for_irstring(self, irstr_l):
        '''
        returns list of global variable declarations as nodes if the var is annotated with irstring
        '''
        ret = []
        for irstr in irstr_l:
            re_str = ".+ @([\.\w]+)[, ].+ @" + irstr + "[, ].+"
            for ga in self.global_annotations:
                m = re.match(re_str, ga)
                #print("MATCHING", ga, "to", irstr)
                if m:
                    #print("MATCHED", m.group(1))
                    re_str2 = "{GLOBAL_VALUE:@" + m.group(1) + " = .+"
                    for n in self.get_pdg_nodes():
                        if n.get_label():
                            #print("LABEL:", n.get_label())
                            m2 = re.match(re_str2, n.get_label())
                            if m2:
                                ret.append(n)
                                #print("APPENDING:", n)
        return ret
            
    def find_functions_for_irstring(self, irstr_l):
        '''
        returns list of function definitions if they are annotated with irstr
        '''
        ret = []
        for irstr in irstr_l:
            re_str = ".+ @([\.\w]+)[, ].+ @" + irstr + "[, ].+"
            for ga in self.global_annotations:
                m = re.match(re_str, ga)
                #print("MATCHINGF", ga)
                if m:
                    #print("MATCHEDF", m.group(1))
                    re_str2 = r".+ENTRY\\>\\> " + m.group(1) + " "
                    for n in [x for x in self.get_pdg_nodes() if x.get_label()]:
                        m2 = re.match(re_str2, n.get_label())
                        if m2:
                            ret.append(n)
                            #print("APPENDINGF:", n)
        return ret
        

    @classmethod
    def get_fixed_node_label(cls, n):
        l = n.get_label().strip()
        if l.startswith('"{'):
            return l[2:-2].strip()
        return l


        
if __name__ == "__main__":
    '''
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

    tstr = 'Node0x55cb45cfbef0 [shape=record,label="{\<\<ENTRY\>\> stop_database \<\<0x55cb441452d0\> = distinct !DISubprogram(name: \"stop_database\", scope: \<0x55cb4725ca80\>, file: \<0x55cb4725ca80\>, line: 17, type: \<0x55cb472e0c50\>, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: \<0x55cb4725e638\>, retainedNodes: \<0x55cb4725b160\>)\>}"];'
    m = re.match(r'Node0x[0-9a-fA-F]{12} \[(.+)\];', tstr)
    print(m)
    print(token_with_escape(m.group(1)))
    edge_re = r'(Node0x[0-9a-fA-F]{12}) (Node0x[0-9a-fA-F]{12})(?: \[(.+)\])?;'
    '''
    #aa = DotGraph.read_from_file("~/closure/top-level/apps/eridemo2020/secdesk/.solution/pdgragh.main.dot")
    #aa = DotGraph.read_from_file("/tmp/acpt/pdgragh.main.dot")
    bb = DotReader()
    bb.read_dot("/tmp/acpt/pdgragh.main.dot")
    print(bb.get_pdg())
    bb.get_pdg().write("/tmp/acpt/enclaves.dot")
    
    