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


    os.system(f"./conflictAnalyzer.sh {args.files} >  result.txt")
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

    with open('result.txt') as f:
        if '=====UNSATISFIABLE=====' in f.read():
            print("Conflict")
        else:
            print("Succss")
        
        