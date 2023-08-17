import csv
import argparse
from pathlib import Path

def unify_pdg_svf(pdg_csv, pdg_ids, svf_edges, svf_ids):

    ignore = lambda llid: llid[0][:5] == "llvm." or llid == ("", "", "") or llid[0] == "printf" or llid[0] == "malloc"
    newtypes = ['DataDepEdge_PointsTo']
    llid_to_pdg_node = {}
    svf_to_llid = {}
    e_id = int(pdg_csv[-1][1]) + 1
    for r in pdg_ids:
        llid_to_pdg_node[(r[1], r[2], r[3])] = r[0]
    for r in svf_ids:
        # TODO: do something with r[1], the 'pointer or non-pointer' value
        svf_to_llid[r[0]] = (r[2], r[3], r[4])
    for r in svf_edges:
        src_llid, dst_llid = svf_to_llid[r[0]], svf_to_llid[r[1]]
        if not (ignore(src_llid) or ignore(dst_llid)):
            src, dst = llid_to_pdg_node[src_llid], llid_to_pdg_node[dst_llid]
            pdg_csv.append(['Edge', str(e_id), newtypes[0], '0', '', '', src, dst, '', '', '', '', ''])
            e_id = e_id + 1
    return pdg_csv

def parsed_args():
    parser = argparse.ArgumentParser("unify-pdg-svf")
    parser.add_argument('pdg_data', help="pdg data as a .csv file", 
                        type=Path)
    parser.add_argument('svf_edges', help="svf edges as a .csv file", 
                        type=Path)
    parser.add_argument('pdg_ids', help=".csv file mapping pdg nodes to LLVM IDs", 
                        type=Path)
    parser.add_argument('svf_ids', help=".csv file mapping svf nodes to LLVM IDs", 
                        type=Path)
    args = parser.parse_args()
    args.pdg_data = args.pdg_data.resolve()
    args.svf_edges = args.svf_edges.resolve()
    args.pdg_ids = args.pdg_ids.resolve()
    args.svf_ids = args.svf_ids.resolve()
    return args

def main():
    args = parsed_args()
    data = []
    files = [args.pdg_data, args.pdg_ids, args.svf_edges, args.svf_ids]
    for fname in files:
        with open(fname) as f:
            data.append(list(csv.reader(f, quotechar="'", skipinitialspace=True)))
    unified = unify_pdg_svf(*data)
    with open('pdg_svf_data.csv', "w") as f:
        writer = csv.writer(f, delimiter=",", quotechar="'")
        for r in unified: writer.writerow(r)

if __name__ == "__main__":
    main()