#!/usr/bin/python3

import networkx                  as     nx
from   networkx.drawing.nx_pydot import read_dot, write_dot
from   constraint                import Problem
from   minizinc                  import Model,Solver,Instance
from   argparse                  import ArgumentParser
import json

def test_toy_python_constraint():
  def func1(a): return a < 0
  p = Problem()
  p.addVariable("a", [-1,-2,0,1,2])
  p.addConstraint(func1,["a"])
  result = p.getSolutions()
  print(result)

def test_toy_minizinc():
  model = Model()
  model.add_string('''
    var -2..2: a;
    constraint a < 0;
    solve satisfy;
    ''')
  gecode = Solver.lookup("gecode")
  inst = Instance(gecode, model)
  result = inst.solve(all_solutions=True)
  print([{"a":result[i, "a"]} for i in range(len(result))])

def constraint_solve_minizinc(modstr):
  model  = Model()
  model.add_string(modstr)
  gecode = Solver.lookup("gecode")
  inst   = Instance(gecode, model)
  return inst.solve()

def process_cle_json(fname):
  with open(fname, 'r') as cjf:
    cledat = json.load(cjf)
  lb = []
  lv = []
  for x in cledat: 
    lb.append(x['cle-label'])
    lv.append(x['cle-json']['level'])
  return lb,lv

def get_args():
  p = ArgumentParser(description='CLOSURE Compliant Partition Feasibility Analyzer')
  p.add_argument('-c', '--clejson', required=True, type=str, help='Input CLE-JSON file')
  #p.add_argument('-p', '--program', required=True, type=str, help='Program data file')
  #p.add_argument('-o', '--outfile', required=True, type=str, help='Output topology file')
  return p.parse_args()

# Details to be automatically gleaned from CLE
labels = ['PURPLE', 'ORANGE', 'ORANGE_SHAREABLE']
levels = ['purple', 'orange']

level_of = {}
level_of['PURPLE'] = 'purple'
level_of['ORANGE'] = 'orange'
level_of['ORANGE_SHAREABLE'] = 'orange'

allowed_flows=[
  ('ORANGE_SHAREABLE', 'orange', 'purple'),
  ('ORANGE_SHAREABLE', 'orange', 'orange'),
  ('PURPLE',           'purple', 'purple'),
  ('ORANGE',           'orange', 'orange')
]

# XXX: capture allowed argument/return allowed taints here

#########################################################################
# Details to be automatically gleaned from program instance
funcs    = ['calc_ewma','get_a','get_b','get_ewma','ewma_main','main']
gvars    = []

annlvars = ['get_a.a','get_b.b']

annot_of   = {}
annot_of['calc_ewma'] = 'ORANGE_SHAREABLE'
annot_of['get_ewma']  = 'ORANGE_SHAREABLE'
annot_of['ewma_main'] = 'PURPLE'
annot_of['get_a.a']   = 'ORANGE'
annot_of['get_b.b']   = 'ORANGE'

# pdgnodes  = [] # XXX: must get from LLVM IR
# pdglinks  = [] # XXX: must get from LLVM IR

annlvartaints = [
  ('get_a.a', 'get_a'),
  ('get_b.b', 'get_b')
] 

# def propagate_taints(assufuncs)
# def allowed_flow(label,level,remotelevel):
#   return label,level,remotelevel in allowed_flows

#############################################################################################################
# Create custom constraint functions for solver to apply 
#############################################################################################################

# Constraint: assigned level must match annotation level if any
def noAnnotationConflict(*x):
  cvar = funcs + gvars
  assg = [levels[q] for q in x]
  for j in range(len(x)):
    if cvar[j] in annot_of and level_of[annot_of[cvar[j]]] != assg[j]: return False
  return True

# Constraint: check if assigned level violates annotation of local variable
# XXX: must check function blessing for resolution 
def noAnnotatedLocalVarConflict(*x):
  cvar = funcs + gvars
  assg = [levels[q] for q in x]
  for j in range(len(x)):
    for x,y in annlvartaints:
      if   cvar[j] == x:
        if assg[j] != level_of[annot_of[y]]: return False
      elif cvar[j] == y:
        if assg[j] != level_of[annot_of[x]]: return False
  return True

#############################################################################################################
if __name__ == '__main__':
  args = get_args()
  p = Problem()

  # extract security constraints for annotations
  # lb,lv=process_cle_json(args.clejson)
  # in this example, we have hard-coded it above

  # extract details from annotated program instance
  # in this example, we have hard-coded it above

  # create constraint variable for each function and global variable for level assignment
  p.addVariables(funcs + gvars, list(range(len(levels))))

  # add custom constraints to capture partitioning feasibility
  # in this constraint, we check the assigned levels do not conflict with explicit annotations
  p.addConstraint(noAnnotationConflict, funcs + gvars)

  # in this constraint, we check the assigned levels do not conflict with annotations on local variables
  p.addConstraint(noAnnotatedLocalVarConflict, funcs)

  # propagate taints based on assignment and make sure they do not lead to conflict
  # p.addConstraint(noTaintConflict, funcs + gvars)

  # if conflicts are resolvable through cross-domain RPC
  # p.addConstraint(conflictResolvableByRPC, funcs + gvars)

  # Solve and print solutions
  result = p.getSolutions()
  for r in result:
    print({a:levels[b] for a,b in r.items()})

#############################################################################################################
'''
Create a logic-variable for each variable and function in the program
o  Maintain a map between the logic variable, the corresponding program entity, and its metadata (e.g., source file reference)

Define predicates
o  function(?fn)
o  global-var(?gv)
o  local-var(?lv)
o  level-of(?label, ?level)
o  allow-sharing(?label, ?fromlevel, ?tolevel)
o  label-taint(?x, ?label)     // ?x is function, global-var or local-var
o  level-taint(?x, ?level)    // --ditto--
o  allowed-taint(?fn,?argnum,?dir, ?label) // return is argnum 0; dir is in, out, or inout
o  link(?x,?y,?linktyp) 
o  conflict(?x,?y,?linktyp)
o  resolved(?x,?y,?linktyp)

Initialize:
o  Assert the function, global-var, and local-var predicates from the program instance
o  For each cle definition, assert level-of, allow-sharing, and allowed-taint if applicable
o  For each annotated variable and function, assert the label-taint and level-taint predicates
o  For each link in PDG, assert link

Define constraint propagation rules (actions):
o  link(?x,?y,?linktyp) && label-taint(?x,?l1l) &&  label-taint(?y,?l2) && <foo> => label-taint()
o  similar for level-taint
o  link(?x,?y,?linktyp) && <bar> => conflict(?x,?y,?linktyp)
o  conflict(?x,?y,?linktyp) && <baz> => resolved(?x,?y,?linktyp)
o  and
        forall link(?x,?y,?linktyp):
              or
                      not conflict (?x,?y,?linktyp)
                       resolved(?x,?y,?linktyp) 
         forall ?x:
               and
                       or function(?x) global-var(?x)
                       exists-unique level-taint(?x,?y)
   => satisfied
'''
#############################################################################################################
