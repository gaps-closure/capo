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
    if args.zmq:
        context = zmq.Context()
        socket = context.socket(zmq.REQ)
        socket.connect(args.zmq)
        with open('result.txt') as f:
            if '=====UNSATISFIABLE=====' in f.readlines():
                message = json.dumps({"Result" : "Conflict"})
            else:
                message = json.dumps({"Result" : "Succss"})
        socket.send_string(message)

    with open('result.txt') as rf:
        data = rf.readlines()
        if 'UNSATISFIABLE' in data[0]:
            print("Conflict")
        else:
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
                                resStr = row.split(",")[-2] + ":" +  row.split(",")[-1].strip()
                                print(f"Function on line: {resStr}      Has enclave:  {enclave}") 
                                break
        
        