import sys
import argparse
import os
import re
import dot_reader
import graph_helper
import ir_reader
import json
import policy_resolver
topology = {}
def main(inFile,llInFile,enclaves,cleFile,outFile,topologyFile):
    pol = policy_resolver.PolicyResolver()
    try: pol.read_json(cleFile)
    except Exception as e:
        print("Canot read input cle file: " + str(cleFile) + str(e),file=sys.stderr)
        exit(-1)
    enc_c = pol.get_common_enclaves()
    if len(enc_c) == 0:
        print("No data transfer between the two enclaves is permitted.")
        print("This program cannot be partitioned.")
        print("Please add the data flow rules for one of the labels.")
        exit(-1)
    elif len(enc_c) == 1:
        print("Data can flow only to %s (through guards)" % (enc_c[0]))
    else:
        print("Data can flow to enclaves: %s (through guards)" % " or ".join(enc_c))
    enc=enc_c[0]
    irr = ir_reader.IRReader()
    try: irr.read_ir(llInFile)
    except Exception as e:
        print("Canot read input ll file: " + str(llInFile) + str(e),file=sys.stderr)
        exit(-1)
    dot = dot_reader.DotReader()
    try: dot.read_dot(inFile)
    except Exception as e:
        print("Canot read input dot file: " + str(inFile) + str(e),file=sys.stderr)
        exit(-1)
    try: encs=open(enclaves,"r")
    except Exception as e:
        print("Canot read input enclaves file: " + str(enclaves) + str(e),file=sys.stderr)
        exit(-1)
    for l in encs:
        t=l.split()
        if t is None or len(t) != 2:
                print("cannot parse enclave line: " + str(l),file=sys.stderr)
                continue 
        n=dot.get_pdg().get_node(t[1])
        if n:
            n.set('enclave', t[0])
            n.set('fillcolor', t[0])
            n.set('style', 'filled')
            d = irr.get_DbgInfo(n)
            if str(type(d)) == "<class 'str'>":
                list=d.split()
                if list[4] == str("False"):
                    local=False
                else:
                    local=True
                if int(list[5]) == 3:
                    dbginfo=ir_reader.DbgInfo(n,list[0],list[1],list[2],list[3],local,True)
                else:
                    dbginfo=ir_reader.DbgInfo(n,list[0],list[1],list[2],list[3],local)
            else:
                dbginfo=d
            n.set('dbginfo',dbginfo)
        else:
            print("node not found: " + str(t[1]),file=sys.stderr)
            #exit(-2)
    try:
        dot.get_pdg().write(outFile)


    except Exception as e:
        print("Canot write output file: " +str(outFile) + str(e),file=sys.stderr)
    #add global variables to topology file
    global_scoped_vars = []
    topology['source_path'] = "./refactored"
    topology['levels'] = pol.get_enclaves()
    topology['global_scoped_vars'] = global_scoped_vars
    for n in dot.get_pdg_nodes():
        if n.is_global_value():
            #print("GGLLOOBBAALL::", n)
            n_ann = n.get('enclave')
            d = irr.get_DbgInfo(n)
            if str(type(d)) == "<class 'str'>":
                list=d.split()
                if list[4] == str("False"):
                    local=False
                else:
                    local=True
                if int(list[5]) == 3:
                    dinfo=ir_reader.DbgInfo(n,list[0],list[1],list[2],list[3],local,True)
                else:
                    dinfo=ir_reader.DbgInfo(n,list[0],list[1],list[2],list[3],local)
            else:
                dinfo=d
            if dinfo.get_kind() == dinfo.GLOBAL:
                if n_ann:
                    json_var = {"name" : dinfo.get_name(), "level" : n_ann}
                    global_scoped_vars.append(json_var)
                else:
                    print("Global variable is not marked at the end of analysis:", dinfo)
                    print("  ACTION: This may happen if security policies are incorrect or this item is unused")
                    print("  ACTION: Check the program structure, and the annotations and policies")
                    #enc="DEFAULT"
                    print("  ACTION: Item assigned by default to: %s; check correctness of this assignment"%enc)
                    json_var = {"name" : dinfo.get_name(), "level" : enc, "default" : "true"}
                    global_scoped_vars.append(json_var)

    #ADD FUNCTIONS TO TOPOLOGY FILE
    function_labels = []
    topology['functions'] = function_labels
    for n in dot.get_pdg().get_entry_nodes():
        f = irr.get_DbgInfo(n)
        if str(type(f)) == "<class 'str'>":
            list=f.split()
            if list[4] == str("False"):
                local=False
            else:
                local=True
            if int(list[5]) == 3:
                fdinfo=ir_reader.DbgInfo(n,list[0],list[1],list[2],list[3],local,True)
            else:
                fdinfo=ir_reader.DbgInfo(n,list[0],list[1],list[2],list[3])
        else:
            fdinfo=f
        n_ann = n.get('enclave')
        if n_ann:
            func_l = {"name" : fdinfo.get_name(), "level" : n_ann, "line" : fdinfo.get_line()}
            function_labels.append(func_l)
        else:
            print("A function is not marked at the end of analysis:", fdinfo)
            print("  ACTION: This may happen if the program or the security policies are incorrect or this item is unused")
            print("  ACTION: Check annotations and policies in the program.")
            print("  ACTION: Check for unused functions. Check for functions called with wrong number of parameters.")
            #enc="DEFAULT"
            print("  ACTION: Item assigned by default to: %s; check correctness of this assignment"%enc)
            func_l = {"name" : fdinfo.get_name(), "level" : enc, "line" : fdinfo.get_line(), "default" : "true"}
            function_labels.append(func_l)
            #print("DEBUG:", str(n))
    
    with open(topologyFile, "w") as f:
        json.dump(topology, f, indent=4)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="add enclaves to dot file")
    parser.add_argument('dotInFile', help="in.dot")
    parser.add_argument('llInFile', help="*.mod.ll")
    parser.add_argument('enclaves', help="enclaves")
    parser.add_argument('clefile', help="clefile")
    parser.add_argument('dotOutFile', help="out.dot")
    parser.add_argument('topologyFile', help="topology output file")
    args = parser.parse_args()
    main(args.dotInFile,args.llInFile,args.enclaves,args.clefile,args.dotOutFile,args.topologyFile)
