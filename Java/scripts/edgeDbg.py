#!/bin/python3

import sys

if __name__ == "__main__":
    edge = sys.argv[1]

    nodes = open("dbg_node.csv","r").read().split("\n")
    edges = open("dbg_edge.csv","r").read().split("\n")

    src = edges[int(edge)].split(",")[-3].strip()
    dst = edges[int(edge)].split(",")[-2].strip()

    print(f"Source: {nodes[int(src)]}")
    print(f"Dest: {nodes[int(dst)]}")



