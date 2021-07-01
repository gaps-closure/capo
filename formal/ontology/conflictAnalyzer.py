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

    parser.add_argument('--zmq','-z', type=str, 
                    help='ZMQ IP Address (tcp://XXX.XXX.XXX.XXX:XXXXX)')

    args = parser.parse_args()


    os.system("./conflictAnalyzer.sh")
    if args.zmq:
        context = zmq.Context()
        socket = context.socket(zmq.REQ)
        socket.connect(args.zmq)
        message = json.dumps({"Result" : "Succss"})
        socket.send_string(message)