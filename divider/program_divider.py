#!/usr/bin/python3
# A program divider for refactored, CLE-annotated application programs
#
from   clang.cindex  import Index, CursorKind
from   argparse      import ArgumentParser
from   shutil        import copyfile
from   pprint        import pprint
import json
import sys
import os
import re

def get_diag_info(diag):
  return { 
    'severity' : diag.severity,
    'location' : diag.location,
    'spelling' : diag.spelling,
    'ranges'   : diag.ranges,
    'fixits'   : diag.fixits 
  }

def get_cursor_id(cursor, cursor_list = []):
  if cursor is None: return None
  for i,c in enumerate(cursor_list):
    if cursor == c: return i
  cursor_list.append(cursor)
  return len(cursor_list) - 1

def get_info(node, depth=0):
  children = [get_info(c, depth+1) for c in node.get_children()]
  return { 
    'id'            : get_cursor_id(node),
    'kind'          : node.kind,
    'usr'           : node.get_usr(),
    'spelling'      : node.spelling,
    'location'      : node.location,
    'extent.start'  : node.extent.start,
    'extent.end'    : node.extent.end,
    'is_definition' : node.is_definition(),
    'definition_id' : get_cursor_id(node.get_definition()),
    'children'      : children 
  }

def cindex_dump(tu):
  pprint({
   'diags': [get_diag_info(d) for d in  tu.diagnostics],
   'nodes': get_info(tu.cursor)
  })

def top_fun_vars(root, ifile, levelof):
  tfv = []
  if root.kind != CursorKind.TRANSLATION_UNIT:
    raise Exception('Expecting CursorKind.TRANSLATION_UNIT, got: ' + str(root.kind))

  for node in root.get_children():
    if node.kind == CursorKind.FUNCTION_DECL or node.kind == CursorKind.VAR_DECL:
      if str(node.extent.start.file) != ifile: 
        print('Skipping:', node.extent.start.file, '!=', ifile)
        continue
      if not node.spelling in levelof:
        raise Exception('No level (enclave) assignment founnd for: ' + node.spelling)
      tfv.append({ 
        'kind'  : node.kind,
        'name'  : node.spelling,
        'level' : levelof[node.spelling],
        'soff'  : int(node.extent.start.offset),
        'slin'  : int(node.extent.start.line),
        'scol'  : int(node.extent.start.column),
        'eoff'  : int(node.extent.end.offset),
        'elin'  : int(node.extent.end.line),
        'ecol'  : int(node.extent.end.column)
      })
  return tfv

def process_file(lvls,levelof,idir,odir,relpath,fname,cargs):
  ifile = os.path.join(idir, relpath, fname)
  print('Processing:', ifile)
  index = Index.create()

  fs       = fname.rsplit('.',1)
  basename = fs[0]
  suffix   = '.' + fs[1] if len(fs) == 2 else ''
  def ofile(l): return os.path.join(odir, l, relpath, basename + '_' + l + suffix)

  if len(fs) != 2 and (suffix != '.c' or suffix != '.h'): # not a .c/.h file
    print('Renaming and copying to all levels:', ifile)
    for l in lvls: copyfile(ifile, ofile(l))
    return

  tu = index.parse(ifile, args=cargs.split(','))
  if not tu: raise Exception("unable to load input")
  # cindex_dump(tu)
  tfv = sorted(top_fun_vars(tu.cursor, ifile, levelof), key = lambda i: i['slin'])
  # pprint(tfv)

  lvlfp = {l:open(ofile(l), 'w') for l in lvls}
  with open(ifile,'r') as inp:
    # Check tfv item extents fall within file extent
    # XXX: also ought to check that tfv item extents do not intersect
    nlines = len(inp.readlines())
    if len(tfv) > 0:
      if tfv[0]['slin'] < 1 or tfv[-1]['elin'] > nlines:
        raise Exception('Function or variable extent outside file range')
    inp.seek(0,0)

    beg,end,lvl = (tfv[0]['slin'],tfv[0]['elin'],tfv[0]['level']) if len(tfv) > 0 else (None,None,None)
    llvl = None
    curl = 0
    idx  = 0
    for line in inp:
      curl += 1
      # Put fun/var with assigned level in file for corresponding level
      if beg and end and curl >= beg and curl <= end:
        lvlfp[lvl].write(line)
        if end and curl == end and idx < len(tfv):
          idx += 1
          llvl = lvl
          beg,end,lvl = (tfv[idx]['slin'],tfv[idx]['elin'],tfv[idx]['level']) if idx < len(tfv) else (None,None,None)
        continue

      # Put remaining lines in files for all levels
      if re.match(r'\s*#\s*pragma\s+cle\s+begin\s+.*', line):
        lvlfp[lvl].write(line)
        # print('Warning: clebegin on line %d sent to next fun/var level %s' % (curl,lvl))
      elif re.match(r'\s*#\s*pragma\s+cle\s+end\s+.*', line):
        lvlfp[llvl].write(line)
        # print('Warning: cleend on line %d sent to previous fun/var level %s' % (curl,llvl))
      else: 
        for l in lvls: lvlfp[l].write(line)
  for l in lvls: lvlfp[l].close()

def remove_prefix(t,pfx):
  return t[len(pfx):] if t.startswith(pfx) else t

def walk_source_tree(jdata,opdir,cargs):
  levelof = {}
  idir   = jdata['source_path'].rstrip('/')
  odir   = opdir.rstrip('/')
  lvls   = jdata['levels']
  for f in jdata['functions']: levelof[f['name']] = f['level']
  for f in jdata['global_scoped_vars']: levelof[f['name']] = f['level']

  os.makedirs(odir, mode=0o755, exist_ok=True)  
  for l in lvls: os.makedirs(odir + '/' + l, mode=0o755, exist_ok=True)  

  for root, dirs, files in os.walk(idir):
    r = remove_prefix(root,idir).lstrip('/')
    for name in dirs:
      for l in lvls:
        newd = os.path.join(odir, l, r, name)
        os.makedirs(newd, mode=0o755, exist_ok=True)  
    for name in files:
      process_file(lvls,levelof,idir,odir,r,name,cargs)

def load_topology(jfile):
  with open(jfile, 'r') as jf:
    return json.load(jf)

def get_args():
  p = ArgumentParser(description='CLOSURE Program Divider')
  p.add_argument('-f', '--file', required=True, type=str, help='Input JSON file')
  p.add_argument('-o', '--output_dir', required=False, type=str, 
                 default='./divvied', help='Output directory [./divvied]')
  p.add_argument('-c', '--clang_args', required=False, type=str, 
                 default='-x,c++,-stdlib=libc++', help='Arguments for clang')
  return p.parse_args()

if __name__ == '__main__':
  args   = get_args()
  print('Options selected:')
  for x in vars(args).items(): print('  %s: %s' % x)
  walk_source_tree(load_topology(args.file), args.output_dir, args.clang_args)