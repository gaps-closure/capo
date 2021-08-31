#!/bin/python3

import os
import sys
import zmq
import argparse
import json
import csv
import pandas as pd
from typing import Optional
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser(
        description="""
        Parses minizinc output from conflict analyzer
        """
    )
    parser.add_argument('--file', '-f', type=Path,
                        help='minizinc output file to process')
    parser.add_argument('--type', '-t', type=str,
                        help='minizinc output file type', choices=['assignment', 'findmus'])
    parser.add_argument('--node-to-line-number', '-n', type=Path,
                        required=True, help='Node to line number map')
    parser.add_argument('--pdg-data', '-p', type=Path,
                        required=('findmus' in sys.argv), help='pdg_data csv')
    parser.add_argument('--zmq', '-z', type=str, nargs='?',
                        help='ZMQ IP Address (tcp://XXX.XXX.XXX.XXX:PORT)')
    parser.add_argument('--output', '-o', type=Path, help='Output file')

    args = parser.parse_args()
    file: Path = args.file
    out_type: str = args.type
    node_map: Path = args.node_to_line_number
    pdg_data: Path = args.pdg_data
    zmq_addr: Optional[str] = args.zmq
    output: Path = args.output

    if out_type == 'assignment':
        result = parseAssignment(file, node_map)
        topology = result['topology']
        with open(output, 'w') as of:
            print(f"Topology written to {output}")
            of.write(json.dumps(topology, indent=4))
        if zmq_addr:
            context = zmq.Context()
            socket = context.socket(zmq.REQ)
            socket.connect(args.zmq)
            socket.send_string(json.dumps(result))
            print(f"Result sent to {zmq_addr}")
    elif out_type == 'findmus':
        conflicts = parseFindMUS(file, pdg_data, node_map)
        conflicts_ = []

        for c in conflicts:
            con = {
                "name": c[2],
                "description": "TODO",
                "source": [(c[0], c[1])],
                "remedies": ["TODO"]
            }
            conflicts_.append(con)

        result = {"result": "Conflict", "conflicts": conflicts_}
        print("Conflict")
        if zmq_addr:
            context = zmq.Context()
            socket = context.socket(zmq.REQ)
            socket.connect(args.zmq)
            socket.send_string(json.dumps(result))
            print(f"Result sent to {zmq_addr}")


def parseAssignment(file: Path, node_map: Path):
    topology = {}
    fun_enclave_assingments = []
    global_enclave_assingments = []
    fileName = ""
    print("Success")
    with open(file) as rf:
        data = rf.readlines()
        with open(node_map) as nf:
            nodes = nf.readlines()
            for line in data:
                index = line.find('FunctionEntry ')
                if index != -1:
                    sp = line.split(" ")
                    index = int(sp[5])
                    enclave = sp[7].split("::")[0].strip("[]")
                    resStr = ""
                    for row in nodes:
                        if int(row.split(",")[0].strip()) == index:
                            fileName = row.split(",")[-2]
                            resStr = row.split(
                                ",")[-2] + ":" + row.split(",")[-1].strip()
                            funName = row.split(",")[-3].strip()
                            fun_enclave_assingments.append(
                                {"name": funName, "level": enclave,  "line": row.split(",")[-1].strip()})
                            print(
                                f"Function {funName } on line: {resStr}      Has enclave:  {enclave}")
                            break
            for line in data:
                index = line.find('VarNode ')
                if index != -1:
                    sp = line.split(" ")
                    index = int(sp[5])
                    enclave = sp[-1].split("::")[0].strip("[]")
                    resStr = ""
                    for row in nodes:
                        if int(row.split(",")[0].strip()) == index:
                            fileName = row.split(",")[-2]
                            resStr = row.split(
                                ",")[-2] + ":" + row.split(",")[-1].strip()
                            funName = row.split(",")[-3].strip()
                            global_enclave_assingments.append(
                                {"name": funName, "level": enclave, "line": row.split(",")[-1].strip()})
                            print(
                                f"Function {funName} on line: {resStr}      Has enclave:  {enclave}")
                            break
        topology = {"source_path": fileName, "levels": [
            "ORANGE,PURPLE"], "global_scoped_vars": global_enclave_assingments, "functions": fun_enclave_assingments}
        result = {"result": "Success", "topology": topology}
        return result


def parseFindMUS(file: Path, pdg_data_path: Path, node_map: Path):
    output = []
    csvfile = open(pdg_data_path)
    pdg_data = csv.reader(csvfile)
    edges = []
    for row in pdg_data:
        if len(row) > 0:
            if row[0] == 'Edge':
                edges.append((row[6], row[7]))
    print(edges)
    with open(file, "r") as fileMus:
        node2LineNumFile = open(node_map)
        nodeIdx2LineNum = node2LineNumFile.readlines()
        data = json.loads("".join(fileMus.readlines()[1:-2]))
        # print (data)
        constraints = data["constraints"]
        for constraint in constraints:
            if constraint["constraint_name"] != "":
                # print(constraint["assigns"])
                reason = constraint["constraint_name"]
                id = constraint["assigns"][2:]
                if "e=" in constraint["assigns"]:
                    line1 = nodeIdx2LineNum[int(
                        edges[int(id)-1][0])-1].split(",")
                    line2 = nodeIdx2LineNum[int(
                        edges[int(id)-1][1])-1].split(",")
                    print(
                        f"edge: {id} with nodes: {edges[int(id)-1]} failed: {reason}")
                    print(f"Line 1: {line1} Line 2: {line2}")
                    output.append(
                        (line1[-2].strip(), line1[-1].strip(), reason))
                    output.append(
                        (line2[-2].strip(), line2[-1].strip(), reason))
                else:
                    print(f"node: {id} failed: {reason}")
                    line = nodeIdx2LineNum[int(id)-1].split(",")
                    output.append((line[-2].strip(), line[-1].strip(), reason))

    for error in output:
        print(
            f"In file {error[0]} on line {error[1]}: {error[2]} conflict found ")

    return output


if __name__ == "__main__":
    main()
