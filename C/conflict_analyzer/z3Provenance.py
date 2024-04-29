cle_template = "; Fact: "
node_template =       "; NODE\n;     File:     {}\n;     Function: {}\n;     Line:     {}\n;     Label:    {}\n; Rule:\n;     "
edge_template = ("; EDGE FROM\n;     File:     {}\n;     Function: {}\n;     Line:     {}\n;     Label:    {}\n" + 
                        "; TO\n;     File:     {}\n;     Function: {}\n;     Line:     {}\n;     Label:    {}\n; Rule:\n;     ")

rules = {
    "taints":                                "This line was annotated with the given label.",
    "hasLabelLevel":                         "Label {} is at level {}.",
    "isFunctionAnnotation":                  "Label {} is {}a function annotation.",
    "hasGuardOperation":                     "CDF {} has guard operation {}.",
    "hasEnclaveLevel":                       "Enclave {} is at level {}.",
    "cdfForRemoteLevel":                     "Label {} has CDF {} at remote level {}.",
    "hasRettaints":                          "CDF {} {} {} as a rettaint.",
    "hasARCtaints":                          "CDF {} {} {} as an ARCtaint.",
    "hasArgtaints":                          "CDF {} {} {} as an argtaint of argument {}.",
    "VarNodeHasEnclave":                     "Var node must have non-null enclave",
    "FunctionHasEnclave":                    "Function entry node must have non-null enclave",
    "InstHasEnclave":                        "Instruction node must have non-null enclave",
    "ParamHasEnclave":                       "Param node must have non-null enclave",
    "AnnotationHasNoEnclave":                "Node is an annotation so is placed in the null enclave.",
    "NodeLevelAtEnclaveLevel":               "The level of a node's taint must match the level of its enclave",
    "FnAnnotationByUserOnly":                "Only user annotated functions may have function annotations.",
    "UnannotatedFunContentTaintMatch":       "Node must have the same taint as its function, because the function was not annotated.",
    "AnnotatedFunContentCoercible":          "The taint on this line must be in the (annotated) function's ARCtaints.",
    "NonCallControlEnclaveSafe":             "This control edge to an un-annotated node must not be cross-domain.",
    "XDCallBlest":                           "If this call edge is cross-domain, the destination must be an annotated function.",
    "XDCallAllowed":                         "If this call edge is cross-domain, the destination function label must have an ALLOW or REDACT CDF at the level of the source taint.",
    "NonRetNonParmDataEnclaveSafe":          "This is an enclave-safe data edge and may not be cross-domain.",
    "XDCDataReturnAllowed":                  "If this data return edge is cross-domain, the callee's label must have an ALLOW or REDACT CDF at the level of the callsite's taint.",
    "XDCParmAllowed":                        "If this argument-passing data edge is cross-domain, the source function label must have an ALLOW or REDACT CDF at the level of the destination taint.",
    "UnannotatedExternDataEdgeTaintsMatch":  "This is an edge between a function-external node and a node belonging to an un-annotated function, so both nodes must have the same taint.",
    "AnnotatedExternDataEdgeInArctaints1":   "This is an edge between a function-external node and a node belonging to an annotated function, the external node's taint must be in the function ARCtaints.",
    "AnnotatedExternDataEdgeInArctaints2":   "This is an edge between a function-external node and a node belonging to an annotated function, the external node's taint must be in the function ARCtaints.",
    "retEdgeFromUnannotatedTaintsMatch":     "This is a data return edge from an un-annotated callee to a callsite, so the taints must match.",
    "returnNodeInRettaints":                 "This is a data return edge from an annotated callee, so the taint of the callsite must be in the rettaints of the callee (or the edge is cross-domain).",
    "argPassInEdgeToUnannotatedTaintsMatch": "This is an ArgPass_In data edge to an un-annotated function, so the taints must match.",
    "argPassInSourceInArgtaints":            "This is an ArgPass_In data edge to an annotated function, so the incoming taint must be in the argtaints (or it is a cross-domain edge).",
    "argPassOutFromUnannotatedTaintsMatch":  "This is an ArgPass_Out data edge from an un-annotated function, so the taints must match.",
    "argPassOutDestInArgtaints":             "This is an ArgPass_Out data edge from an annotated function, so the destination taint must be in the argtaints (or it is a cross-domain edge).",
    "interFunParameterFieldTaintsMatch":     "This is a Parameter_Field edge between two different functions, so the taints must match.",
    "IndirectCallSameEnclave":               "This is an indirect call invocation edge, so it may not be a cross-domain.",
    "PointsToXD":                            "If this points-to edge is cross-domain, the destination must not be a function entry node, and its taint must have ALLOW or REDACT in the CDF corresponding to the source level.",
    "PointsToTaintsMatch":                   "If this points-to edge is not cross-domain, the taints must match.",
    "GlobalDefUseTaintsMatch":               "This is a def-use edge between two global variables, so the taints must match."
}

def getLine(node_row):
    if node_row[2] == "FunctionEntry":
        return node_row[4].split("@",1)[1].split("{",1)[0]
    return node_row[4]

def node_provenance(node_id, data):
    row = data[node_id - 1]
    fun_id = int(row[5])
    fun = "None"
    if fun_id != 0: fun = getLine(data[fun_id - 1])
    return row[8], fun, getLine(row), row[3]

def edge_provenance(edge_id, data, nn):
    row = data[edge_id - 1 + nn]
    n1, n2 = int(row[6]), int(row[7])
    f1, fun1, line1, label1 = node_provenance(n1, data)
    f2, fun2, line2, label2 = node_provenance(n2, data)
    return f1, fun1, line1, label1, f2, fun2, line2, label2

def explain_single(fml, t, n, args, data, nn):
    assertion = "\n(assert {})".format(fml.sexpr())
    r = rules[n]
    if   t == 'cle':
        return (cle_template + r).format(*args) + assertion
    elif t == 'node':
        return (node_template + r).format(*node_provenance(args, data)) + assertion
    elif t == 'edge':
        return (edge_template + r).format(*edge_provenance(args, data, nn)) + assertion

def explain_all(cs, data):
    s = "; EXPLANATION FOR UNSATISFIABILITY\n"
    num_nodes = len([r for r in data if r[0] == "Node"])
    for (fml, (t, n, args)) in cs: s += "\n{}\n".format(explain_single(fml, t, n, args, data, num_nodes))
    s += "\n(check-sat)"
    return s
