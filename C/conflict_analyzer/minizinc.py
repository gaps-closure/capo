#!/usr/bin/env python3

from dataclasses import dataclass
import os
import re
import subprocess
import json
from pathlib import Path
from typing import Any, Iterable, List, Set, Optional, Dict, Tuple, TypedDict, Union

from .pdg_table import PdgLookupTable, PdgLookupNode
from .exceptions import ProcessException, FindmusException, Mus

class TopologyAssignment(TypedDict):
    name: str
    level: str
    enclave: str
    line: Optional[int]

class Topology(TypedDict):
    source_path: str
    enclaves: List[str]
    levels: List[str]
    global_scoped_vars: List[TopologyAssignment]
    functions: List[TopologyAssignment]


@dataclass 
class Assignment: 
    node: int 
    label: str
    enclave: str
    level: str
    name: Optional[str]
    src: str
    line: Optional[int]

    def source_line(self, source_map: Dict[int, int]) -> Optional[int]:
        if self.line:
            return source_map[self.line] if self.line in source_map else None 
        else:
            return None

@dataclass 
class Solution:
    nodeEnclave: List[str]
    nodeLevel: List[str]
    taint: List[str]
    xdedge: List[bool]


class ArtifactDebug(TypedDict):
    line: Optional[int] 
    name: Optional[str] 

class ArtifactAssignment(TypedDict):
    node: int
    label: str
    enclave: str
    level: str
    debug: ArtifactDebug

ArtifactCut = TypedDict('ArtifactCut', {
    'summary': str,
    'source-node': int,
    'source-label': str,
    'source-enclave': str,
    'dest-node': int,
    'dest-label': str,
    'dest-enclave': str
})

Artifact = TypedDict('Artifact', {
    'source_path': str,
    'function-assignments': List[ArtifactAssignment],
    'variable-assignments': List[ArtifactAssignment],
    'cut': List[ArtifactCut],
    'all-assignments': List[ArtifactAssignment],
})

def str_artifact(artifact: Artifact) -> str:
    s = "{\n"
    for k, v in artifact.items():
        val: Any = v
        if k != "source_path" and k != "cut":
            if len(val) == 0:
                s += f'\t"{k}": [],\n'
            else:
                s += f'\t"{k}": [\n'
                for l in val: 
                    s += f'\t\t{json.dumps(l)},\n'
                s = s[:-2] + "\n"
                s += "\t],\n"
        else:
            s += f'\t"{k}": {json.dumps(v)},\n' 
    s = s[:-2] + "\n}\n"
    return s

@dataclass
class MinizincResult:
    function_assignments: List[Assignment]
    global_var_assignments: List[Assignment]
    other_assignments: List[Assignment]
    pdg_lookup: PdgLookupTable
    solution: Solution
    cut: Optional[List[ArtifactCut]] = None

    def levels(self) -> List[str]:
        return list({assgn.level for assgn in self.function_assignments})

    def enclaves(self) -> List[str]:
        return list({assgn.enclave for assgn in self.function_assignments})

    def topology(self, source_path: os.PathLike) -> Topology:
        def from_assignment(assgn: Assignment) -> TopologyAssignment:
            assert assgn.name is not None
            return {
                "name": assgn.name,
                "level": assgn.level,
                "enclave": assgn.enclave,
                "line": assgn.line,
            } 
        return {
            "source_path": str(source_path),
            "enclaves": self.enclaves(),
            "levels": self.levels(),
            "functions": [ from_assignment(assgn) for assgn in self.function_assignments ],
            "global_scoped_vars": [ from_assignment(assgn) for assgn in self.global_var_assignments ],
        }
    def artifact(self, source_path: os.PathLike) -> Artifact:  
        def from_assignment(assgn: Assignment) -> ArtifactAssignment:
            return {
                "node": assgn.node,
                "label": assgn.label,
                "enclave": assgn.enclave,
                "level": assgn.level,
                "debug": {
                    "line": assgn.line,
                    "name": assgn.name,
                }
            }

        all_assignments = [*self.function_assignments, *self.global_var_assignments, *self.other_assignments]

        def cut() -> List[ArtifactCut]:
            xd_edges = [ edge for i, is_xd in enumerate(self.solution.xdedge)
                if (edge := self.pdg_lookup.edges[i + 1]).edge_type == 'ControlDep_CallInv' and is_xd ]
            assgn_lookup: Dict[int, Assignment] = { assgn.node: assgn for assgn in all_assignments }
            cut: List[ArtifactCut] = [{
                "summary": f"({e.src_node_idx}:{assgn_lookup[e.src_node_idx].label})--[{assgn_lookup[e.src_node_idx].enclave}]--||-->[{assgn_lookup[e.dest_node_idx].enclave}]--({e.dest_node_idx}:{assgn_lookup[e.dest_node_idx].label})",
                "source-node": e.src_node_idx,
                "source-label": assgn_lookup[e.src_node_idx].label,
                "source-enclave": assgn_lookup[e.src_node_idx].enclave,
                "dest-node": e.dest_node_idx,
                "dest-label": assgn_lookup[e.dest_node_idx].label,
                "dest-enclave": assgn_lookup[e.dest_node_idx].enclave,
                }
            for e in xd_edges ]
            return cut

        fun_assgns = [ from_assignment(assgn) for assgn in self.function_assignments ]
        var_assgns = [ from_assignment(assgn) for assgn in self.global_var_assignments ]
        all_assgns = [ from_assignment(assgn) for assgn in all_assignments ]
        return {
            "source_path": str(source_path),
            "function-assignments": fun_assgns,
            "variable-assignments": var_assgns,
            "all-assignments": all_assgns, 
            "cut": self.cut or cut() 
        }


def run_model(instances: List[str], constraint_files: List[Path], 
    pdg_lookup: PdgLookupTable, temp_dir: Path, source_map: Dict[Tuple[str, int], Tuple[str, int]]) -> MinizincResult:

    from minizinc import Instance, Model, Solver
    model = Model(constraint_files)
    gecode = Solver.lookup("gecode")
    instance = Instance(gecode, model)
    for inst in instances:
        instance.add_string(inst)
    result = instance.solve()
    if result.status.has_solution():
        return from_solution(result.solution, pdg_lookup)
    elif result.status == result.status.UNSATISFIABLE:
        res = run_findmus(instances, constraint_files, temp_dir)
        raise FindmusException(res, pdg_lookup, source_map)
    raise RuntimeError("Minizinc return status {result.status}") 

def run_cmdline(instances: List[str], constraint_files: List[Path], 
    pdg_lookup: PdgLookupTable, temp_dir: Path, source_map: Dict[Tuple[str, int], Tuple[str, int]]) -> MinizincResult:
    (temp_dir / 'instance.mzn').write_text("\n".join(instances))    
    
    mzn_args: List[Union[str, os.PathLike]] = [
        'minizinc',
        '--solver',
        'Gecode',
        *constraint_files,
        temp_dir / 'instance.mzn'
    ]
    output = subprocess.run(mzn_args, capture_output=True, encoding='utf-8')
    if output.returncode != 0 or "Error" in output.stdout:
        raise ProcessException("minizinc failure", output)     
    if "UNSATISFIABLE" in output.stdout:
        mus = run_findmus(instances, constraint_files, temp_dir)
        raise FindmusException(mus, pdg_lookup, source_map)
    else:
        soln, cut = parse_solution(output.stdout)
        res = from_solution(soln, pdg_lookup)
        res.cut = cut
        return res

def parse_solution(mzn_out: str) -> Tuple[Solution, List[ArtifactCut]]:
    nodes: Dict[int, Tuple[str, str, str]] = {}
    cut: List[ArtifactCut] = []
    def parse_line(line: str) -> None: 
        parts = [ s.strip() for s in line.split(" ") if s != '' ]
        node, [enclave, label, level] = int(parts[2]), [ s.strip('[]') for s in parts[-1].split('::') ]
        nodes[node] = enclave, label, level

    def parse_xd(line: str) -> Optional[ArtifactCut]:
        # XDCALL   : (2:PURPLE)--[purple_E]--||-->[orange_E]--(74:XDLINKAGE_GET_A)
        reg = r'\((\d+):(\w+)\)--\[(\w+)\]--\|\|-->\[(\w+)\]--\((\d+):(\w+)\)'
        res = re.search(reg, line)
        if res is not None:
            src_node, src_lbl, src_enc, dst_enc, dst_node, dst_lbl = res.groups()
            return {
                "summary": f"({src_node}:{src_lbl})--[{src_enc}]--||-->[{dst_enc}]--({dst_node}:{dst_lbl})",
                "source-node": int(src_node),
                "source-label": src_lbl, 
                "source-enclave": src_enc, 
                "dest-node": int(dst_node), 
                "dest-label": dst_lbl, 
                "dest-enclave": dst_enc 
            }
        else:
            return None

    out = mzn_out.splitlines()
    for line in out:
        if line.find('ASSIGN') != -1:
            parse_line(line)
        elif line.find('XDCALL') != -1:
            c = parse_xd(line)
            if c:
                cut.append(c)
    
    nodes_list = sorted(nodes.items(), key=lambda x: x[0])

    node_enclaves = [ enclave for _, (enclave, _, _) in nodes_list ] 
    node_labels = [ label for _, (_, label, _) in nodes_list ] 
    node_levels = [ level for _, (_, _, level) in nodes_list ] 

    return Solution(node_enclaves, node_levels, node_labels, []), cut
      
def from_solution(soln: Solution, table: PdgLookupTable) -> MinizincResult:
    functions: List[Assignment] = []
    global_vars: List[Assignment] = []
    other: List[Assignment] = []

    for i, (enc, lvl, lbl) in enumerate(zip(soln.nodeEnclave, soln.nodeLevel, soln.taint)):
        node_idx = i + 1
        node = table.nodes[node_idx]

        to_append = functions if node.node_type == 'FunctionEntry' else (global_vars if node.node_type == 'VarNode' else other)
        llvm_name = node.llvm_name()
        to_append.append(Assignment(node_idx, lbl, enc, lvl, llvm_name, node.source_file, node.source_line))

    return MinizincResult(functions, global_vars, other, table, soln)

def run_findmus(strings: List[str], sources: List[Path], temp_dir: Path) -> List[Mus]:
    (temp_dir / 'instance.mzn').write_text("\n".join(strings))
    mzn_args: List[Union[str, os.PathLike]] = [
        'minizinc',
        '--solver',
        'findmus',
        '--subsolver',
        'Gecode',
        '--depth',
        '3',
        '--output-json',
        *sources,
        temp_dir / 'instance.mzn'
    ]
    output = subprocess.run(mzn_args, capture_output=True, encoding='utf-8')
    if output.returncode != 0 or "Error" in output.stdout:
        raise ProcessException("minizinc failure", output)     
    lines = output.stdout.splitlines()
    start_index, end_index = None, None
    for i, line in enumerate(lines):
        if line.find('%%%mzn-json-start') != -1:
            start_index = i
        elif line.find('%%%mzn-json-end') != -1:
            end_index = i
    assert start_index is not None and end_index is not None
    return json.loads("\n".join(lines[start_index+1:end_index]))["constraints"]
