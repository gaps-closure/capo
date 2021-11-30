#!/usr/bin/python3
from   argparse import ArgumentParser
from   owlready2 import *
import re

def vocab_to_owlready(vfname,orfname,ontns,ontdir):
  i  = '  '
  n  = '\n'
  o1 = ''.join([
         '#!/usr/bin/python3',                           n,
         'from owlready2 import *',                      n,
         n
       ])

  o = ''.join([
        'def make_ontology():',                         n,
        i, 'onto_path.append(', "'", ontdir, "')",      n,
        i, ontns, ' = get_ontology(', "'", ontns, "')", n,
        i, 'with ', ontns, ':', n
      ])
    
  pddlset = {}
  tail = ''
  maypass = False
  inpddl  = None
  with open(vfname,'r') as vocab:
    for line in vocab:
      # Strip comments and empty lines, comment allowed between class and restriction
      if line.strip() == '' or line.startswith('#'):
        continue
      # Class/Property had no restrictions, so add a pass before processing line
      if maypass and not line.startswith('.'):
        o += ''.join([i, i, i, 'pass', n])
        maypass = False
      # Collect a PDDL snippet
      if inpddl is not None:              # in block 
        pddlset[inpddl] += line
        if re.match(r'(.*\'\'\')', line): # end block
          inpddl = None
        continue
      m = re.match(r'(.*)=\s*\'\'\'', line)
      if m:                               # begin block
        inpddl = m.group(1).strip()
        pddlset[inpddl] = "'''"
        continue
      # Process Disjoint
      if line.startswith('AllDisjoint'):
        tail += ''.join([i,line])
      # Process classes, properties, restrictions, instances, and attribute setting
      if line.startswith('!'):
        m = re.match(r'!(.*):(.*)', line)
        if m:
          s2 = m.group(2).strip()
          for s1 in m.group(1).strip().split(','):        # Instances
            s1s = s1.strip()
            o += ''.join([i, i, s1s, ' = ', s2, "(name='", s1s, "', namespace=", ontns, ')', n])
        m = re.match(r'!(.*)\((.*)\)', line)              # Instance Attributes
        if m:
          s1 = m.group(1).strip()
          s2 = m.group(2).strip()
          o += ''.join([i, i, 'if not ', s1, ': ', s1, ' = []', n])
          s3 = '.extend' if re.match(r'\[.*\]',s2) else '.append'
          o += ''.join([i, i, s1, s3, '(', s2, ')', n])
      elif line.startswith('.'):                          # Restriction
        o += ''.join([i, i, i, line.lstrip('.').rstrip(), n])
      elif ':' in line:                                   # Class or Property
        x = line.split(':', 1)
        o += ''.join([i, i, 'class ', x[0].strip(), '(', x[1].strip(), '):', n])
        maypass = True                                    # Restriction (.) may follow
      else:
        continue

  o += tail
  o += ''.join([i, 'return ', ontns, n, n])
  o += ''.join([
         "if __name__ == '__main__':", n,
         i, ontns, ' = make_ontology()', n,
         i, 'sync_reasoner(infer_property_values=True)', n,
         i, ontns, '.save(format = ', "'rdfxml')", n
       ])

  o2 = ''.join([k + '=' + pddlset[k] for k in pddlset])
        
  # Write boilerplate, pddl strings, and make_ontology() + main 
  with open(orfname,'w') as orpy:
    for w in [o1,o2,o]: orpy.write(w)
  
def get_args():
  p = ArgumentParser(description='C2fM Vocabulary to Owlready2 Converter')
  p.add_argument('-v', '--vocab_file', required=True, type=str, help='Input vocabulary file')
  p.add_argument('-o', '--output_orpy', required=True, type=str, help='Output Owlready2 python file')
  p.add_argument('-n', '--ontology_ns', required=True, type=str, help='Ontology namespace and filename prefix')
  p.add_argument('-d', '--ontology_dir', required=False, default='.', type=str, help='Ontology directory [.]')
  return p.parse_args()

if __name__ == '__main__':
  p = get_args()
  vocab_to_owlready(p.vocab_file, p.output_orpy, p.ontology_ns, p.ontology_dir)
