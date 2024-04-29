from os import PathLike
from pathlib import Path  
import sys
from typing import Callable, Iterator, List, Optional, Tuple, TypeVar
import graphviz
import csv
from dataclasses import dataclass

@dataclass
class Node:
    id: int
    type: str
    pointer: str
    llvm: str
    fn: Optional[str]
    inst_idx: Optional[int]
    param_idx: Optional[int]

    def llid(self) -> str:
        s = ""
        if self.fn:
            s += f"@{self.fn}"
        if self.inst_idx is not None:
            s += f"::{self.inst_idx}"
        if self.param_idx is not None:
            s += f"::%{self.param_idx}"
        return s

@dataclass
class Edge:
    src_id: int
    dst_id: int

A = TypeVar('A')

def read_nodes(node_filename: str) -> List[Node]:
    def none_if_empty(s: str, f: Callable[[str], A]) -> Optional[A]:
        return None if len(s) == 0 else f(s)
        
    with open(node_filename) as node_file:
        node_csv = csv.reader(node_file, quotechar = "'", delimiter=",")
        nodes = (Node(
            int(line[0]), \
                line[1], \
                line[2], \
                line[3], \
                none_if_empty(line[4], lambda x: x), \
                none_if_empty(line[5], int), \
                none_if_empty(line[6], int)) \
                for line in node_csv)
        return list(nodes)
    
     
def read_edges(edge_filename: str) -> List[Edge]:
    with open(edge_filename) as edge_file:
        edge_csv = csv.reader(edge_file, quotechar = "'")
        edges = (Edge(int(line[0]), int(line[1])) for line in edge_csv)
        return list(edges)

def main() -> None:
    node_filename = sys.argv[1]
    edge_filename = sys.argv[2]

    nodes = read_nodes(node_filename)    
    edges = read_edges(edge_filename)    

    dot = graphviz.Digraph(name = 'SVF Points-To Graph')

    for node in nodes:
        llid = node.llid()
        disp = [node.type]
        if llid:
            disp.append(llid)
        else:
            disp.append(node.llvm)
        dot.node(str(node.id), " ".join(disp))

    for edge in edges:
        dot.edge(str(edge.src_id), str(edge.dst_id))

    print(dot.source)

main()