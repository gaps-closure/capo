from collections import OrderedDict
from dataclasses import dataclass
from pathlib import Path
import re
from subprocess import CompletedProcess
from typing import Dict, List, Optional, Tuple, TypedDict, Union
from .pdg_table import PdgLookupTable, PdgLookupNode

class Mus(TypedDict):
    leaf_name: str
    name: str
    path: str
    assigns: str
    constraint_name: str
    expression_name: str

@dataclass
class Position:
    line: int
    character: Optional[int]

@dataclass
class Range:
    start: Position
    end: Optional[Position]

@dataclass
class Source:
    path: Path
    range: Optional[Range]

class SourcedException(Exception):
    def __init__(self, message: str, sources: List[Source]):
        self.message = message
        self.sources = sources

    def __str__(self):
        out = [] 
        out.append(f"Error: {self.message}")
        is_long = len(self.message.splitlines()) > 1
        if is_long:
            out.append("")
        for source in self.sources:
            range_msg = f":{source.range.start.line}" if source.range else "" 
            where = 'at' if source.range else 'in' 
            if is_long:
                out.append(f"{where} {str(source.path)}{range_msg}")
            else:
                out.append(f"\t{where} {str(source.path)}{range_msg}")
        return "\n".join(out)

class ProcessException(Exception):
    def __init__(self, message: str, proc: CompletedProcess):
        self.message = message
        self.proc = proc
    
    def __str__(self):
        return f"\n\n{self.message} with returncode {self.proc.returncode}:\n{self.proc.stdout}\n{self.proc.stderr}" 

def parse_assign(mus: Mus) -> Tuple[bool, int]:
    match = re.match(r'(\w+)=(\d+)', mus['assigns'])
    assert match is not None
    node_or_edge, num = match.groups()
    return node_or_edge == 'e', int(num)

class PositionJSON(TypedDict):
    line: int 
    character: int 

class RangeJSON(TypedDict):
    start: PositionJSON
    end: PositionJSON

class SourceJSON(TypedDict):
    file: str
    range: RangeJSON 

class ConflictJSON(TypedDict):
    name: str
    description: str 
    source: List[SourceJSON]
    remedy: List[str] 

Diag = Union[PdgLookupNode, Tuple[PdgLookupNode, PdgLookupNode]]
Diags = Dict[str, List[Diag]]
class FindmusException(Exception):
    def __init__(self, mus: List[Mus], table: PdgLookupTable, source_map: Dict[Tuple[str, int], Tuple[str, int]]): 
        votes: Dict[str, Tuple[int, List[Mus]]] = OrderedDict() 
        for m in mus:
            if m['constraint_name'] in votes:
                v, ms = votes[m['constraint_name']]
                votes[m['constraint_name']] = v + 1, [m, *ms]
            else:
                votes[m['constraint_name']] = 0, [m]

        diags: Diags = OrderedDict() 
        for cname, (v, ms) in votes.items():
            assigns = [ parse_assign(m) for m in ms ]
            for is_edge, idx in assigns:
                if cname not in diags:
                    diags[cname] = []
                if is_edge:
                    edge = table.edges[idx]
                    source_node = edge.source_node(table).with_source_map(source_map)
                    dest_node = edge.dest_node(table).with_source_map(source_map)
                    diags[cname].append((source_node, dest_node))
                else:
                    node = table.nodes[idx] 
                    diags[cname].append(node)
        self.votes = votes
        self.diags = diags
        self.source_map = source_map
    def __str__(self):
        def show_diag(diag: Diag) -> str:
            if type(diag) == tuple:
                source, dest = diag
                return f"({source.node_type}) {source.source_file}@{source.llvm_name()}:{source.source_line}" + \
                    f" -> ({dest.node_type}) {dest.source_file}@{dest.llvm_name()}:{dest.source_line}" 
            elif isinstance(diag, PdgLookupNode):
                node: PdgLookupNode = diag 
                return f"({node.node_type}) {node.source_file}@{node.llvm_name()}:{node.source_line}"
            raise RuntimeError("Impossible case in show_diag")
            
        msg = [ cname + "\n\t\t" + "\n\t\t".join([ show_diag(d) for d in ds ]) for cname, ds in self.diags.items() ]
        return '\nMUS involving constraints:\n\t' + "\n\t".join(msg)

    def to_conflict_json_list(self) -> List[ConflictJSON]: 
        def to_source(pdg_node: PdgLookupNode) -> SourceJSON:
            return {
                "file": pdg_node.source_file,
                "range": {
                    "start": {
                        "line": pdg_node.with_source_map(self.source_map).source_line or -1,
                        "character": -1 
                    },
                    "end": {
                        "line": pdg_node.with_source_map(self.source_map).source_line or -1,
                        "character": -1
                    }
                }
            }
        def from_diag(name: str, diag: Diag) -> ConflictJSON:
            if type(diag) == tuple:
                source, dest = diag
                return {
                    "name": name,
                    "description": "TODO",
                    "source": [to_source(source), to_source(dest)],
                    "remedy": []
                }
            elif isinstance(diag, PdgLookupNode):
                return {
                    "name": name,
                    "description": "TODO",
                    "source": [to_source(diag)],
                    "remedy": []
                }
            else:
                raise RuntimeError("Impossible case in from_diag")
        out = []
        for name, diags in self.diags.items():
            for diag in diags:
               out.append(from_diag(name, diag)) 
        return out