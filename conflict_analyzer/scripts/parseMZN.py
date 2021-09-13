#!/usr/bin/env python3 

import zmq
import argparse
import json
import csv
import re
from typing import Any, Dict, Iterable, List, Optional, Set
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
    parser.add_argument('--pdg-data', '-p', type=Path,
                        required=True, help='pdg_data csv')
    parser.add_argument('--zmq', '-z', type=str, nargs='?',
                        help='ZMQ IP Address (tcp://XXX.XXX.XXX.XXX:PORT)')
    parser.add_argument('--output', '-o', type=Path, help='Output file')

    args = parser.parse_args()
    file: Path = args.file
    out_type: str = args.type
    pdg_path: Path = args.pdg_data
    zmq_addr: Optional[str] = args.zmq
    output: Optional[Path] = args.output

    with open(pdg_path, 'r') as pdg_f:
        pdg_csv = csv.reader(pdg_f, quotechar='"', skipinitialspace=True)
        if out_type == 'assignment':
            with open(file, 'r') as f:
                result = parseAssignment(f.read(), pdg_csv)
            topology = result['topology']
            if output:
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

            with open(file, 'r') as f:
                result = parseFindMUS(f.read(), pdg_csv)
            conflicts = result['conflicts'] 
            if zmq_addr:
                context = zmq.Context()
                socket = context.socket(zmq.REQ)
                socket.connect(args.zmq)
                socket.send_string(json.dumps(result))
                print(f"Result sent to {zmq_addr}")
            if output:
                with open(output, 'w') as of:
                    print(f"Conflicts written to {output}")
                    of.write(json.dumps(conflicts, indent=4))


def parseAssignment(mzn_output: str, pdg_csv: Iterable) -> Dict[str, Any]:
    pdg_csv = list(pdg_csv)
    
    function_entries : List[Dict[str, str]] = []
    global_var_entries : List[Dict[str, str]] = []
    enclaves : Set[str] = set() 

    nodes = sorted(
        [ (int(num), source, llvm, line) for [type_, num, _, _, llvm, *_, source, line, _]  in pdg_csv if type_ == 'Node' ], 
        key=lambda x: x[0]
    )

    def add_entry(line: str, entries: List[Dict[str, str]]) -> None:
        parts = [ s.strip() for s in line.split(" ") if s != '' ]
        node, [enclave, _label] = int(parts[2]), [ s.strip('[]') for s in parts[-1].split('::') ]
        node_, source, llvm, line = nodes[node-1]
        source = None if (stripped := source.strip()) == 'Not Found' else stripped
        assert node == node_ 
        match = re.search(r'@((\w|\.)*)', llvm)
        assert match is not None
        name = match.group(1)
        enclaves.add(enclave)
        entries.append({ "name": name, "level": enclave, "line": line })
        print(f"{name} is in {enclave}{'' if not source else f' at {source}:{line}'}")
    
    out = mzn_output.splitlines() 
    for line in out:
        if line.find('FunctionEntry') != -1:
            add_entry(line, function_entries)
        elif line.find('VarNode') != -1:
            add_entry(line, global_var_entries)
         
    topology = {
        "source_path": str(Path('.').resolve()), # provisional, not sure what is correct here
        "levels": list(enclaves),
        "global_scoped_vars": global_var_entries,
        "functions": function_entries
    }

    return { "result": "Success", "topology": topology } 

def parseFindMUS(mzn_output: str, pdg_csv: Iterable) -> Dict[str, Any]: 
    pdg_csv = list(pdg_csv)
    nodes = sorted(
        [ (int(num), source, llvm, line) for [type_, num, _, _, llvm, *_, source, line, _]  in pdg_csv if type_ == 'Node' ], 
        key=lambda x: x[0]
    )
    edges = sorted(
        [ (int(num), int(source), int(dest)) for [type_, num, _, _, _, _, source, dest, *_] in pdg_csv if type_ == 'Edge' ], 
        key=lambda x: x[0]
    )
    for (i, node) in enumerate(nodes):
        assert i == node[0] - 1
    for (i, edge) in enumerate(edges):
        assert i == edge[0] - 1

    src = mzn_output.splitlines()
    start_index, end_index = None, None
    for i, line in enumerate(src):
        if line.find('%%%mzn-json-start') != -1:
            start_index = i
        elif line.find('%%%mzn-json-end') != -1:
            end_index = i
    assert start_index is not None and end_index is not None
    json_out = json.loads("\n".join(src[start_index+1:end_index]))
    conflicts : List[Dict[str, Any]] = []
    for item in json_out['constraints']:
        if item['assigns'] and item['assigns'] != '':
            match = re.search(r'n=(\d+)', item['assigns'])
            if match is not None:
                node_num = int(match.group(1))
                (_, src, _, line) = nodes[node_num - 1] 
                conflicts.append({
                    "name": item['constraint_name'] if item['constraint_name'] != '' else 'Unknown',
                    "description": "TODO",
                    "sources": [
                        {
                            "file": src,
                            "range": {
                                "start": { "line": line, "character": -1, },
                                "end": { "line": line, "character": -1, }
                            }
                        }
                    ]
                })
            else:
                match = re.search(r'e=(\d+)', item['assigns'])
                assert match is not None
                edge_num = int(match.group(1))
                if edge_num >= len(edges) - 1:
                    continue
                _, source, dest = edges[edge_num - 1]
                (_, source_src, _, source_line), (_, dest_src, _, dest_line) = nodes[source - 1], nodes[dest - 1]
                conflicts.append({
                    "name": item['constraint_name'] if item['constraint_name'] != '' else 'Unknown',
                    "description": "TODO",
                    "sources": [
                        { 
                            "file": source_src, 
                            "range": { 
                                "start": { "line": source_line, "character": -1 }, 
                                "end": { "line": source_line, "character": -1 }, 
                            },
                        },                 
                        {
                            "file": dest_src,
                            "range": { 
                                "start": { "line": dest_line, "character": -1 }, 
                                "end": { "line": dest_line, "character": -1 }, 
                            },
                        }
                    ],
                    "remedies": [],
                })
    return { "result": "Conflict", "conflicts": conflicts }


if __name__ == "__main__":
    main()
