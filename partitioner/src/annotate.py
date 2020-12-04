#import networkx
import argparse
import os
import re
import json

import policy_resolver
import ir_reader
import dot_reader
import graph_helper

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
                
        #now, follow up 'DEF_USE' to label definition from annotations
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
                
        self.dot.get_pdg().write('TFB.dot')

    def get_partition_information(self):
        enc = self.pol.get_enclaves()
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
        p = Partitioner(pol, irr, dot)
        p.set_input_names(progname, ext)
        p.get_partition_information();
            
    except FileNotFoundError as e:
        print("Canot read input files: " + str(e))
        print("Make sure to run 'make PROG=%s' before this program is called" % (progname))
        
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Partitioner program (CAPO)")
    parser.add_argument('program', help="Base name (with extension) of the program to process (e.g., 'ex1.c'")
    #parser.add_argument('program2', help="Base name (with extension) of the second program to process (e.g., 'ex1.c'")
    args = parser.parse_args()
    main(args.program)
