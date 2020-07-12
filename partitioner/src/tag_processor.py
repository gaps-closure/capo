#!/usr/local/bin/python2.7
# encoding: utf-8
'''
tag_processor -- join two PDGs on the tagged send/receive calls


@author:     andrzej

'''

import sys
import os
import re
import ast

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
        self.ann_map = {}
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
            self.ann_map[fn] = fn_items[0].split('/')[0] + "/ann_map.txt"
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
            print("================== " + fn)
            irr = self.irs[fn]
            gh = self.graph_helpers[fn]
            irstrings = irr.get_label_irstring([r'TAG_.+'])
            # irstrings = self.get_dictionary(self.ann_map[fn])
            print("================== " + str(irstrings))
            #irstrings is {irstring : tag}
            self.info.append("Graph: " + fn + ": tags found: " + str(irstrings))
            for t_str, l_str in irstrings.items():
                self.info.append("doing irstring and tag: " + l_str + ":" + t_str)
                di = dr.find_nodes_for_irstring(l_str)
                for n in di:
                    print("######### n = " + str(n))
                    #elf.info.append("node for irstring and tag: " + str(n) + ":" + l_str + ":" + t_str)
                    tmp_n = gh.find_root_declaration(n)
                    print("######### tmp_n = " + str(tmp_n))
                    tmp_n.set('annotation', t_str)
                    self.info.append("setting annotation: " + t_str + ": " + str(tmp_n))
                    tmp_name = irr.get_variable_name(tmp_n.get_label())
                    dinfo = irr.get_DbgInfo(n, var=tmp_name)
                    tmp_n.set('dbginfo', "\"" + str(dinfo) + "\"")
                    self.info.append("setting dbginfo: " + str(dinfo))
                    users = gh.find_users(tmp_n)
                    for u in users:
                        print("#################====== " + str(u))
                        f_name = irr.get_function_name(u.get_label())
                        print(f_name)
                        if f_name is not None and f_name in ['xdc_asyn_send', 'xdc_blocking_recv']:
                            fdinfo = irr.get_DbgInfo(u, f_name)
                            u.set('dbginfo', "\"" + str(fdinfo) + "\"")
                            self.info.append("setting dbginfo for function: " + f_name + ": " + str(fdinfo))
                            xdc_by_tag[t_str].append(u)
                            print("####################### " + f_name + "====" + t_str)
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
                    self.info.append("Tag: " + tag + ", function: " + str(n.get('dbginfo')) + ", datatype: " + determineDataTypeName(tag))
                    n.set('style', 'filled')
                    n.set('fillcolor', 'gray')
                e = pydot.Edge(nodes[0], nodes[1], label="{CROSSDOMAIN}")#, weight=20)
                medg.add_edge(e)
            else:
                print("WARNING: not exactly two nodes have the same tag: " + tag + " " + str(len(nodes)))
                for n in nodes:
                    print("==== Tag: " + tag + ", function: " + str(n.get('dbginfo')) + ", datatype: " + determineDataTypeName(tag))
#                e = pydot.Edge(nodes[0], nodes[1], label="{CROSSDOMAIN}")#, weight=20)
#                medg.add_edge(e)
                
        jgname = "join_graph.dot"
        self.info.append("Writing join graph: " + jgname)
        medg.write(jgname)
        self.info.append("Done.")
        return True

    def get_dictionary(self, map_file):
        file = open(map_file, "r")
        contents = file.read()
        dictionary = ast.literal_eval(contents)
        file.close()
        return dictionary

    
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
