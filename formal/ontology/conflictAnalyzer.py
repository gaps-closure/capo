#!/bin/python3

import os
import sys
import zmq
import argparse
import json

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="""
        """
    )

    parser.add_argument('--files','-f', type=str, 
                    help='files to process')

    parser.add_argument('--zmq','-z', type=str, 
                    help='ZMQ IP Address (tcp://XXX.XXX.XXX.XXX:PORT)')

    args = parser.parse_args()


    # os.system(f"./conflictAnalyzer.sh {args.files} ")
    if args.zmq:
        context = zmq.Context()
        socket = context.socket(zmq.REQ)
        socket.connect(args.zmq)
        with open('result.txt') as f:
            if '=====UNSATISFIABLE=====' in f.read():
                message = json.dumps({"Result" : "Conflict"})
            else:
                message = json.dumps({"Result" : "Succss"})
        socket.send_string(message)

    with open('result.txt') as rf:
        data = rf.readlines()
        if '=====UNSATISFIABLE=====' in data:
            print("Conflict")
        else:
            print("Succss")
            with open('nodes2linenumbers.txt') as nf:
                nodes = nf.readlines()
                for line in data:
                    index = line.find('ENTRY: C_FunctionEntry(')
                    if index != -1:
                        count = 0
                        while index + count < len(line):
                            if line[index + 26 + count] == ")":
                                break
                            count +=1
                        nodeID = line[index + 26: index + 26 + count]
                        lineNum = ""
                        for line2 in nodes:
                            if nodeID in line2:
                                lineNum = line2.split(":")[1]
                                break
                        enclave = line.split(" ")[2]
                        print(f"Function on line: {lineNum} has enclave:  {enclave}") 
        
        