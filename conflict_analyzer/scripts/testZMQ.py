#!/bin/python3

import zmq

if __name__ == "__main__":
    context = zmq.Context()
    socket = context.socket(zmq.REP)
    socket.bind("tcp://*:%s" % 5555)

    message = socket.recv()
    print (f"Received request: {message} ")
