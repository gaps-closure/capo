import sys
import argparse
import os
import re
import dot_reader
import graph_helper
def main(inFile,enclaves,outFile):
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
        print(l)
        t=l.split()
        if t is None or len(t) != 2:
                print("cannot parse enclave line: " + str(l),file=sys.stderr)
                continue 
        n=dot.get_pdg().get_node(t[1])
        if n:
            n.set('enclave', t[0])
            n.set('fillcolor', t[0])
            n.set('style', 'filled')
        else:
            print("node not found: " + str(t[1]),file=sys.stderr)
            exit(-2)
    try:
        dot.get_pdg().write(outFile)
    except Exception as e:
        print("Canot write output file: " +str(outFile) + str(e),file=sys.stderr)
        exit(-1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Colorer program (CAPO)")
    parser.add_argument('dotInFile', help="in.dot")
    parser.add_argument('enclaves', help="enclaves")
    parser.add_argument('dotOutFile', help="out.dot")
    args = parser.parse_args()
    main(args.dotInFile,args.enclaves,args.dotOutFile)
