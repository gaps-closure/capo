#!/bin/python3

import re

if __name__ == "__main__":
    f = open("result.txt", "r")
    lines = f.readlines()
    nodes = set()
    edges = set()
    cf = open("./constraints/conflict_analyzer_constraints.mzn", "r")
    constraints = cf.readlines()
    edge2FailedConstraints = {}
    node2FailedConstraints = {}
    for line in lines:
        if "path" in line:
            lineNum = line.split("|")[-3]
            lineNum = int(lineNum) -1
            issue = line.split("|")[-1]
            kind = issue.split("=")[0]
            number = issue.split("=")[-1]
            number = re.sub("[^0-9]","",number)
            idx = lineNum
            # find closest constraint that is namesd
            while not "::" in constraints[idx]:
                idx-=1
            constaintName = constraints[idx].split("::")[1].split(" ")[1].strip()
            if "e" in kind:
                edges.add(int(number))
                if int(number) in edge2FailedConstraints.keys():
                    edge2FailedConstraints[int(number)].add(constaintName)
                else:
                    edge2FailedConstraints[int(number)] = set([constaintName])
                # print(f"Edge: {number}") 
            else:
                nodes.add(int(number))
                if int(number) in node2FailedConstraints.keys():
                    node2FailedConstraints[int(number)].add(constaintName)
                else:
                    node2FailedConstraints[int(number)] = set([constaintName])
                # print(f"Node: {number}")
    dbgE = open("dbg_edge.csv", "r")
    dbg_edge_lines = dbgE.readlines()
    dbgN = open("dbg_node.csv", "r")
    dbg_node_lines = dbgN.readlines()
    outFile = open("unsat.md", "w")
    nodesUsed = set()
    for edge in sorted(edges):
        eType = dbg_edge_lines[int(edge)].split(" ")[1][:-1]
        constraint = edge2FailedConstraints[edge]
        src = dbg_edge_lines[int(edge)].split(" ")[2][:-1]
        dst = dbg_edge_lines[int(edge)].split(" ")[3][:-1]
        nodesUsed.add(int(src))
        nodesUsed.add(int(dst))
        outFile.write(f"Edge: [{edge}](#eid-{edge}) : [{src}](#nid-{src}) => [{dst}](#nid-{dst})  : {eType} Failed: {constraint}\n\n")

    for node in sorted(nodes):
        nType = dbg_node_lines[int(node)].split(" ")[2][:-1]
        constraint = node2FailedConstraints[node]
        eLab = dbg_edge_lines[int(edge)].split(" ")[1][:-1]
        nodesUsed.add(int(node))
        outFile.write(f"Node: [{node}](#nid-{node}) : {nType} Failed: {constraint}\n\n")
    for edge in sorted(edges):
        outFile.write(f"# EID {edge}\n\n")
        dbgLine = dbg_edge_lines[int(edge)]
        outFile.write(f"{dbgLine}\n\n")
    for node in sorted(nodesUsed):
        outFile.write(f"# NID {node}\n\n")
        dbgLine = dbg_node_lines[int(node)]
        outFile.write(f"{dbgLine}\n\n")
    outFile.close()
    # print(f"Edges: {edges}")
    # print(f"Nodes: {nodes}")