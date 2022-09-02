from dataclasses import dataclass
import re
from typing import Callable, Dict, Optional, Tuple

SourceMap = Callable[[Tuple[str, int]], Tuple[str, int]]


@dataclass
class PdgLookupNode:
    node_type: str
    llvm: str
    source_file: str
    source_line: Optional[int]

    def llvm_name(self) -> Optional[str]:
        match = re.search(r'@((\w|\.)*)', self.llvm)
        if match:
            name = match.group(1)
            return name
        return None

    def with_source_map(self, source_map: SourceMap) -> 'PdgLookupNode':
        line = self.source_line if self.source_line else -1
        source, line = source_map((self.source_file, line))
        return PdgLookupNode(self.node_type, self.llvm, source, line)

@dataclass
class PdgLookupEdge:
    edge_type: str
    src_node_idx: int
    dest_node_idx: int

    def source_node(self, table: 'PdgLookupTable') -> PdgLookupNode:
        return table.nodes[self.src_node_idx]

    def dest_node(self, table: 'PdgLookupTable') -> PdgLookupNode:
        return table.nodes[self.dest_node_idx]

@dataclass 
class PdgLookupTable:
    nodes: Dict[int, PdgLookupNode] 
    edges: Dict[int, PdgLookupEdge] 
    def __init__(self, pdg_csv: list):
        self.nodes = { int(num): PdgLookupNode(type_, llvm, source, int(line) if int(line) != -1 else None) 
            for [node_or_edge, num, type_, _, llvm, *_, source, line, _] 
            in pdg_csv if node_or_edge == 'Node' 
        } 
        self.edges = { int(num): PdgLookupEdge(type_, int(source), int(dest)) 
            for [node_or_edge, num, type_, _, _, _, source, dest, *_] 
            in pdg_csv if node_or_edge == 'Edge' 
        } 

