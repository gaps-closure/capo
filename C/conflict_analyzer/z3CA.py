from itertools import count
from numpy import prod
from time import time
from math import log2, ceil

from pathlib import Path
import argparse

from .z3Provenance import explain_all
from .z3CLE import CLE
from .z3PDG import PDG

from z3 import *

class ConflictAnalyzer:

    def __init__(self, pdg, cle, solver_type, minimize):

        self.s = Solver()
        self.pdg = pdg
        self.cle = cle
        self.use_bv = (solver_type == 'bv')
        self.constraints = []
        self.assumptions = []
        self.explanations = {}
        self.status = 'UNSOLVED'
        self.minimize = minimize
        self.encoded = False
        self.encode()

    def assume(self, assumptions):
        self.s.add(assumptions)
        self.assumptions.extend(assumptions)

    def add(self, constraints):
        self.constraints.extend(constraints)

    def solve(self):

        t = time()
        print("solving (using theory: {})...".format("bv" if self.use_bv else "int"))
        if self.status != unsat:
            for (c, ex) in self.constraints:
                self.explanations[c] = ex
            self.status = self.s.check(list(list(zip(*self.constraints))[0]))
        print("\nsolving time (s): {}".format(int(time() - t)))
        return self.status

    def evidence(self, handle):

        if self.status != sat:
            return "No evidence for '{}' status".format(str(self.status))
        print("Dumping model...")
        handle.write(str(self.s.model()))

    def explain(self, handle):

        t = time()
        if self.status != unsat:
            return "Cannot explain '{}' status".format(str(self.status))
        print("determining unsat core explanation (core minimization: {})...".format("on" if self.minimize else "off"))
        core = self.s.unsat_core()
        core_s = Solver()
        if self.minimize:
            core_s.set(':core.minimize', True)
            core_s.add(self.assumptions)
            assert core_s.check([fml for fml in core]) == unsat
            core = core_s.unsat_core()
            core_s = Solver()
        core_s.add(self.assumptions + [fml for fml in core])
        print("unsat core time (s): {}".format(int(time() - t)))
        handle.write(explain_all([(fml, self.explanations[fml]) for fml in core], self.pdg.pdg_csv))

    def encode(self):

        if self.encoded: return
        self.encoded = True
        pdg = self.pdg
        cle = self.cle

        t_start = time()
        def elapsed():
            print("\ntime (s): {}".format(int(time() - t_start)))

        def encodeFail(n):
            print("WARNING: Model inconsistency detected in {}. Instance is unsat.".format(n))
            self.status = unsat

        def log(name, domain):
            pass
            # elapsed()
            # print("{} constraint on {} entries...".format(name, len(domain)))

        # Sorts (sort of IDs may be ints or bitvectors)
        b = BoolSort()
        id = IntSort()
        def mkId(i):
            assert i >= 0
            return i
        if self.use_bv:
            bvl = ceil(log2(pdg.PDGEdge[-1]))
            id = BitVecSort(bvl)
            mkId = lambda i: BitVecVal(i, bvl)
            
        # Decision variables
        nodeEnclave = Function('nodeEnclave', id, cle.Enclave)
        taint = Function('taint', id, cle.Label)
        self.add([(taint(mkId(i)) == cle.label2enum[pdg.node_taints[i]], ('node', 'taints', i)) for i in pdg.node_taints])

        # Helpers
        hasFunction            = lambda n: pdg.hasFunction[n - pdg.PDGNode[0]]
        hasSource              = lambda e: pdg.hasSource[e - pdg.PDGEdge[0]]
        hasDest                = lambda e: pdg.hasDest[e - pdg.PDGEdge[0]]
        hasParamIdx            = lambda n: pdg.hasParamIdx[n - pdg.Param[0]]
        isFunctionEntry        = lambda n: n >= pdg.FunctionEntry[0] and n <= pdg.FunctionEntry[-1]
        isAnnotation           = lambda n: n >= pdg.Annotation[0]    and n <= pdg.Annotation[-1]
        userAnnotatedFunction  = lambda n: isFunctionEntry(n) and pdg.userAnnotatedFunction[n - pdg.FunctionEntry[0]]
        srcFun                 = lambda e: hasFunction(hasSource(e))
        dstFun                 = lambda e: hasFunction(hasDest(e))
        sourceAnnotFun         = lambda e: userAnnotatedFunction(srcFun(e)) if srcFun(e) != 0 else False
        destAnnotFun           = lambda e: userAnnotatedFunction(dstFun(e)) if dstFun(e) != 0 else False
        interFunEdge           = lambda e: srcFun(e) != 0 and dstFun(e) != 0 and srcFun(e) != dstFun(e)
        srcFunExternEdge       = lambda e: srcFun(e) != 0 and dstFun(e) == 0
        destFunExternEdge      = lambda e: dstFun(e) != 0 and srcFun(e) == 0
        externUnannotated      = lambda e: (srcFunExternEdge(e) and not sourceAnnotFun(e)) or (destFunExternEdge(e) and not destAnnotFun(e))
        srcFunExternAnnotated  = lambda e: srcFunExternEdge(e)  and sourceAnnotFun(e)
        destFunExternAnnotated = lambda e: destFunExternEdge(e) and destAnnotFun(e)

        # Arrays as uninterpreted functions
        hasLabelLevel = Function('hasLabelLevel', cle.Label, cle.Level)
        for lbl in range(len(cle.hasLabelLevel)):
            self.add([(hasLabelLevel(cle.LabelCons[lbl]) == cle.hasLabelLevel[lbl], ('cle', 'hasLabelLevel', (str(cle.LabelCons[lbl]), str(cle.hasLabelLevel[lbl]))))])

        isFunctionAnnotation = Function('isFunctionAnnotation', cle.Label, b)
        for lbl in range(len(cle.isFunctionAnnotation)):
            v = cle.isFunctionAnnotation[lbl]
            self.add([(isFunctionAnnotation(cle.LabelCons[lbl]) == v, ('cle', 'isFunctionAnnotation', (str(cle.LabelCons[lbl]), "" if v else "not ")))])

        hasGuardOperation = Function('hasGuardOperation', cle.Cdf, cle.GuardOperation)
        for cdf in range(len(cle.hasGuardOperation)):
            self.add([(hasGuardOperation(cle.CdfCons[cdf]) == cle.hasGuardOperation[cdf], ('cle', 'hasGuardOperation', (str(cle.CdfCons[cdf]), str(cle.hasGuardOperation[cdf]))))])

        hasEnclaveLevel = Function('hasEnclaveLevel', cle.Enclave, cle.Level)
        for enc in range(len(cle.hasEnclaveLevel)):
            self.add([(hasEnclaveLevel(cle.EnclaveCons[enc]) == cle.hasEnclaveLevel[enc], ('cle', 'hasEnclaveLevel', (str(cle.EnclaveCons[enc]), str(cle.hasEnclaveLevel[enc]))))])
        
        cdfForRemoteLevel = Function('cdfForRemoteLevel', cle.Label, cle.Level, cle.Cdf)
        for lbl in range(len(cle.cdfForRemoteLevel)):
            for lvl in range(len(cle.cdfForRemoteLevel[lbl])):
                cdf = cle.cdfForRemoteLevel[lbl][lvl]
                self.add([(cdfForRemoteLevel(cle.LabelCons[lbl], cle.LevelCons[lvl]) == cdf, ('cle', 'cdfForRemoteLevel', (str(cle.LabelCons[lbl]), str(cdf), str(cle.LevelCons[lvl]))))])

        hasRettaints = Function('hasRettaints', cle.Cdf, cle.Label, b)
        for cdf in range(len(cle.hasRettaints)):
            for lbl in range(len(cle.hasRettaints[cdf])):
                v = cle.hasRettaints[cdf][lbl]
                self.add([(hasRettaints(cle.CdfCons[cdf], cle.LabelCons[lbl]) == v, ('cle', 'hasRettaints', (str(cle.CdfCons[cdf]), "has" if v else "does not have", str(cle.LabelCons[lbl]))))])

        hasARCtaints = Function('hasARCtaints', cle.Cdf, cle.Label, b)
        for cdf in range(len(cle.hasARCtaints)):
            for lbl in range(len(cle.hasARCtaints[cdf])):
                v = cle.hasARCtaints[cdf][lbl]
                self.add([(hasARCtaints(cle.CdfCons[cdf], cle.LabelCons[lbl]) == v, ('cle', 'hasARCtaints', (str(cle.CdfCons[cdf]), "has" if v else "does not have", str(cle.LabelCons[lbl]))))])

        hasArgtaints = Function('hasArgtaints', cle.Cdf, id, cle.Label, b)
        for cdf in range(len(cle.hasArgtaints)):
            for i in range(len(cle.hasArgtaints[cdf])):
                for lbl in range(len(cle.hasArgtaints[cdf][i])):
                    v = cle.hasArgtaints[cdf][i][lbl]
                    self.add([(hasArgtaints(cle.CdfCons[cdf], mkId(i), cle.LabelCons[lbl]) == v, ('cle', 'hasArgtaints', (str(cle.CdfCons[cdf]), "has" if v else "does not have", str(cle.LabelCons[lbl]), str(i))))])

        # Shorthands over UIFs
        allowOrRedact = lambda c: Or(hasGuardOperation(c) == cle.allow, hasGuardOperation(c) == cle.redact)
        isInArctaint  = lambda fan, tnt, lvl: If(isFunctionAnnotation(fan), hasARCtaints(cdfForRemoteLevel(fan, lvl), tnt), False)
        xdedge        = lambda e: nodeEnclave(mkId(hasSource(e))) != nodeEnclave(mkId(hasDest(e)))
        esTaint       = lambda e: taint(mkId(hasSource(e)))
        edTaint       = lambda e: taint(mkId(hasDest(e)))
        esFunTaint    = lambda e: taint(mkId(srcFun(e))) if sourceAnnotFun(e) else cle.nullCleLabel
        edFunTaint    = lambda e: taint(mkId(dstFun(e))) if destAnnotFun(e)   else cle.nullCleLabel
        esFunCdf      = lambda e: cdfForRemoteLevel(esFunTaint(e), hasLabelLevel(edTaint(e))) if sourceAnnotFun(e) else cle.nullCdf
        edFunCdf      = lambda e: cdfForRemoteLevel(edFunTaint(e), hasLabelLevel(esTaint(e))) if destAnnotFun(e)   else cle.nullCdf
        ftaint        = lambda n: taint(mkId(hasFunction(n))) if hasFunction(n) != 0 else cle.nullCleLabel

        # Constraints

        ### BASIC

        log('VarNodeHasEnclave', pdg.VarNode)
        self.add([(nodeEnclave(mkId(n)) != cle.nullEnclave, ('node', 'VarNodeHasEnclave', n)) for n in pdg.VarNode])

        log('FunctionHasEnclave', pdg.FunctionEntry)
        self.add([(nodeEnclave(mkId(n)) != cle.nullEnclave, ('node', 'FunctionHasEnclave', n)) for n in pdg.FunctionEntry])

        log('InstHasEnclave', pdg.Inst)
        self.add([(nodeEnclave(mkId(n)) == nodeEnclave(mkId(hasFunction(n))), ('node', 'InstHasEnclave', n)) for n in pdg.Inst])

        log('ParamHasEnclave', pdg.Param)
        self.add([(nodeEnclave(mkId(n)) == nodeEnclave(mkId(hasFunction(n))), ('node', 'ParamHasEnclave', n)) for n in pdg.Param])

        log('AnnotationHasNoEnclave', pdg.Annotation)
        self.add([(nodeEnclave(mkId(n)) == cle.nullEnclave, ('node', 'AnnotationHasNoEnclave', n)) for n in pdg.Annotation])

        log('NodeLevelAtEnclaveLevel', pdg.NonAnnotation)
        self.add([(hasLabelLevel(taint(mkId(n))) == hasEnclaveLevel(nodeEnclave(mkId(n))), ('node', 'NodeLevelAtEnclaveLevel', n)) for n in pdg.NonAnnotation])

        log('FnAnnotationByUserOnly', pdg.NonAnnotation)
        self.add([(isFunctionAnnotation(taint(mkId(n))) == False, ('node', 'FnAnnotationByUserOnly', n)) for n in pdg.NonAnnotation if not userAnnotatedFunction(n)])

        log('UnannotatedFunContentTaintMatch', pdg.NonAnnotation)
        self.add([(taint(mkId(n)) == ftaint(n), ('node', 'UnannotatedFunContentTaintMatch', n)) for n in pdg.NonAnnotation if hasFunction(n) != 0 and not userAnnotatedFunction(hasFunction(n))])

        log('AnnotatedFunContentCoercible', pdg.NonAnnotation)
        self.add([(isInArctaint(ftaint(n), taint(mkId(n)), hasLabelLevel(taint(mkId(n)))), ('node', 'AnnotatedFunContentCoercible', n)) for n in pdg.NonAnnotation if hasFunction(n) != 0 and (not isFunctionEntry(n)) and userAnnotatedFunction(hasFunction(n))])

        ### CONTROL/DATA NEVER LEAVES ENCLAVE EXCEPT BY VALID XDC

        log('NonCallControlEnclaveSafe', pdg.ControlDep_NonCall)
        self.add([(xdedge(e) == False, ('edge', 'NonCallControlEnclaveSafe', e)) for e in pdg.ControlDep_NonCall if not isAnnotation(hasDest(e))])

        log('XDCallBlest', pdg.ControlDep_CallInv)
        self.add([(Implies(xdedge(e), userAnnotatedFunction(hasDest(e))), ('edge', 'XDCallBlest', e)) for e in pdg.ControlDep_CallInv])

        log('XDCallAllowed', pdg.ControlDep_CallInv)
        self.add([(Implies(xdedge(e), allowOrRedact(cdfForRemoteLevel(edTaint(e), hasLabelLevel(esTaint(e))))), ('edge', 'XDCallAllowed', e)) for e in pdg.ControlDep_CallInv])

        log('NonRetNonParmDataEnclaveSafe', pdg.DataEdgeEnclaveSafe)
        self.add([(xdedge(e) == False, ('edge', 'NonRetNonParmDataEnclaveSafe', e)) for e in pdg.DataEdgeEnclaveSafe])

        log('XDCDataReturnAllowed', pdg.DataDepEdge_Ret)
        self.add([(Implies(xdedge(e), allowOrRedact(cdfForRemoteLevel(esTaint(e), hasLabelLevel(edTaint(e))))), ('edge', 'XDCDataReturnAllowed', e)) for e in pdg.DataDepEdge_Ret])

        argpass_all = pdg.DataDepEdge_ArgPass_In + pdg.DataDepEdge_ArgPass_Out
        log('XDCParmAllowed', argpass_all)
        self.add([(Implies(xdedge(e), allowOrRedact(cdfForRemoteLevel(esTaint(e), hasLabelLevel(edTaint(e))))), ('edge', 'XDCParmAllowed', e)) for e in argpass_all])

        ### TAINT PROPAGATION

        log('UnannotatedExternDataEdgeTaintsMatch', pdg.DataDepEdge)
        self.add([(esTaint(e) == edTaint(e), ('edge', 'UnannotatedExternDataEdgeTaintsMatch', e)) for e in pdg.DataDepEdge if externUnannotated(e)])

        log('AnnotatedExternDataEdgeInArctaints', pdg.DataDepEdge)
        self.add([(isInArctaint(esFunTaint(e), edTaint(e), hasLabelLevel(edTaint(e))), ('edge', 'AnnotatedExternDataEdgeInArctaints1', e)) for e in pdg.DataDepEdge if srcFunExternAnnotated(e)])
        self.add([(isInArctaint(edFunTaint(e), esTaint(e), hasLabelLevel(esTaint(e))), ('edge', 'AnnotatedExternDataEdgeInArctaints2', e)) for e in pdg.DataDepEdge if destFunExternAnnotated(e)])

        all_ret_edge = pdg.DataDepEdge_Ret + pdg.DataDepEdge_Indirect_Ret
        log('retEdgeFromUnannotatedTaintsMatch', all_ret_edge)
        self.add([(esTaint(e) == edTaint(e), ('edge', 'retEdgeFromUnannotatedTaintsMatch', e)) for e in all_ret_edge if not sourceAnnotFun(e)])

        log('returnNodeInRettaints', all_ret_edge)
        self.add([(Or(hasRettaints(esFunCdf(e), edTaint(e)), xdedge(e)), ('edge', 'returnNodeInRettaints', e)) for e in all_ret_edge if sourceAnnotFun(e)])

        all_arg_in = pdg.DataDepEdge_ArgPass_In + pdg.DataDepEdge_ArgPass_Indirect_In
        log('argPassInEdgeToUnannotatedTaintsMatch', all_arg_in)
        self.add([(esTaint(e) == edTaint(e), ('edge', 'argPassInEdgeToUnannotatedTaintsMatch', e)) for e in all_arg_in if not destAnnotFun(e)])

        log('argPassInSourceInArgtaints', all_arg_in)
        self.add([(Or(hasArgtaints(edFunCdf(e), mkId(hasParamIdx(hasDest(e))), esTaint(e)), xdedge(e)), ('edge', 'argPassInSourceInArgtaints', e)) for e in all_arg_in if destAnnotFun(e)])

        all_arg_out = pdg.DataDepEdge_ArgPass_Out + pdg.DataDepEdge_ArgPass_Indirect_Out
        log('argPassOutFromUnannotatedTaintsMatch', all_arg_out)
        self.add([(esTaint(e) == edTaint(e), ('edge', 'argPassOutFromUnannotatedTaintsMatch', e)) for e in all_arg_out if not sourceAnnotFun(e)])

        log('argPassOutDestInArgtaints', all_arg_out)
        self.add([(Or(hasArgtaints(esFunCdf(e), mkId(hasParamIdx(hasSource(e))), edTaint(e)), xdedge(e)), ('edge', 'argPassOutDestInArgtaints', e)) for e in all_arg_out if sourceAnnotFun(e)])

        log('interFunParameterFieldTaintsMatch', pdg.Parameter_Field)
        self.add([(Or(esTaint(e) == edTaint(e), xdedge(e)), ('edge', 'interFunParameterFieldTaintsMatch', e)) for e in pdg.Parameter_Field if interFunEdge(e)])

        log('IndirectCallSameEnclave', pdg.ControlDep_Indirect_CallInv)
        self.add([(xdedge(e) == False, ('edge', 'IndirectCallSameEnclave', e)) for e in pdg.ControlDep_Indirect_CallInv])

        log('PointsToXD', pdg.DataDepEdge_PointsTo)
        self.add([(Implies(xdedge(e), And(allowOrRedact(cdfForRemoteLevel(edTaint(e), hasLabelLevel(esTaint(e)))), (isFunctionEntry(hasDest(e)) == False))), ('edge', 'PointsToXD', e)) for e in pdg.DataDepEdge_PointsTo])

        log('PointsToTaintsMatch', pdg.DataDepEdge_PointsTo)
        self.add([(Implies(xdedge(e) == False, esTaint(e) == edTaint(e)), ('edge', 'PointsToTaintsMatch', e)) for e in pdg.DataDepEdge_PointsTo])

        log('GlobalDefUseTaintsMatch', pdg.DataDepEdge_GlobalDefUse)
        self.add([(esTaint(e) == edTaint(e), ('edge', 'GlobalDefUseTaintsMatch', e)) for e in pdg.DataDepEdge_GlobalDefUse])

        log('FunctionPtrSinglyTainted', pdg.DataDepEdge_PointsTo)
        for e in pdg.DataDepEdge_PointsTo:
            if isFunctionEntry(hasDest(e)) and userAnnotatedFunction(hasDest(e)):
                encodeFail("FunctionPtrSinglyTainted")

        log('IndirectCalleeSinglyTainted', pdg.ControlDep_Indirect_CallInv)
        for e in pdg.ControlDep_Indirect_CallInv:
            if userAnnotatedFunction(hasDest(e)):
                encodeFail("IndirectCalleeSinglyTainted")

        elapsed()
    
def get_args():
    parser = argparse.ArgumentParser("z3ca")
    parser.add_argument('--pdg-csv',        required=True, type=Path, help="pdg data as a .csv file")
    parser.add_argument('--cle-json',       required=True, type=Path, help='collated CLE JSON')
    parser.add_argument('--max-fn-params',  required=True, type=int,  help="maximum number of function parameters")
    parser.add_argument('--function-args',  required=True, type=Path, help='function args text file')
    parser.add_argument('--one-way',        required=True, type=Path, help='one way text file')
    parser.add_argument('--solver',         required=True, type=str,  help="'bv' or 'int'")
    parser.add_argument('-minimize-core',   required=False, action='store_true', help="minimize the unsat core")
    parser.add_argument('-log-constraints', required=False, action='store_true', help="write instance to constraints.smt2 (takes a while)")
    args = parser.parse_args()
    args.pdg_csv = args.pdg_csv.resolve()
    return args

def main():

    # Parse args
    args = get_args()

    # Get instances
    print("reading instances from files...")
    pdg = PDG(args.pdg_csv, args.max_fn_params)
    cle = CLE(args.cle_json, args.function_args, args.max_fn_params, args.one_way)

    # Encode constraints
    print("encoding...")
    ca = ConflictAnalyzer(pdg, cle, args.solver, args.minimize_core)

    # Write constraints
    if args.log_constraints:
        print("building sexpr...")
        exp = ca.s.sexpr()
        print("dumping sexpr to constraints.smt2...")
        with open('constraints.smt2', 'w') as out: out.write(exp)

    # Solve
    res = ca.solve()

    # Write results
    print(str(res))
    if res == sat:
        with open('model.txt', 'w') as out: 
            ca.evidence(out)
        print("see 'model.txt' for solution")
    else:
        with open('explain.smt2', 'w') as out:          
            ca.explain(out)
        print("see 'explain.smt2' for unsat core and explanation")

if __name__ == '__main__':
    main()

'''
python3 build/capo/C/conflict_analyzer/z3CA.py \
    --pdg-csv=eop2-closure-mind-demo/websrv/annotated-working/pdg_svf_data.csv \
    --cle-json=eop2-closure-mind-demo/websrv/annotated-working/collated.json \
    --max-fn-params=9 \
    --function-args=eop2-closure-mind-demo/websrv/annotated-working/functionArgs.txt \
    --one-way=eop2-closure-mind-demo/websrv/annotated-working/oneway.txt \
    --solver=int \
    -minimize-core
'''