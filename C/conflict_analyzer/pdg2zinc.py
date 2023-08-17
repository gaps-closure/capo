import csv
import argparse
from pathlib import Path

def pdg_to_zinc(pdg_csv, max_fn_parms):

    # Node and edge types and sub types, ordered
    node_edge_types = [
        ("Inst", ["FunCall", "Ret", "Br", "Other"]),
        ("VarNode", ["StaticGlobal", "StaticModule", "StaticFunction", "StaticOther"]),
        (None, ["FunctionEntry"]),
        ("Param", ["FormalIn", "FormalOut", "ActualIn", "ActualOut"]),
        ("Annotation", ["Var", "Global", "Other"]),
        ("ControlDep", ["CallInv", "Indirect_CallInv", "CallRet", "Entry", "Br", "Other"]),
        ("DataDepEdge", ["DefUse", "RAW", "Ret", "Alias"]),
        ("Parameter", ["In", "Out", "Field"]),
        ("Anno", ["Global", "Var", "Other"]),
        (None, ["DataDepEdge_PointsTo"])
    ]

    instance = []
    hasFunction = []
    hasSource = []
    hasDest = []
    hasParamIdx = []
    userAnnotatedFunction = []
    taintConstraints = {}

    # Generate node and edge sets, store relations
    i = 0
    edges_start = 0
    def addSet(t, start, end):
        instance.append("{}_start = {};".format(t, start))
        instance.append("{}_end = {};".format(t, end))
    for ty, sub_ts in node_edge_types:
        type_start = i + 1
        for sub_t in sub_ts:
            t = sub_t
            if ty: t = ty + "_" + sub_t
            subtype_start = i + 1
            present = False
            while i < len(pdg_csv) and pdg_csv[i][2] == t:
                e = pdg_csv[i]
                present = True
                mzn_id = i + 1 - edges_start
                assert mzn_id == int(e[1])
                if ty == "Param":
                    p_idx = int(e[12])
                    hasParamIdx.append(str(p_idx) if p_idx == -1 else str(p_idx + 1))
                if t == "FunctionEntry":
                    userAnnotatedFunction.append(str(e[3] != "").lower())
                if edges_start == 0:
                    hasFunction.append(e[5])
                    if e[3] != "": taintConstraints[mzn_id] = e[3]
                else:
                    hasSource.append(e[6])
                    hasDest.append(e[7])
                i += 1
            if present: addSet(t, subtype_start - edges_start, i - edges_start)
            else:       addSet(t, 0, -1)
        if ty:
            addSet(ty, type_start - edges_start, i - edges_start)
        if ty == "Annotation":
            addSet("PDGNode", 1, i)
            edges_start = i
        elif (ty, sub_ts) == node_edge_types[-1]:
            addSet("PDGEdge", 1, i - edges_start)

    # Generate relations
    def addArr(n, entries):
        instance.append("{} = [".format(n))
        instance.append(",".join(entries))
        instance.append("];")
    def add1dArr(n, index, entries):
        instance.append("{} = array1d({}, [".format(n, index))
        instance.append(",".join(entries))
        instance.append("]);")
    addArr("hasFunction", hasFunction)
    addArr("hasSource", hasSource)
    addArr("hasDest", hasDest)
    add1dArr("hasParamIdx", "Param", hasParamIdx)
    add1dArr("userAnnotatedFunction", "FunctionEntry", userAnnotatedFunction)

    # Max function parameters
    instance.append("MaxFuncParms = {};".format(max_fn_parms))

    # Taint constraints
    for n in taintConstraints:
        tnt = taintConstraints[n]
        instance.append('constraint :: "TaintOnNodeIdx{}" taint[{}]={};'.format(n, n, tnt))

    return "\n".join(instance)

def parsed_args():
    parser = argparse.ArgumentParser("pdg2zinc") 
    parser.add_argument('pdg_data', help="pdg data as a .csv file", 
                        type=Path)
    parser.add_argument('max_fn_params', help="maximum number of function parameters", 
                        type=int)
    args = parser.parse_args()
    args.pdg_data = args.pdg_data.resolve()
    return args

def main():
    args = parsed_args()
    with open(args.pdg_data) as f:
        pdg_data = list(csv.reader(f, quotechar="'", skipinitialspace=True))
    mzn = pdg_to_zinc(pdg_data, args.max_fn_params)
    with open('pdg_svf_instance.mzn', 'w') as f:
        f.write(mzn)

if __name__ == "__main__":
    main()