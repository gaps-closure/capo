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


output_order_enums = [
  "cleEntry",
  "cdf",
  "remotelevel",
  # "direction",
  # "operation",
  # "argtaints",
  # "codtaints",
  # "rettaints",
  # "hasParamIdx",
  # "hasTaint"
]

output_order_arrys = [
  "haslevel",
  "hasremotelevel",
  "hasdirection",
  "hasoperation",
  "hasargtaints",
  "hascodtaints",
  "hasrettaints",
]


def compute_zinc(infile,ttree, schema):
  hasCDF = []
  hasArgTaints = []
  # Collect cledefs and dump
  if(schema is None):
    #schema check is disabled
    defs = [{"cle_label": x[3], "cle-json": x[4]} for x in ttree if x[0] == 'cledef']
  else:
    defs = [{"cle_label": x[3], "cle-json": validate_cle(x,schema)} for x in ttree if x[0] == 'cledef']

  with open("clemap.json", 'w') as mapf:
    json.dump(defs,mapf,indent=2)

  noneCount = 0
  enums = defaultdict(lambda: [])
  arrays = defaultdict(lambda: [])
  enums['cleEntry'].append("None")
  arrays['haslevel'].append("none") 
  enums['cdf'].append("None" + "_cdf_" + str(noneCount))
  hasCDF.append([])
  hasCDF[-1].append("None" + "_cdf_" + str(noneCount))
  
  enums['remotelevel'].append("None" + "_remotelevel_" + str(noneCount))
  enums['direction'].append("None" + "_direction_" + str(noneCount))
  enums['operation'].append("None" + "_operation_" + str(noneCount))
  arrays["has" + 'remotelevel'].append("none")
  arrays["has" + 'direction'].append("noDir")
  arrays["has" + 'operation'].append("noOp")
  arrays["has" + 'functaints'].append("false")
  arrays["has" + 'argtaints'].append([["None"]])
  arrays["has" + 'codtaints'].append(["None"])
  arrays["has" + 'rettaints'].append(["None"])
  noneCount +=1
 
  maxCDFIdx = 0
  maxArgIdx = 1
  for x in ttree:
    if x[0] == 'cledef':
      CDF_flag = False
      funcTaint_flag = False
      print("Here")
      enums['cleEntry'].append(x[3])
      arrays['haslevel'].append(x[4]['level']) 

      
      if "cdf" not in x[4].keys():
        cdfStr = "None" + "_cdf_" + str(noneCount)
        print(cdfStr)
        enums['cdf'].append(cdfStr)
        hasCDF.append([])
        hasCDF[-1].append(cdfStr)
        enums['remotelevel'].append("None" + "_remotelevel_" + str(noneCount))
        enums['direction'].append("None" + "_direction_" + str(noneCount))
        enums['operation'].append("None" + "_operation_" + str(noneCount))
        arrays["has" + 'remotelevel'].append("none")
        arrays["has" + 'direction'].append("noDir")
        arrays["has" + 'operation'].append("noOp")
        arrays["has" + 'argtaints'].append([["None"]])
        arrays["has" + 'codtaints'].append(["None"])
        arrays["has" + 'rettaints'].append(["None"])
        noneCount += 1
      # Check for function taints, if one is there all must be there, therefore checking for 1 should be sufficient
      

      for k1 in x[4].keys():
        if k1 == 'cdf':
          if CDF_flag == False:
            CDF_flag = True
            hasCDF.append([])
          for i in range(len(x[4][k1])):
            cdfStr = x[3] + "_cdf_" + str(i)
            enums['cdf'].append(cdfStr)
            hasCDF[-1].append(cdfStr)
            if i + 1 > maxCDFIdx:
              maxCDFIdx = i + 1
            if "codtaints" not in x[4][k1][i].keys():
              arrays["has" + 'codtaints'].append(["None"])
            if "rettaints" not in x[4][k1][i].keys():
              arrays["has" + 'rettaints'].append(["None"])
            if "argtaints" not in x[4][k1][i].keys():
              arrays["has" + 'argtaints'].append([["None"]])
            for k2 in x[4][k1][i].keys():
              if k2 == 'guarddirective':
                for k3 in x[4][k1][i][k2].keys():
                  enums[k3].append(x[3] + "_" + k2 + "_" + "_" + k3 + "_" + str(i))
                  arrays["has" + k3].append(x[4][k1][i][k2][k3])
              else:
                enums[k2].append(x[3] + "_" + k2 + "_" + str(i))
                keyVal = x[4][k1][i][k2]
                # if type(keyVal) == list:
                #   for label in keyVal:
                #     # if there is another list it should be an argtaint or the label is not formed correctly
                #     if type(label) == list:
                #       if len(label) > maxArgIdx:
                #         maxArgIdx = len(label)

                arrays["has" + k2].append(keyVal)
            noneCount += 1

      if arrays["has" + 'argtaints'][-1] == [["None"]] and arrays["has" + 'codtaints'][-1] == ["None"] and arrays["has" + 'rettaints'][-1] == ["None"]:
        arrays["has" + 'functaints'].append("false")
      else:
        arrays["has" + 'functaints'].append("true")

  print(f"Max CDF: {maxCDFIdx}")
  with open("cle_instance.mzn", 'w') as zincOF:
    for i in output_order_enums:
      first = True
      # if "taint" in i:
      #   continue
      zincOF.write(f"{i} = {{")
      for j in enums[i]:
        if first:
          first = False
          zincOF.write(f"{j}")
        else:
          zincOF.write(f", {j} ")
      zincOF.write("}; \n")

    maxCodTaint = 0
    maxArgIdx = 0
    maxNumArgsTaints = 0
    maxRetTaint = 0

    for taints in arrays["hasargtaints"]: 
      if len(taints) > maxArgIdx:
        maxArgIdx = len(taints)

    for taints in arrays["hasargtaints"]: 
      for args in taints:
        if len(args) > maxNumArgsTaints:
          maxNumArgsTaints = len(args)

    for taints in arrays["hasrettaints"]: 
      if len(taints) > maxRetTaint:
        maxRetTaint = len(taints)

    for taints in arrays["hascodtaints"]: 
      if len(taints) > maxCodTaint:
        maxCodTaint = len(taints)

    
    print(f"MaxArg: {maxNumArgsTaints}, maxArgIdx: {maxArgIdx}, MaxRet: {maxRetTaint}, MaxCod: {maxCodTaint} ")
    for i in output_order_arrys:
      if "taint" in i:
          continue
      first = True
      
      zincOF.write(f"{i} = [")
      for j in arrays[i]:
        output = j
        if first:
          first = False
          zincOF.write(f"{output}")
        else:
          zincOF.write(f", {output} ")
      zincOF.write("]; \n")

    i = "hasfunctaints"
    first = True
    zincOF.write(f"{i} = [")
    for j in arrays[i]:
      output = j
      if first:
        first = False
        zincOF.write(f"{output}")
      else:
        zincOF.write(f", {output} ")
    zincOF.write("]; \n")

    print(f"MaxArg: {maxNumArgsTaints}, maxArgIdx: {maxArgIdx}, MaxRet: {maxRetTaint}, MaxCod: {maxCodTaint} ")
    
    zincOF.write(f"maxNumArgs = {maxArgIdx};\n")
    zincOF.write(f"maxNumArgTaints = {maxNumArgsTaints};\n")
    zincOF.write(f"maxCodTaints = {maxCodTaint};\n")
    zincOF.write(f"maxRetTaints = {maxRetTaint};\n")
    
     

    id = "hasargtaints"
    zincOF.write(f"hasargtaints = array3d(1..{len(arrays[id])}, ArgIdxs, ArgTaints ,[")
    print(arrays[id])
    first = True
    for row in arrays[id]:
      print(row)
      for i in range(maxArgIdx):
        if i >= len(row):
          for j in range(maxNumArgsTaints):
            if first:
              first = False
              zincOF.write("None")
            else:
              zincOF.write(",None")
        else:
          nested = row[i]
          print(nested)
          for j in range(maxNumArgsTaints):
            if j >= len(nested):
              if first:
                first = False
                zincOF.write("None")
              else:
                zincOF.write(",None")
            else:
              output = nested[j]
              print(output)
              if output not in enums["cleEntry"]:
                output = "None"
              if first:
                first = False
                zincOF.write(f"{output}")
              else:
                zincOF.write(f", {output} ")
    zincOF.write("]); \n")

    
    id = "hascodtaints"
    zincOF.write(f"hascodtaints = array2d(1..{len(arrays[id])}, CodTaints, [")
    print(arrays[id])
    first = True
    for row in arrays[id]:
      for i in range(maxCodTaint):
        if i >= len(row):
          if first:
            first = False
            zincOF.write("None")
          else:
            zincOF.write(",None")
        else:
          output = row[i]
          if row[i] not in enums["cleEntry"]:
            output = "None"
          if first:
            first = False
            zincOF.write(f"{output}")
          else:
            zincOF.write(f", {output} ")
    zincOF.write("]); \n")

    
    id = "hasrettaints"
    zincOF.write(f"hasrettaints = array2d(1..{len(arrays[id])}, RetTaints, [")
    print(arrays[id])
    first = True
    for row in arrays[id]:
      for i in range(maxRetTaint):
        if i >= len(row):
          if first:
            first = False
            zincOF.write("None")
          else:
            zincOF.write(",None")
        else:
          output = row[i]
          if row[i] not in enums["cleEntry"]:
            output = "None"
          if first:
            first = False
            zincOF.write(f"{output}")
          else:
            zincOF.write(f", {output} ")
    zincOF.write("]); \n")

    # zincOF.write("hasargtaints = [")
    # for row in hasArgTaints:
    #   first = True
    #   zincOF.write("|")
    #   for i in range(maxArgIdx):
    #     if i >= len(row):
    #       if first:
    #         first = False
    #         zincOF.write("None")
    #       else:
    #         zincOF.write(",None ")
    #     else:
    #       output = row[i]
    #       if row[i] not in enums["cleEntry"]:
    #         output = "None"
    #       if first:
    #         first = False
    #         zincOF.write(f"{output}")
    #       else:
    #         zincOF.write(f", {output} ")
    # zincOF.write("|")
    # zincOF.write("]; \n")

    zincOF.write("hasCDF = [")
    for row in hasCDF:
      first = True
      zincOF.write("|")
      for i in range(maxCDFIdx):
        if i >= len(row):
          if first:
            first = False
            zincOF.write("None_cdf_0")
          else:
            zincOF.write(",None_cdf_0 ")
        else:
          if first:
            first = False
            zincOF.write(f"{row[i]}")
          else:
            zincOF.write(f", {row[i]} ")
    zincOF.write("|")
    zincOF.write("]; \n")

    zincOF.write(f"maxCDFIdx = {maxCDFIdx}")
  


    


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

# def check_jsonschema_version():
#   """validate the json schema version is new enogh to process
#      Draft 7 schemas"""
#   if(jsonschema.__version__ < "3.2.0"):
#     raise(ModuleNotFoundError("Newer version of jsonschema module required"
      # " (>= 3.2.0)"))

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

  
  compute_zinc(args.file, ttree, schema)
 
  print('Writing cle mappings file')

if __name__ == '__main__':
  main()
