#import networkx
import argparse
import os
import re

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
            return ",".join([self.label, self.ir_str, self.enclave])
        def __repr__(self):
            return self.__str__()
            
    def __init__(self):
        self.by_lab = {}
        self.by_str = {}
        self.by_enc = {}
        
    def add_annotation_info(self, l, s, e):
        al = AnnotationInfo.ALabel(l, s, e)
        self.by_lab[l] = al
        self.by_str[s] = al
        if e in self.by_enc:
            self.by_enc[e].append(al)
        else:
            self.by_enc[e] = [al]
        
    def get_by_label(self, l):
        return self.by_lab.get(l)
    
    def get_by_enclave(self, e):
        return self.by_enc.get(e)

class ConflictInfo():
    def __init__(self, l, dinfo):
        self.kind = "UNKN"
        self.name = "UNKN"
        self.label = l
        self.line = dinfo.get_line() if dinfo is not None else 0
        self.column = dinfo.get_column() if dinfo is not None else 0
        m = re.match(r'.+call .+ @(\w+)\(', l)
        if m is not None:
            self.kind = 'Function call'
            self.name = m.group(1)
            return
        m = re.match(r'.+ENTRY\\>\\> (\w+) .+ line: (\d+)', l)
        if m is not None:
            self.kind = 'Definition in a function'
            self.name = m.group(1)
            self.line = m.group(2)
            return

    def __str__(self):
        return "Conflict on line %s, column %s (%s, name: %s)" % (self.line, self.column, self.kind, self.name)

    def __repr__(self):
        return self.__str__()
        
class Partitioner():
    def __init__(self, pol_, irr_, dot_):
        self.pol = pol_
        self.irr = irr_
        self.dot = dot_
        self.info_out = []
        self.ann_info = AnnotationInfo()

    def partition_to(self, encs, enc):
        '''
        encs - all the enclaves
        enc - the enclave into which the data flows (through guards)
        '''
        if len(encs) != 2:
            print("This version of partitioner can only handle exactly 2 enclaves")
            return
        other_enc = encs[0] if encs[1] == enc else encs[1]
        secmark_out_conflict = []
        secmark_out_no_conflict = []
        gh = graph_helper.GraphHelper(self.dot.get_pdg())
        labs = self.pol.get_labels()
        lab_str = self.irr.get_label_irstring(labs)
        lab_enc = self.pol.get_label_enclave(labs)
        for l in labs:
            self.ann_info.add_annotation_info(l, lab_str[l], lab_enc[l])
        #find all data nodes (variables) for all the labels
        smcl = "Data items with security markings:"
        secmark_out_conflict.append(smcl)
        secmark_out_no_conflict.append(smcl)
        data_items = {}
        for l in labs:
            l_str = self.ann_info.get_by_label(l).get_irstring()
            di = self.dot.find_nodes_for_irstring(l_str)
            data_items[l] = di
            for n in di:
                tmp_l = self.dot.get_fixed_node_label(n)
                tmp_n = gh.find_root_declaration(n)
                tmp_name = self.irr.get_variable_name(tmp_n.get_label())
                dinfo = self.irr.get_DbgInfo(tmp_l)
                dinfo.set_name(tmp_name)
                smcl = "  Enclave: %s, item: %s" %(lab_enc[l], str(dinfo))
                secmark_out_conflict.append(smcl)
                secmark_out_no_conflict.append(smcl)
                if lab_enc[l] != enc:
                    smcl = "    ACTION: Define variable in the same scope, of the same type, named %s, without any annotations" % (dinfo.name + '_' + enc)
                    secmark_out_conflict.append(smcl)
        #start coloring, up to definitions, then down to usage
        #finds if data of different markings is used in the same statement
        conflicts = set()
        for l,nn in data_items.items():
            for n in nn:
                col = self.ann_info.get_by_label(l).get_enclave()
                conflicts.update(gh.propagate_enclave(n, col))
        if len(conflicts) == 0:
            smcl = "There is no data usage conflicts between enclaves"
            secmark_out_conflict.append(smcl)
            secmark_out_no_conflict.append(smcl)
        else:
            self.info_out.extend(secmark_out_conflict)
            secmark_out_conflict = []
            self.info_out.append("There exist at least one conflict statement where data from different enclaves are mixed:")
            self.info_out.append("    ACTION: Include 'partitioner.h' in the source file")
            for c in conflicts:
                tmp_l = self.dot.get_fixed_node_label(c)
                dinfo = self.irr.get_DbgInfo(tmp_l)
                cinfo = ConflictInfo(tmp_l, dinfo)
                self.info_out.append("  " + str(cinfo))
                self.info_out.append("    ACTION: Just before this statement, put a pair of send/receive statements for all variables annotated with '%s' as follows:" % other_enc)
                self.info_out.append("    ACTION: 'guarded_send()' to enclave '%s' for the original variable" % enc)
                self.info_out.append("    ACTION: 'guarded_receive()' for the variable with '_%s' postfix created in previous step" % enc)
                self.info_out.append("    ACTION: Then, in the conflicting statement, change the variable to the _%s counterpart" % enc)
                self.info_out.append("    ACTION: For example, for variable XXX, and its counterpart XXX_%s:" % enc)
                self.info_out.append('    ACTION:   guarded_send(%s, "XXX", sizeof(XXX), &XXX)' % enc)
                self.info_out.append('    ACTION:   guarded_receive("XXX", sizeof(XXX_%s), &XXX_%s)' % (enc, enc))
                self.info_out.append("    ACTION:   change XXX to XXX_%s in the conflicting statement" %(enc))
            self.info_out.append("    ACTION: <end of step1>")  
        #see if the data are declared in the same function
        #we assume the annotation is at the variable declaration
        #which is, color up the CONTROL links
        conflicts_def = set()
        for l,nn in data_items.items():
            for n in nn:
                col = self.ann_info.get_by_label(l).get_enclave()
                for upnode in gh.get_neighbors(n, dir='dst', label=['CONTROL']):
                    conflicts_def.update(gh.propagate_enclave_oneway(upnode, col, dir='dst', label=['CONTROL'], stop_at_function=True))
        self.dot.get_pdg().write('enclaves.dot')
        main_copied = False
        if len(conflicts_def) == 0:
            self.info_out.extend(secmark_out_no_conflict)
            self.info_out.append("There is no definition conflicts between enclaves")
        else:
            self.info_out.extend(secmark_out_conflict)
            self.info_out.append("There exist at least one conflict where data from different enclaves is defined in the same function:")
            for c in conflicts_def:
                tmp_l = self.dot.get_fixed_node_label(c)
                cinfo = ConflictInfo(tmp_l, None)
                self.info_out.append("  " + str(cinfo))
                orig_f_name = cinfo.name
                new_f_name = orig_f_name  + "_" + enc
                other_new_f_name =  orig_f_name  + "_" + other_enc
                if orig_f_name == 'main': main_copied = True
                self.info_out.append("    ACTION: Copy function '%s' as '%s'" % (orig_f_name, new_f_name))
                self.info_out.append("    ACTION: In '%s':" % orig_f_name)
                self.info_out.append("      ACTION: delete all variables annotated as '%s'" %enc)
                self.info_out.append("      ACTION: delete all variables created previously as 'XXX_%s'" % enc)
                self.info_out.append("      ACTION: delete all 'guarded_receive()' calls")
                self.info_out.append("      ACTION: delete all the conflicting statement(s)")
                self.info_out.append("      ACTION: delete statements using the deleted variables")
                self.info_out.append("    ACTION: In '%s':" % (new_f_name))
                self.info_out.append("      ACTION: delete all variables annotated other than '%s'" % enc)
                self.info_out.append("      ACTION: delete all 'guarded_send()' calls")
                self.info_out.append("      ACTION: delete statements using the deleted variables")
                #the following is needed because pdg software does not handle control flow right
                self.info_out.append("    ACTION: Rename '%s' as '%s':" % (orig_f_name, other_new_f_name))
                self.info_out.append("    ACTION: Add function '%s' that will call both '%s' and '%s'" % (orig_f_name, new_f_name, other_new_f_name))
            self.info_out.append("    ACTION: <end of step2>")  
        self.info_out.append("Other (if there is no more conflicts):")
        self.info_out.append("    ACTION: Add 'libpartitioner.a' to the linking statement for the program")
        new_main = "main_" + enc
        other_new_main = "main_" + other_enc
        new_file_enc = "%s_%s.mod.c" % ("ex1", enc)
        new_file_other_enc = "%s_%s.mod.c" % ("ex1", other_enc)
        if not main_copied:
            self.info_out.append("    ACTION: If '%s' does not exist, copy function 'main' as a new function '%s'" % (new_main, new_main))
            self.info_out.append("    ACTION: If '%s' does not exist, copy function 'main' as a new function '%s'" % (other_new_main, other_new_main))
            self.info_out.append("    ACTION: Make sure that the new functions '*_%s' are reachable from '%s', and none of them are reachable from '%s'" % (enc, new_main, other_new_main))
        self.info_out.append("    ACTION: copy the modified program to new source file called %s" %(new_file_enc))
        self.info_out.append("    ACTION: Rename original file to %s" %(new_file_other_enc))
        self.info_out.append("    ACTION: From file %s remove 'main' and all '*_%s' functions. Rename 'main_%s' to 'main'. As the first statement in 'main' add 'initialize_partitioner(\"%s\");'. As the last statement add 'cleanup_partitioner();'. This is the program running in enclave %s" % (new_file_other_enc, enc, other_enc, other_enc, other_enc))
        self.info_out.append("    ACTION: From file %s remove 'main' and 'main_%s'; and rename 'main_%s' to 'main'. As the first statement in 'main' add 'initialize_partitioner(\"%s\");'. As the last statement add 'cleanup_partitioner();'. This is the program running in enclave %s" % (new_file_enc, other_enc, enc, enc, enc))
        self.info_out.append("    ACTION: Remove dead code from both files")
        
    def get_partition_information(self):
        enc = self.pol.get_enclaves()
        if len(enc) == 0:
            self.info_out.append("This program has no security enclaves defined! Use CLE to annotate the source code.")
        elif len(enc) == 1:
            self.info_out.append("This program has one security enclave defined.")
            self.info_out.append("It can be only run in enclave '" + enc[0] + "', and can be run without modifications.")
        elif len(enc) > 2:
            self.info_out.append("This program has %d security enclaves defined." % (len(enc)))
            self.info_out.append("Currently maximum of 2 is permitted.")
        else:
            self.info_out.append("Two security enclaves defined: %s" % " and ".join(enc))
            enc_c = self.pol.get_common_enclaves()
            if len(enc_c) == 0:
                self.info_out.append("No data transfer between the two enclaves is permitted.")
                self.info_out.append("This program cannot be partitioned.")
                self.info_out.append("Please add the data flow rules for one of the labels.")
            elif len(enc_c) == 1:
                self.info_out.append("Data can flow only to %s (through guards)" % (enc_c[0]))
                self.partition_to(enc, enc_c[0])
            else:
                self.info_out.append("Data can flow to enclaves: %s (through guards)" % " or ".join(enc_c))
                self.partition_to(enc, enc_c[0])
        return self.info_out
            

def main(progname):
    pol = policy_resolver.PolicyResolver()
    irr = ir_reader.IRReader()
    dot = dot_reader.DotReader()

    source_file_name = progname + ".mod.c"
    pre, ext = os.path.splitext(source_file_name)
    try:
        pol.read_json(progname + ".c.clemap.json")
        irr.read_ir(pre + ".ll")
        dot.read_dot("pdgragh.main.dot", "cdgragh.main.dot", "ddgragh.main.dot")
        print("Source file to be modified: %s" % source_file_name)
        p = Partitioner(pol, irr, dot)
        for i in p.get_partition_information():
            print(i)
    except FileNotFoundError as e:
        print("Canot read input files: " + str(e))
        print("Make sure to run 'make PROG=%s' before this program is called" % (progname))
        
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Partitioner program (CAPO)")
    parser.add_argument('program', help="Base name (no extensions) of the program to process")
    args = parser.parse_args()
    main(args.program)
