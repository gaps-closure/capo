#!/usr/bin/python3
# A quick and dirty cle-preprocessor implementation for GAPS-CLOSURE
#
from   argparse      import ArgumentParser
from qd_cle_preprocessor import TypeLexer, cle_parser, CLETransformer, validate_cle, cindex_tokenizer
import json
import sys
import os
import os.path
from collections import defaultdict





def compute_zinc(infile,ttree, schema):
  # Collect cledefs and dump
  if(schema is None):
    #schema check is disabled
    defs = [{"cle_label": x[3], "cle-json": x[4]} for x in ttree if x[0] == 'cledef']
  else:
    defs = [{"cle_label": x[3], "cle-json": validate_cle(x,schema)} for x in ttree if x[0] == 'cledef']

  with open("clemap.json", 'w') as mapf:
    json.dump(defs,mapf,indent=2)

  enums = defaultdict(lambda: [])
  arrays = defaultdict(lambda: [])
  enums['cleEntry'].append("None")
  for x in ttree:
    if x[0] == 'cledef':
      enums['cleEntry'].append(x[3])
      arrays['haslevel'].append(x[4]['level']) 
      for k1 in x[4].keys():
        print(f"key: {k1} value: {x[4][k1]}")
        if k1 == 'cdf':
          for i in range(len(x[4][k1])):
            enums['cdf'].append(x[3] + "_cdf_" + str(i))
            for k2 in x[4][k1][i].keys():
              if k2 == 'guarddirective':
                for k3 in x[4][k1][i][k2].keys():
                  enums[k3].append(x[3] + "_" + k2 + "_" + "_" + k3 + "_" + str(i))
                  arrays["has" + k3].append(x[4][k1][i][k2][k3])
              else:
                enums[k2].append(x[3] + "_" + k2 + "_" + str(i))
                arrays["has" + k2].append(x[4][k1][i][k2])
  
  with open("cle-data.dzn", 'w') as zincOF:
    for i in enums:
      first = True
      zincOF.write(f"{i} = {{")
      for j in enums[i]:
        if first:
          first = False
          zincOF.write(f"{j}")
        else:
          zincOF.write(f", {j} ")
      zincOF.write("}; \n")

    for i in arrays:
      first = True
      zincOF.write(f"{i} = [")
      for j in arrays[i]:
        if first:
          first = False
          zincOF.write(f"{j}")
        else:
          zincOF.write(f", {j} ")
        
      zincOF.write(f"]; \n")

    


  # for i in defs:
  #   print(i)

  
    
# Parse command line argumets
def get_args():
  p = ArgumentParser(description='CLOSURE Language Extensions Preprocessor')
  p.add_argument('-f', '--file', required=True, type=str, help='Input file')
  p.add_argument('-c', '--clang_args', required=False, type=str, 
                 default='-x,c++,-stdlib=libc++', help='Arguments for clang')
  p.add_argument('-a', '--annotation_style', required=False, type=str, 
                 default='naive', help='Annotation style (naive, type, or both)')
  p.add_argument('-t', '--tool_chain', required=False, type=str, 
                 default='clang', help='Toolchain (clang)')
  p.add_argument('-s', '--schema', required=False, type=str,
                 default='../../cle-spec/schema/cle-schema.json',
                 help='override the location of the of the schema if required')
  p.add_argument('-L', '--liberal',help="Liberal mode: disable cle schema check",
                 default=False, action='store_true') 
  return p.parse_args()

def get_cle_schema(schema_location):
  basepath = ""
  
  #get the module paths to help find the schema in a relitive to ourself
  if(len(sys.path) > 1):
    basepath = sys.path[0]
  path = os.path.join(basepath,schema_location)
  
  if(not os.path.exists(path)):
    #schema not found relitive to the python enviroment, check a local path
    path = schema_location
    if(not os.path.exists(path)):
      #Unable to get python schema
      raise(IOError("Unable to fild cle schema (expected at): " + path))
  
  #we found the schema load it into ram
  print("Using CLE schema: " + path)
  with open(path,"r",encoding="UTF-8") as schemafile:
    return(json.loads(schemafile.read()))

def check_jsonschema_version():
  """validate the json schema version is new enogh to process
     Draft 7 schemas"""
  if(jsonschema.__version__ < "3.2.0"):
    raise(ModuleNotFoundError("Newer version of jsonschema module required"
      " (>= 3.2.0)"))

# Create and invoke tokenizer, parser, tree transformer, and source transformer
def main():
  args   = get_args()
  print('Options selected:')
  for x in vars(args).items(): print('  %s: %s' % x)
  
  if(args.tool_chain != 'clang'):
    sys.exit('Exiting on unsupported toolchain: ' + args.tool_chain)

  #load json schema if required
  if(not args.liberal):
    check_jsonschema_version()
    schema = get_cle_schema(args.schema)
  else:
    schema = None
    print("Skipping CLE schema verification")
  
  toks   = cindex_tokenizer(args.file, args.clang_args.split(','))
  tree   = cle_parser().parser.parse(toks)
  #print(tree.pretty())
  print('Transformed Tree:')

  ttree  = CLETransformer().transform(tree)
  # for x in ttree: print(x)

  try:
    compute_zinc(args.file, ttree, schema)
  except jsonschema.exceptions.ValidationError as schemaerr:
    print(schemaerr)
    sys.exit(-1)
  print('Writing cle mappings file')

if __name__ == '__main__':
  main()
