#!/bin/python3

import os
import sys
import zmq
import argparse
import json
import pandas as pd

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


    os.system(f"./conflictAnalyzer.sh {args.files} ")
    result = {}
    with open('result.txt') as rf:
        data = rf.readlines()
        if 'UNSATISFIABLE' in data[0]:
            result = {"result" : "Conflict", "conflicts": "TODO"}
            print("Conflict")
        else:
            
            topology = {}
            enclave_assingments = []
            fileName = ""
            print("Succss")
            with open('node2lineNumber.txt') as nf:
                nodes = nf.readlines()
                for line in data:
                    index = line.find('ENTRY:')
                    if index != -1:
                        sp = line.split(" ")
                        index = sp[1]
                        enclave = sp[2]
                        resStr = ""
                        for row in nodes:
                            # print(row.split(",")[0].strip())
                            if row.split(",")[0].strip() == index:
                                fileName = row.split(",")[-2]
                                resStr = row.split(",")[-2] + ":" +  row.split(",")[-1].strip()
                                funName = row.split(",")[-3];
                                enclave_assingments.append({"name" : funName, "level" : enclave,  "line" : row.split(",")[-1].strip() })
                                print(f"Function {funName } on line: {resStr}      Has enclave:  {enclave}") 
                                break
            topology = {"source_path" : fileName, "levels" : ["ORANGE,PURPLE"], "global_scoped_vars" : [] , "functions" : enclave_assingments}
            result = {"result" : "Succss", "topology" : topology}
    print(result)
    if args.zmq:
        context = zmq.Context()
        socket = context.socket(zmq.REQ)
        socket.connect(args.zmq)
        socket.send_string(json.dumps(result))
        print("Message sent")
        
        