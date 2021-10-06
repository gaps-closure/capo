#!/usr/bin/env python3

import os
import zmq
import csv
import subprocess
import argparse
import json
import re
from pathlib import Path
from typing import Any, Iterable, List, Set, Optional, Dict, Tuple, Union

def minizinc(temp_dir: Path, cle_instance: str, pdg_instance: str, enclave_instance: str, constraint_files: List[Path], 
    pdg_csv: list, source_map: Dict[Tuple[str, int], Tuple[str, int]]) -> Dict[str, Any]:
    cle_instance_path, pdg_instance_path, enclave_instance_path = \
        tuple([ temp_dir / name for name in ['cle_instance.mzn', 'pdg_instance.mzn', 'enclave_instance.mzn']])
    with open(cle_instance_path, 'w') as f:
        f.write(cle_instance)
    with open(pdg_instance_path, 'w') as f:
        f.write(pdg_instance)
    with open(enclave_instance_path, 'w') as f:
        f.write(enclave_instance)
    mzn_args : List[Union[Path, str]] = [
            'minizinc',
            '--solver',
            'Gecode',
            cle_instance_path,
            enclave_instance_path,
            pdg_instance_path,
            *constraint_files
    ]  
    mzn_out = subprocess.run(mzn_args, capture_output=True, encoding='utf-8')
    if mzn_out.stderr.strip() != '' or mzn_out.returncode != 0:
        raise Exception("minizinc failure", mzn_out)          
    if "UNSATISFIABLE" in mzn_out.stdout:
        findmus_args : List[Union[Path, str]] = [
            'minizinc',
            '--solver',
            'findmus',
            '--subsolver',
            'Gecode',
            '--depth',
            '3',
            '--output-json',
            cle_instance_path,
            enclave_instance_path,
            pdg_instance_path,
            *constraint_files
        ]  
        findmus_out = subprocess.run(findmus_args, capture_output=True, encoding='utf-8')
        if findmus_out.stderr.strip() != '' or findmus_out.returncode != 0:
            raise Exception("minizinc failure", findmus_out)         
        return parse_findmus(findmus_out.stdout, pdg_csv, source_map)
    else:
        return parse_assignment(mzn_out.stdout, pdg_csv, source_map)

        

def parse_assignment(mzn_output: str, pdg_csv: Iterable, source_map: Optional[Dict[Tuple[str, int], Tuple[str, int]]] = None) -> Dict[str, Any]:
    pdg_csv = list(pdg_csv)
    if source_map:
        source_map_resolved = { (Path(kpath).resolve(), kline): (Path(vpath).resolve(), vline) for ((kpath, kline), (vpath, vline)) in source_map.items() }
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
        line_no = int(line)
        source = None if (stripped := source.strip()) == 'Not Found' else stripped
        assert node == node_ 
        match = re.search(r'@((\w|\.)*)', llvm)
        assert match is not None
        name = match.group(1)
        enclaves.add(enclave)
        source, line_no = source_map_resolved[(Path(source).resolve(), line_no)] if source_map else (source, line_no)
        entries.append({ "name": name, "level": enclave, "line": str(line_no) })
        print(f"{name} is in {enclave}{'' if not source else f' at {source}:{str(line_no)}'}")
    
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

def parse_findmus(mzn_output: str, pdg_csv: Iterable, source_map: Optional[Dict[Tuple[str, int], Tuple[str, int]]] = None) -> Dict[str, Any]: 
    pdg_csv = list(pdg_csv)

    if source_map:
        source_map_resolved = { (Path(kpath).resolve(), kline): (Path(vpath).resolve(), vline) for ((kpath, kline), (vpath, vline)) in source_map.items() }

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
                (_, source, _, line) = nodes[node_num - 1] 
                line_no = int(line)
                source, line_no = source_map[(source, line_no)] if source_map else (source, line_no)
                conflicts.append({
                    "name": item['constraint_name'] if item['constraint_name'] != '' else 'Unknown',
                    "description": "TODO",
                    "sources": [
                        {
                            "file": source,
                            "range": {
                                "start": { "line": line_no, "character": -1, },
                                "end": { "line": line_no, "character": -1, }
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
                _, first, second  = edges[edge_num - 1]
                (_, first_source, _, first_line), (_, second_source, _, second_line) = nodes[first - 1], nodes[second - 1]
                first_line_no = int(first_line)
                second_line_no = int(second_line)
                first_source, first_line_no = source_map_resolved[(Path(first_source).resolve(), first_line_no)] if source_map else (first_source, first_line_no)
                second_source, second_line_no = source_map_resolved[(Path(second_source).resolve(), second_line_no)] if source_map else (second_source, second_line_no)
                conflicts.append({
                    "name": item['constraint_name'] if item['constraint_name'] != '' else 'Unknown',
                    "description": item['constraint_name'] if item['constraint_name'] != '' else 'Unknown',
                    "sources": [
                        { 
                            "file": str(first_source), 
                            "range": { 
                                "start": { "line": first_line_no, "character": 0 }, 
                                "end": { "line": first_line_no, "character": 1 }, 
                            },
                        },                 
                        {
                            "file": str(second_source),
                            "range": { 
                                "start": { "line": second_line_no, "character": 0 }, 
                                "end": { "line": second_line_no, "character": 1 }, 
                            },
                        }
                    ],
                    "remedies": [],
                })
    return { "result": "Conflict", "conflicts": conflicts }
       