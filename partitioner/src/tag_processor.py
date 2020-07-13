#!/usr/local/bin/python2.7
# encoding: utf-8
'''
tag_processor -- join two PDGs on the tagged send/receive calls


@author:     andrzej

'''

import sys
import os
import re

from argparse import ArgumentParser
from argparse import RawDescriptionHelpFormatter
from collections import defaultdict

import dot_reader
import ir_reader
import graph_helper
import pydot


def determineDataTypeName(tag):
    #should be read from file
    #tag is TAG_<mux>_<sec>_<datatype>
    #like: TAG_1_1_1
    tag_re = r'TAG_(\d+)_(\d+)_(\d+)'
    m = re.match(tag_re, tag)
    if m:
        return {'1' : 'POSITION',
                '2' : 'DISTANCE'}.get(m.group(3), 'UNKNOWN')
    else:
        return "UNDETERMINED"

class TagProcessor:
    
    def __init__(self, graph_l):
        self.graphs = {}
        self.irs = {}
        self.graph_helpers = {}
        self.info = []
        for fn in graph_l:
            dr = dot_reader.DotReader()
            self.info.append("Reading: " + fn)
            dr.read_dot(fn, None, None)
            self.graphs[fn] = dr
            self.info.append("Done.")
            fn_items = fn.split('.')
            if fn_items is None or len(fn_items) ==0:
                self.info.append("Cannot derive .ll filename from: " + fn)
                raise Exception("Cannot proceed")
            ir_fn = fn_items[0] + ".mod.ll"
            self.info.append("Reading: " + ir_fn)
            irr = ir_reader.IRReader()
            irr.read_ir(ir_fn)
            self.irs[fn] = irr
            self.info.append("Done.")
            self.info.append("Creating graph helper")
            self.graph_helpers[fn] = graph_helper.GraphHelper(dr.get_pdg())
            self.info.append("Done.")
            
    def process(self):
        '''
        returns True if processing is successfull
        '''
        medg = pydot.Dot()
        xdc_by_tag = defaultdict(list)
        #find tags in the graphs
        for fn, dr in self.graphs.items():
            irr = self.irs[fn]
            gh = self.graph_helpers[fn]
            irstrings = irr.get_label_irstring([r'TAG_.+'])
            #irstrings is {irstring : tag}
            self.info.append("Graph: " + fn + ": tags found: " + str(irstrings))
            for t_str, l_str in irstrings.items():
                self.info.append("doing irstring and tag: " + l_str + ":" + t_str)
                di = dr.find_nodes_for_irstring(l_str)
                for n in di:
                    #elf.info.append("node for irstring and tag: " + str(n) + ":" + l_str + ":" + t_str)
                    tmp_n = gh.find_root_declaration(n)
                    tmp_n.set('annotation', t_str)
                    self.info.append("setting annotation: " + t_str + ": " + str(tmp_n))
                    tmp_name = irr.get_variable_name(tmp_n.get_label())
                    dinfo = irr.get_DbgInfo(n, var=tmp_name)
                    tmp_n.set('dbginfo', "\"" + str(dinfo) + "\"")
                    self.info.append("setting dbginfo: " + str(dinfo))
                    users = gh.find_users(tmp_n)
                    for u in users:
                        f_name = irr.get_function_name(u.get_label())
                        if f_name is not None and f_name in ['xdc_asyn_send', 'xdc_blocking_recv']:
                            fdinfo = irr.get_DbgInfo(u, f_name)
                            u.set('dbginfo', "\"" + str(fdinfo) + "\"")
                            self.info.append("setting dbginfo for function: " + f_name + ": " + str(fdinfo))
                            print("NODE:", str(u))
                            f_param_nodes = gh.get_neighbors(u, direction='dst', label=['DEF_USE'])                           
                            print("  USES:", str([str(x) for x in f_param_nodes]))
                            f_2 = [gh.find_root_declaration(x) for x in f_param_nodes]
                            print("    ROOT:", str([str(x) for x in f_2]))
                            f_3 = [gh.find_dbg_declare(x) for x in f_2]
                            print("       DBGDEC:", str([str(x) for x in f_3]))
                            #print("  TYPES:", str([irr.get_type_name(x_.get_label()) for x_ in f_param_nodes]))
                            f_param_types = [irr.get_type_name(x_.get_label()) for x_ in f_param_nodes]
                            #for x in f_param_nodes:
                            #    f_param_2 = gh.get_neighbors(x, direction='dst', label=['DEF_USE'])
                            #    print("    USES2:", str([str(x_) for x_ in f_param_2]))
                            #    for y in f_param_2:
                            #        f_param_3 = gh.get_neighbors(y, direction='src', label=['DEF_USE'])
                            #        print("      USES3:", str([str(x_) for x_ in f_param_3]))
                            #u.set('uses_types', f_param_types)
                            xdc_by_tag[t_str].append(u)
                self.info.append("GHRAPH: " + fn + " nodes:" + str(len(dr.get_pdg_nodes())) + " links: " + str(len(dr.pdg.get_edges())))
            for n in dr.pdg.get_nodes():
                if medg.get_node(n.get_name()):
                    print("DUPLICATE NAME: ", n.get_name())#XXX
                n.set('side', fn.split('_')[0])
                medg.add_node(n)
            for e in dr.pdg.get_edges():
                #e.set('weight', 1) 
                medg.add_edge(e)
        print("XDC_BY_TAG:", str(xdc_by_tag)) 
        self.info.append("MEDG: " + fn + " nodes:" + str(len(medg.get_nodes())) + " links: " + str(len(medg.get_edges())))
        for tag, nodes in xdc_by_tag.items():
            if len(nodes) == 2:
                for n in nodes:
                    param_types = n.get('uses_types')
                    if not param_types:
                        param_types = ["?"]
                    filtered_p_t_list = [x for x in param_types if x not in ['i8*', 'struct._tag']]
                    self.info.append("Tag: " + tag + ", function: " + str(n.get('dbginfo')) + ", tag type: " + determineDataTypeName(tag) + ", xdc parameter type: " + str(filtered_p_t_list))
                    n.set('style', 'filled')
                    n.set('fillcolor', 'gray')
                e = pydot.Edge(nodes[0], nodes[1], label="{CROSSDOMAIN}")#, weight=20)
                medg.add_edge(e)
            else:
                print("WARNING: Number of nodes with the same tag is not two, skipping: " + tag)
                
        jgname = "join_graph.dot"
        self.info.append("Writing join graph: " + jgname)
        medg.write(jgname)
        self.info.append("Done.")
        return True
    
    def get_info(self):
        return self.info
    
    #def print_join_graph(self, filename):
        #'''
        #prints the joined graph into a file
        #'''
        #pass
        

class CLIError(Exception):
    '''Generic exception to raise and log different fatal errors.'''
    def __init__(self, msg):
        super(CLIError).__init__(type(self))
        self.msg = "E: %s" % msg
    def __str__(self):
        return self.msg
    def __unicode__(self):
        return self.msg

def main(argv=None): # IGNORE:C0111
    '''Command line options.'''

    if argv is None:
        argv = sys.argv
    else:
        sys.argv.extend(argv)

    program_name = os.path.basename(sys.argv[0])

    try:
        # Setup argument parser
        parser = ArgumentParser(formatter_class=RawDescriptionHelpFormatter)
        parser.add_argument(dest="graphs", help="Names of the DOT graph files containing the PDGs to process", 
                            metavar="graphs", nargs=2)

        # Process arguments
        args = parser.parse_args()
        
        tp = TagProcessor(args.graphs)
        if tp.process():
            #tp.print_join_graph("aaa.txt")
            pass
        for l in tp.get_info():
            print(l)


        return 0
    except KeyboardInterrupt:
        ### handle keyboard interrupt ###
        return 0
    except Exception as e:
        sys.stderr.write(program_name + ": " + str(e) + "\n")
        return 2

if __name__ == "__main__":
    sys.exit(main())
