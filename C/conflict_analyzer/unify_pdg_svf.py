import csv
import argparse
from pathlib import Path
from typing import Dict, List, Tuple

# Current behavior:

# Only integer ID and LLID of SVF nodes are used, other fields are ignored.

# If an LLID from the PDG is not associated with any SVF node,
# there is no error.

# If an LLID associated with an SVF node is not present in the pdg_to_llids,
# there is only an error if the SVF node is used in some edge.

# SVF nodes for 'llvm.*' functions, printf, malloc, and free are ignored,
# along with any edges to and from those nodes. This is because they are
# library functions and are not given an LLID by the pdg opt pass. Other
# library functions may need to be included in this list, depending on
# the example.

CsvData = List[List[str]]
LLId = Tuple[str, str, str] 

def unify_pdg_svf(pdg_csv: CsvData, pdg_ids: CsvData, svf_edges: CsvData, svf_ids: CsvData) -> CsvData:

    newtypes = ['DataDepEdge_PointsTo']
    llid_to_pdg_node = {
        (glob_name, inst_idx, param_idx): node_id 
        for [node_id, glob_name, inst_idx, param_idx, *_] in pdg_ids
    }
    svf_to_llid = {
        node_id: (glob_name, inst_idx, param_idx) 
        for [node_id, *_, glob_name, inst_idx, param_idx] in svf_ids
    }
    externs = {
        glob_name
        for [*_, decl, glob_name, _, _] in svf_ids
        if decl == "declaration"
    }

    def ignore(llid: LLId) -> bool:
        return llid[0][:5] == "llvm." or llid == ("", "", "") or llid[0] in externs   

    # get last id from pdg_csv
    e_id = int(pdg_csv[-1][1]) + 1
    for [src, dst] in svf_edges:
        src_llid, dst_llid = svf_to_llid[src], svf_to_llid[dst]
        if not (ignore(src_llid) or ignore(dst_llid) or src_llid == dst_llid):
            src, dst = llid_to_pdg_node[src_llid], llid_to_pdg_node[dst_llid]
            pdg_csv.append(['Edge', str(e_id), newtypes[0], '0', '', '', src, dst, '', '', '', '', ''])
            e_id = e_id + 1

    return pdg_csv


class Args:
    def __init__(self):
        pass
    pdg_data: Path
    svf_edges: Path
    pdg_ids: Path
    svf_ids: Path

def parsed_args() -> Args:
    parser = argparse.ArgumentParser("unify-pdg-svf")
    parser.add_argument('pdg_data', help="pdg data as a .csv file", 
                        type=Path)
    parser.add_argument('svf_edges', help="svf edges as a .csv file", 
                        type=Path)
    parser.add_argument('pdg_ids', help=".csv file mapping pdg nodes to LLVM IDs", 
                        type=Path)
    parser.add_argument('svf_ids', help=".csv file mapping svf nodes to LLVM IDs", 
                        type=Path)
    args = parser.parse_args(namespace=Args())
    args.pdg_data = args.pdg_data.resolve()
    args.svf_edges = args.svf_edges.resolve()
    args.pdg_ids = args.pdg_ids.resolve()
    args.svf_ids = args.svf_ids.resolve()
    return args

def main() -> None:
    args = parsed_args()
    files = [args.pdg_data, args.pdg_ids, args.svf_edges, args.svf_ids]

    def read_csv(fname: Path) -> CsvData: 
        with open(fname) as f:
            return list(csv.reader(f, quotechar="'", skipinitialspace=True))

    data = [read_csv(file) for file in files]
    unified = unify_pdg_svf(*data)
    with open('pdg_svf_data.csv', "w") as f:
        writer = csv.writer(f, delimiter=",", quotechar="'")
        for r in unified: writer.writerow(r)

if __name__ == "__main__":
    main()