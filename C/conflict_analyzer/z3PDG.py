import csv
import sys

from z3 import *

class PDG:

    def __init__(self, f_pdg_csv, max_fn_params):

        # read in csv data
        csv.field_size_limit(sys.maxsize)
        with open(f_pdg_csv) as f:
            self.pdg_csv = list(csv.reader(f, quotechar="'", skipinitialspace=True))

        # Node and edge types and sub types, ordered
        node_edge_types = [
            ("Inst", ["FunCall", "Ret", "Br", "Other"]),
            ("VarNode", ["StaticGlobal", "StaticModule", "StaticFunction", "StaticOther"]),
            (None, ["FunctionEntry"]),
            ("Param", ["FormalIn", "FormalOut", "ActualIn", "ActualOut"]),
            ("Annotation", ["Var", "Global", "Other"]),
            ("ControlDep", ["CallInv", "Indirect_CallInv", "CallRet", "Entry", "Br", "Other"]),
            ("DataDepEdge", ["DefUse", "GlobalDefUse", "RAW", "Ret", "Indirect_Ret", "Alias", 
                            "ArgPass_In", "ArgPass_Out", "ArgPass_Indirect_In", 
                            "ArgPass_Indirect_Out", "Callee"]),
            ("Parameter", ["In", "Out", "Field"]),
            ("Anno", ["Global", "Var", "Other"]),
            (None, ["DataDepEdge_PointsTo"])
        ]

        self.MaxFuncParms = max_fn_params
        self.hasFunction = []
        self.hasSource = []
        self.hasDest = []
        self.hasParamIdx = []
        self.userAnnotatedFunction = []
        self.node_taints = {}

        # Generate node and edge sets, store relations
        instance = {}
        i = 0
        edges_start = 0
        def addSet(t, start, end): instance[t] = (start, end)
        for ty, sub_ts in node_edge_types:
            type_start = i + 1
            for sub_t in sub_ts:
                t = sub_t
                if ty: t = ty + "_" + sub_t
                subtype_start = i + 1
                present = False
                while i < len(self.pdg_csv) and self.pdg_csv[i][2] == t:
                    e = self.pdg_csv[i]
                    present = True
                    mzn_id = i + 1 - edges_start
                    assert mzn_id == int(e[1])
                    if ty == "Param":
                        p_idx = int(e[12])
                        self.hasParamIdx.append(p_idx)
                    if t == "FunctionEntry":
                        self.userAnnotatedFunction.append(e[3] != "")
                    if edges_start == 0:
                        self.hasFunction.append(int(e[5]))
                        if e[3] != "": self.node_taints[mzn_id] = e[3]
                    else:
                        self.hasSource.append(int(e[6]))
                        self.hasDest.append(int(e[7]))
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

        # Initialize domains of node/edge types
        getDomain = lambda s: list(range(instance[s][0], instance[s][1] + 1))

        self.Inst_FunCall         = getDomain('Inst_FunCall')
        self.Inst                 = getDomain('Inst')
        self.VarNode_StaticGlobal = getDomain('VarNode_StaticGlobal')
        self.VarNode_StaticModule = getDomain('VarNode_StaticModule')
        self.VarNode              = getDomain('VarNode')
        self.FunctionEntry        = getDomain('FunctionEntry')
        self.Param_ActualIn       = getDomain('Param_ActualIn')
        self.Param_ActualOut      = getDomain('Param_ActualOut')
        self.Param                = getDomain('Param')
        self.Annotation           = getDomain('Annotation')
        self.PDGNode              = getDomain('PDGNode')

        self.ControlDep_CallInv          = getDomain('ControlDep_CallInv')
        self.ControlDep_Indirect_CallInv = getDomain('ControlDep_Indirect_CallInv')
        self.ControlDep_CallRet          = getDomain('ControlDep_CallRet')
        self.ControlDep_Entry            = getDomain('ControlDep_Entry')
        self.ControlDep_Br               = getDomain('ControlDep_Br')
        self.ControlDep_Other            = getDomain('ControlDep_Other')

        self.DataDepEdge_DefUse               = getDomain('DataDepEdge_DefUse')
        self.DataDepEdge_GlobalDefUse         = getDomain('DataDepEdge_GlobalDefUse')
        self.DataDepEdge_RAW                  = getDomain('DataDepEdge_RAW')
        self.DataDepEdge_Ret                  = getDomain('DataDepEdge_Ret')
        self.DataDepEdge_Indirect_Ret         = getDomain('DataDepEdge_Indirect_Ret')
        self.DataDepEdge_Alias                = getDomain('DataDepEdge_Alias')
        self.DataDepEdge_ArgPass_In           = getDomain('DataDepEdge_ArgPass_In')
        self.DataDepEdge_ArgPass_Out          = getDomain('DataDepEdge_ArgPass_Out')
        self.DataDepEdge_ArgPass_Indirect_In  = getDomain('DataDepEdge_ArgPass_Indirect_In')
        self.DataDepEdge_ArgPass_Indirect_Out = getDomain('DataDepEdge_ArgPass_Indirect_Out')
        self.DataDepEdge_Callee               = getDomain('DataDepEdge_Callee')
        self.DataDepEdge_PointsTo             = getDomain('DataDepEdge_PointsTo')
        self.DataDepEdge                      = getDomain('DataDepEdge')

        self.Parameter       = getDomain('Parameter')
        self.Parameter_In    = getDomain('Parameter_In')
        self.Parameter_Out   = getDomain('Parameter_Out')
        self.Parameter_Field = getDomain('Parameter_Field')
        self.PDGEdge         = getDomain('PDGEdge')

        self.Global              = self.VarNode_StaticGlobal + self.VarNode_StaticModule
        self.NonAnnotation       = self.Inst + self.VarNode + self.FunctionEntry + self.Param
        self.ControlDep_NonCall  = self.ControlDep_Entry + self.ControlDep_Br + self.ControlDep_Other
        self.DataEdgeEnclaveSafe = (self.DataDepEdge_DefUse + self.DataDepEdge_GlobalDefUse
                                 +  self.DataDepEdge_RAW + self.DataDepEdge_Indirect_Ret + self.DataDepEdge_Alias 
                                 +  self.DataDepEdge_ArgPass_Indirect_In + self.DataDepEdge_ArgPass_Indirect_Out)