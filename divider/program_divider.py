#!/usr/bin/python3
# A program divider for refactored, CLE-annotated application programs
#
from   clang.cindex  import Index
from   argparse      import ArgumentParser
import json
import sys
import os

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

def load_topology(jfile):
  with open(jfile, 'r') as jf:
    return json.load(jf)

def remove_prefix(t,pfx):
  return t[len(pfx):] if t.startswith(pfx) else t

def walk_source_tree(jdata,opdir,cargs):
  fn2lvl = {}
  idir   = jdata['source_path'].rstrip('/')
  odir   = opdir.rstrip('/')
  lvls   = jdata['levels']
  for f in jdata['functions']: fn2lvl[f['name']] = f['level']

  os.makedirs(odir, mode=0o755, exist_ok=True)  
  for l in lvls: os.makedirs(odir + '/' + l, mode=0o755, exist_ok=True)  

  for root, dirs, files in os.walk(idir):
    r = remove_prefix(root,idir).lstrip('/')
    for name in dirs:
      for l in lvls:
        newd = os.path.join(odir, l, r, name)
        os.makedirs(newd, mode=0o755, exist_ok=True)  
    for name in files:
      process_file(idir,odir,r,name,cargs)

def process_file(idir,odir,relpath,fname,cargs):
  ifile = os.path.join(idir, relpath, fname)
  print('Processing:', ifile)

  index = Index.create()
  # tu = index.parse(ifile, args=cargs)
  tu = index.parse(ifile)
  if not tu: raise Exception("unable to load input")
  print(('diags', [get_diag_info(d) for d in  tu.diagnostics]))
  print(('nodes', get_info(tu.cursor)))

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
