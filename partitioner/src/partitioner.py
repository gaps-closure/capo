#import networkx
import argparse
import os
import re
import json

import policy_resolver
import ir_reader
import dot_reader
import graph_helper

topology = {}

class AnnotationInfo():
    class ALabel():
        def __init__(self, l, s, e):
            '''
            l - label from cle annotation, 
            s - string from IR file corresponding to l, 
            e - enclave of l from CLE JSON
            '''
            self.label = l
            self.ir_str = s
            self.enclave = e

        def get_irstring(self):
            return self.ir_str
        
        def get_enclave(self):
            return self.enclave
            
        def __str__(self):
            return ",".join([self.label, str(self.ir_str), self.enclave])
        def __repr__(self):
            return self.__str__()
            
    def __init__(self):
        self.by_lab = {}
        self.by_str = {}
        self.by_enc = {}
        
    def add_annotation_info(self, l, s, e):
        al = AnnotationInfo.ALabel(l, s, e)
        self.by_lab[l] = al
        for s1 in s:
            self.by_str[s1] = al
        if e in self.by_enc:
            self.by_enc[e].append(al)
        else:
            self.by_enc[e] = [al]
        
    def get_by_label(self, l):
        return self.by_lab.get(l)
    
    def get_by_enclave(self, e):
        return self.by_enc.get(e)

    def get_labels(self):
        return list(self.by_lab.keys())
    
    def get_enclaves(self):
        return list(self.by_enc.keys())
    
class ConflictInfo():
    UNKNOWN = 0
    FUNCTION_CALL = 1
    METHOD_INVOCATION = 2
    DEF_IN_FUNCTION = 3
    FUNCTION_PARAMETER = 4
    _ks = {UNKNOWN : "UNKN",
           FUNCTION_CALL : 'Function call',
           METHOD_INVOCATION : 'Method invocation',
           DEF_IN_FUNCTION : 'Definition in a function',
           FUNCTION_PARAMETER : 'Passing parameter to function'}
    
    def __init__(self, dinfo, dinfo_src=None, edge=None):
        self.kind = ConflictInfo.UNKNOWN
        self.name = "UNKN"
        self.edge = edge
        self.label = dot_reader.DotReader.get_fixed_node_label(dinfo.get_node())
        self.label = self.label.replace('\\\n', '')
        self.line = dinfo.get_line() if dinfo is not None else 0
        self.column = dinfo.get_column() if dinfo is not None else 0
        self.file = dinfo.get_file() if dinfo is not None else None
        #print("CI: dinfo(dst)", dinfo, "<<>>", dinfo.get_node())
        #print("CI: dinfo(src)", dinfo_src, "<<>>", dinfo_src and dinfo_src.get_node())
        m = re.match(r'.+call .+ @(\w+)\(', self.label)
        if m is not None:
            self.kind = ConflictInfo.FUNCTION_CALL
            self.name = m.group(1)
            return
        m = re.match(r'call .+ @(\w+)\(', self.label)#most likely C++ call, otherwise would be caught before
        if m is not None:
            self.kind = ConflictInfo.METHOD_INVOCATION
            self.name = ir_reader.demangle(m.group(1))
            return
        m = re.match(r'.+ENTRY\\>\\> (\w+) .+ line: (\d+)', self.label)
        if m is not None:
            self.kind = ConflictInfo.DEF_IN_FUNCTION
            self.name = m.group(1)
            self.line = m.group(2)
            return
        #print("SL:", self.label)
        #print("DINFO_SRC:",dinfo_src)
        m = re.match(r'(?:ACTUAL|FORMAL)_(?:IN|OUT): (\d+)', self.label)
        if m is not None:
            self.kind = ConflictInfo.FUNCTION_PARAMETER
            #pnam = dinfo_src.get_name() if dinfo_src else "UNKN"
            self.name = '"Parameter number %s"' %(m.group(1))
            self.line = dinfo_src.get_line()
            self.column = dinfo_src.get_column()
            #print("Got passing: ", self.name)
    
    def kind_str(self):
        return ConflictInfo._ks.get(self.kind)
    
    def get_kind(self):
        return self.kind
    
    def __str__(self):
        if self.line is None or self.line == 0:
            return "Spurious or duplicated conflict, omitted"
        dep = ""
        if self.edge:
            if "CONTROL" in self.edge.get_label():
                dep = " (control dep.)"
            else:
                dep = " (data dep.)"
        fil = ""
        if self.file:
            fil = ", " + self.file
        return "Conflict on line %s, column %s%s (%s, name: %s)%s" % (self.line, self.column, fil, self.kind_str(), self.name, dep)
    def __repr__(self):
        return self.__str__()
    
    @classmethod
    def get_conflict_info(cls, ir_reader, c_pair):
        node_d = c_pair.get_dst()
        dinfo_d = ir_reader.get_DbgInfo(node_d)
        node_d.set('dbginfo', dinfo_d)
        dinfo_s = None
        node_s = c_pair.get_src()
        if node_s is not None:
            dinfo_s = ir_reader.get_DbgInfo(node_s)
            node_s.set('dbginfo', dinfo_s)        
        return ConflictInfo(dinfo_d, dinfo_s, c_pair.get_edge())
        
class Partitioner():
    def __init__(self, pol_, irr_, dot_):
        self.pol = pol_
        self.irr = irr_
        self.dot = dot_
        self.gh = graph_helper.GraphHelper(self.dot.get_pdg())
        self.ann_info = AnnotationInfo()
        self.progname = "EXAMPLE"
        self.ext = ".c"

    def set_input_names(self, _progname, _ext):
        self.progname = _progname
        self.ext = _ext
        
    def extract_annotation_info(self):
        labs = self.pol.get_labels()
        print("Annotation labels: ", ",".join(labs))
        lab_str = self.irr.get_label_irstring(labs)
        for li_q in labs:
            if not li_q in lab_str.keys():
                print("Warning: label defined but never used: ", li_q)
        lab_enc = self.pol.get_label_enclave(labs)
        for l in lab_str:
            self.ann_info.add_annotation_info(l, lab_str[l], lab_enc[l])
            #print("EAI", l, lab_str[l], lab_enc[l])

    def annotate_nodes(self):
        '''
        to nodes in dot graph add attribute 'annotation' with value of the enclave
        '''
        unused_labels = set(self.ann_info.get_labels())
        unused_enclaves = set(self.ann_info.get_enclaves())
        for l in self.ann_info.get_labels():
            enc = self.ann_info.get_by_label(l).get_enclave()
            l_str = self.ann_info.get_by_label(l).get_irstring()
            
            #local vars
            di = self.dot.find_nodes_for_irstring(l_str)
            for n in di:
                unused_labels.discard(l)
                unused_enclaves.discard(enc)
                #print("LENC", l, enc)
                tmp_n = self.gh.find_root_declaration(n)
                dbg_dec_node = self.gh.find_dbg_declare(tmp_n)
                old_ann = n.get('annotation')
                tmp_n.set('annotation', enc)
                tmp_n.set('taint', l)
                tmp_name = self.irr.get_variable_name(tmp_n.get_label())
                if dbg_dec_node:
                    dinfo = self.irr.get_decl_DbgInfo(dbg_dec_node)
                else:
                    dinfo = self.irr.get_DbgInfo(n, var=tmp_name)
                tmp_n.set('dbginfo', dinfo)
                if old_ann:
                    print("Item has more than one annotations:", dinfo)
                    print("  ACTION: refactoring needed, make sure there is no incompatible annotations on this item.")
                    exit()
                #print("LOCAL DINFO:", n, "<<>>", tmp_n, "<<>>", dinfo)
                
            #global vars
            di = self.dot.find_global_vars_for_irstring(l_str)
            for n in di:
                unused_labels.discard(l)
                unused_enclaves.discard(enc)
                #print("LENC2", l, enc)
                old_ann = n.get('annotation')
                n.set('annotation', enc)
                dinfo = self.irr.get_DbgInfo(n)
                n.set('taint', l)
                n.set('dbginfo', dinfo)
                if old_ann:
                    print("Item has more than one annotations:", dinfo)
                    print("  ACTION: refactoring needed, make sure there is no incompatible annotations on this item.")
                    exit()
                #print("GLOBAL DINFO:", n, "<<>>", dinfo)
                #print(n.get('dbginfo'))
                
            #functions annotation
            di = self.dot.find_functions_for_irstring(l_str)
            for n in di:
                unused_labels.discard(l)
                unused_enclaves.discard(enc)
                #print("LENC3", l, enc)
                old_ann = n.get('annotation')
                n.set('annotation', enc)
                n.set('taint', l)
                dinfo = self.irr.get_DbgInfo(n)
                n.set('dbginfo', dinfo)
                if old_ann:
                    print("Item has more than one annotations:", dinfo)
                    print("  ACTION: refactoring needed, make sure there is no incompatible annotations on this item.")
                    exit()
                #print("FUNCTION DINFO:", n, "<<>>", dinfo)
                #print(n.get('dbginfo'))
                
        #now, follow up 'DEF_USE' to color definition from annotations
        ret = set()
        for n in [x for x in self.gh.get_dot_node_list() if x.get('annotation')]:
            c = self.gh.propagate_enclave_oneway(n, n.get('annotation'), direction='dst', label=['DEF_USE'])
            graph_helper.GraphHelper.ConflictPair.set_merge(ret, c)
        
        
        #see if there are any unused annotation elements
        if len(unused_labels) > 0:
            print("Warning: There are labels defined but not used to annotate program: ", ", ".join(list(unused_labels)))
        if len(unused_enclaves) > 0:
            print("Warning: There are enclaves defined but not used to annotate program: ", ", ".join(list(unused_enclaves)))
            
        #we do not expect to have conflicts here
        return ret
    
    def color_scope(self):
        '''
        color only the ENTRY nodes for functions in which annotated nodes are defined
        '''
        conflicts_def = set()
        for n in self.dot.get_pdg_nodes():
            col = n.get('annotation')
            if col:
                dinfo = n.get('dbginfo')
                labels = None
                if dinfo.get_kind() == dinfo.LOCAL:
                    if n.is_global_value():
                        labels = ['SCOPE']
                    else:
                        labels = ['CONTROL']
                if labels is not None:
                    for upnode in self.gh.get_neighbors(n, direction='dst', label=labels):
                        c = self.gh.propagate_enclave_oneway(upnode, col, direction='dst', label=labels, stop_at_function=True, from_node=n)
                        graph_helper.GraphHelper.ConflictPair.set_merge(conflicts_def, c)
        return conflicts_def
                
    def color_body(self):
        '''
        color instructions in colored functions
        '''
        ret = set()
        for n in self.dot.get_pdg().get_entry_nodes():
            col = n.get('enclave')
            if col:
                labels = ['CONTROL', 'SCOPE']
                #going down the relation
                for downnode in self.gh.get_neighbors(n, direction='src', label=labels):
                    c = self.gh.propagate_enclave_oneway(downnode, col, direction='src', label=labels, stop_at_function=False, from_node=n)
                    graph_helper.GraphHelper.ConflictPair.set_merge(ret, c)
            
        return ret
                
    def color_all(self):
        '''
        color everything reachable
        '''
        ret = set()
        for n in self.dot.get_pdg().get_nodes():
            col = n.get('enclave')
            if col:
                labels = ['CONTROL', 'SCOPE', 'DEF_USE', 'RAW', 'PARAMETER', 'GLOBAL_DEP', 'D_general', 'D_ALIAS']
                for downnode in self.gh.get_neighbors(n, direction=None, label=labels):
                    dn_col = downnode.get('enclave')
                    if dn_col is None:
                        #should not be possible for two colored nodes to be linked at this point
                        c = self.gh.propagate_enclave_oneway(downnode, col, direction=None, label=labels, stop_at_function=False, from_node=n)
                        graph_helper.GraphHelper.ConflictPair.set_merge(ret, c)
            
        return ret
                
    def partition_to(self, encs, enc):
        '''
        encs - all the enclaves
        enc - the enclave into which the data flows (through guards). If data can flow to all, a random one 
        '''
        all_conflict_pairs = set()
        conflicts_exist = False
        resolvable_only = True
        if len(encs) != 2:
            print("This version of partitioner can only handle exactly 2 enclaves")
            return

        self.extract_annotation_info()
        marking_conflicts = self.annotate_nodes()
        if len(marking_conflicts) > 0:
            print("Data item(s) have more than one annotation!")
            print("ACTION: refactoring needed, make sure no incompatible annotations exist:")
            for c in marking_conflicts:
                print("  " + ConflictInfo.get_conflict_info(self.irr, c))
            return 
        smcl = "Items with security markings:"
        print(smcl)
        data_items = []
        global_scoped_vars = []
        topology['global_scoped_vars'] = global_scoped_vars
        for n in self.dot.get_pdg_nodes():
            n_ann = n.get('annotation')
            if n_ann:
                data_items.append(n)
                dinfo = n.get('dbginfo')
                smcl = "  Enclave: %s, item: %s" %(n_ann, str(dinfo))
                json_var = {"name" : dinfo.get_name(), "level" : n_ann}
                if dinfo.get_kind() == dinfo.GLOBAL:
                    global_scoped_vars.append(json_var)
                print(smcl)
                
        #start coloring
        
        print("Definition conflicts (data from different enclaves defined in the same function):")
        conflicts_def = self.color_scope()
        if len(conflicts_def) == 0:
            print("  None")
        else:
            conflicts_exist = True
            resolvable_only = False
            self.gh.ConflictPair.set_merge(all_conflict_pairs, conflicts_def)
            for c_pair in conflicts_def:
                c = c_pair.get_dst()
                cinfo = ConflictInfo( self.irr.get_DbgInfo(c), self.irr.get_DbgInfo(c_pair.get_src()), c_pair.get_edge())
                print("  " + str(cinfo))


        print("Conflicts (pass 1 of 3):")
        conflicts_body = self.color_body()
        if len(conflicts_body) == 0:
            print("  None")
        for c_pair in conflicts_body:
            conflicts_exist = True
            if not c_pair.is_in_set(all_conflict_pairs):
                #print("C:", c_pair)
                c = c_pair.get_dst()
                s = c_pair.get_src()
                dbgis = self.irr.get_DbgInfo(s)
                dbgid = self.irr.get_DbgInfo(c)
                c.set('dbginfo', dbgid)
                s.set('dbginfo', dbgis)
                cinfo = ConflictInfo(dbgis, dbgid, c_pair.get_edge())
                print("  " + str(cinfo))
                if cinfo.get_kind() == ConflictInfo.FUNCTION_CALL:
                    resolv, msg = self.pol.resolve_function(c, s.get('enclave'))
                    if not resolv:
                        resolvable_only = False
                        print("  ACTION: " + msg)
                        
        self.gh.ConflictPair.set_merge(all_conflict_pairs, conflicts_body)
        
        #finds if data of different markings is used in the same statement
        
        print("Conflicts (pass 2 of 3):")
        conflicts = self.gh.balanced_coloring(encs, enc)
        if len(conflicts) == 0:
            print("  None")
        else:
            conflicts_exist = True
            for c_pair in conflicts:
                if not c_pair.is_in_set(all_conflict_pairs):
                    #print("C:", c_pair)
                    c = c_pair.get_dst()
                    dinfo = self.irr.get_DbgInfo(c)
                    #print("DINFO:", dinfo)
                    dinfo_src = self.irr.get_DbgInfo(c_pair.get_src())
                    cinfo = ConflictInfo(dinfo, dinfo_src, c_pair.get_edge())
                    print("  " + str(cinfo))
        self.gh.ConflictPair.set_merge(all_conflict_pairs, conflicts)

        #finds everything else
        print("Conflicts (pass 3 of 3):")
        conflicts_all = self.color_all()
        if len(conflicts_all) == 0:
            print("  None")
        else:
            conflicts_exist = True
            for c_pair in conflicts_all:
                if not c_pair.is_in_set(all_conflict_pairs):
                    #print("C:", c_pair)
                    c = c_pair.get_dst()
                    dinfo = self.irr.get_DbgInfo(c)
                    #print("DINFO:", dinfo)
                    dinfo_src = self.irr.get_DbgInfo(c_pair.get_src())
                    cinfo = ConflictInfo(dinfo, dinfo_src, c_pair.get_edge())
                    print("  " + str(cinfo))
        self.gh.ConflictPair.set_merge(all_conflict_pairs, conflicts_all)



        #add global variables to topology file
        global_scoped_vars = []
        topology['global_scoped_vars'] = global_scoped_vars
        for n in self.dot.get_pdg_nodes():
            if n.is_global_value():
                #print("GGLLOOBBAALL::", n)
                n_ann = n.get('enclave')
                dinfo = n.get('dbginfo')
                dinfo = self.irr.get_DbgInfo(n)
                if dinfo.get_kind() == dinfo.GLOBAL:
                    if n_ann:
                        json_var = {"name" : dinfo.get_name(), "level" : n_ann}
                        global_scoped_vars.append(json_var)
                    else:
                        print("Global variable is not marked at the end of analysis:", dinfo)
                        print("  ACTION: This may happen if security policies are incorrect or this item is unused")
                        print("  ACTION: Check the program structure, and the annotations and policies")
                        print("  ACTION: Item assigned by default to: %s; check correctness of this assignment"%enc)
                        json_var = {"name" : dinfo.get_name(), "level" : enc, "default" : "true"}
                        global_scoped_vars.append(json_var)

        #ADD FUNCTIONS TO TOPOLOGY FILE
        function_labels = []
        topology['functions'] = function_labels
        for n in self.dot.get_pdg().get_entry_nodes():
            fdinfo = self.irr.get_DbgInfo(n)
            n_ann = n.get('enclave')
            if n_ann:
                func_l = {"name" : fdinfo.get_name(), "level" : n_ann, "line" : fdinfo.get_line()}
                function_labels.append(func_l)
            else:
                print("A function is not marked at the end of analysis:", fdinfo)
                print("  ACTION: This may happen if the program or the security policies are incorrect or this item is unused")
                print("  ACTION: Check annotations and policies in the program.")
                print("  ACTION: Check for unused functions. Check for functions called with wrong number of parameters.")
                print("  ACTION: Item assigned by default to: %s; check correctness of this assignment"%enc)
                func_l = {"name" : fdinfo.get_name(), "level" : enc, "line" : fdinfo.get_line(), "default" : "true"}
                function_labels.append(func_l)
                #print("DEBUG:", str(n))
        
        #write enclaves.dot file, make sure debug info is a string        
        #for n in self.dot.get_pdg_nodes():
        #    n.set('dbginfo', "\"" + str(n.get('dbginfo')) + "\"")
        self.dot.get_pdg().write('enclaves.dot')
                
        if conflicts_exist:
            print()
            if resolvable_only:
                print("There exist conflict, resolvable with RPC:")
                print("    ACTION: Please run divider tool to perform the resolution using generated 'topology.json' file")
            else:
                print("There exist conflict, and they may not be resolvable without refactoring:")
                print("    ACTION: Please refactor code as noted in earlier actions and run this tool again")
                

    def get_partition_information(self):
        enc = self.pol.get_enclaves()
        topology['levels'] = enc
        if len(enc) == 0:
            print("This program has no security enclaves defined! Use CLE to annotate the source code.")
        elif len(enc) == 1:
            print("This program has one security enclave defined.")
            print("It can be run in enclave '" + enc[0] + "', and can be run without modifications.")
        elif len(enc) > 2:
            print("This program has %d security enclaves defined." % (len(enc)))
            print("Currently maximum of 2 is permitted.")
        else:
            print("Two security enclaves defined: %s" % " and ".join(enc))
            enc_c = self.pol.get_common_enclaves()
            if len(enc_c) == 0:
                print("No data transfer between the two enclaves is permitted.")
                print("This program cannot be partitioned.")
                print("Please add the data flow rules for one of the labels.")
            elif len(enc_c) == 1:
                print("Data can flow only to %s (through guards)" % (enc_c[0]))
                self.partition_to(enc, enc_c[0])
            else:
                print("Data can flow to enclaves: %s (through guards)" % " or ".join(enc_c))
                self.partition_to(enc, enc_c[0])
            

def main(fullprogname):
    pol = policy_resolver.PolicyResolver()
    irr = ir_reader.IRReader()
    dot = dot_reader.DotReader()

    progname, ext = os.path.splitext(fullprogname)

    source_file_name = progname + ".mod" + ext
    pre = progname + ".mod"
    try:
        ret = pol.read_json(progname + ext + ".clemap.json")
        if ret:
            print("ERROR reading policy file: ")
            print(ret)
            print("  ACTION: Correct these problems before running this program again")
            return
        irr.read_ir(pre + ".ll")
        dot.read_dot("pdgragh.main.dot")
        print("Source file to be modified: %s" % source_file_name)
        topology['source_path'] = "./refactored" #source_file_name #os.path.dirname(source_file_name)
        p = Partitioner(pol, irr, dot)
        p.set_input_names(progname, ext)
        p.get_partition_information()
        with open("topology.json", "w") as f:
            json.dump(topology, f, indent=4)
            
    except FileNotFoundError as e:
        print("Canot read input files: " + str(e))
        print("Make sure to run 'make PROG=%s' before this program is called" % (progname))
        
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Partitioner program (CAPO)")
    parser.add_argument('program', help="Base name (with extension) of the program to process (e.g., 'ex1.c'")
    #parser.add_argument('program2', help="Base name (with extension) of the second program to process (e.g., 'ex1.c'")
    args = parser.parse_args()
    main(args.program)
