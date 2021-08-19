#!/usr/bin/python3

from   argparse      import ArgumentParser
import json
import sys
import os
import os.path
from collections import defaultdict


output_order_enums = [
  "cleLabel",
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
  "hasLabelLevel",
  "hasremotelevel",
  "hasdirection",
  "hasoperation",
  "hasargtaints",
  "hascodtaints",
  "hasrettaints",
]


def compute_zinc(cleJson):
    hasCDF = []
    hasArgTaints = []
    listOfLevels = []

    noneCount = 0
    enums = defaultdict(lambda: [])
    arrays = defaultdict(lambda: [])
    enums["cleLabel"].append("nullCleLabel")
    arrays['hasLabelLevel'].append("nullLevel") 
    arrays['isFunctionAnnotation'].append("false") 
    enums['cdf'].append("nullCdf")
    hasCDF.append([])
    hasCDF[-1].append("None" + "_cdf_" + str(noneCount))
    
    enums['remotelevel'].append("None" + "_remotelevel_" + str(noneCount))
    enums['direction'].append("None" + "_direction_" + str(noneCount))
    enums['operation'].append("None" + "_operation_" + str(noneCount))
    arrays["fromCleLabel"].append("nullCleLabel")
    arrays["hasRemotelevel"].append("nullLevel")
    arrays["hasDirection"].append("nullDirection")
    arrays["hasGuardOperation"].append("nullGuardOperation")
    arrays["isOneway"].append("false")
    arrays["hasARCtaints"] = []
    noneCount +=1
    
    maxCDFIdx = 0
    maxArgIdx = 0
    with open("./pdg_instance.mzn","r") as argFile:
        data = argFile.readlines()
        for d in data:
            if 'MaxFuncParms' in d:
                maxArgIdx = int(d.split()[-1][:-1])
                break
    print(maxArgIdx)

    listOfLevels.append("nullLevel")
    for entry in cleJson:
        if "cle-json" in entry.keys() and "level" in entry["cle-json"].keys():
            listOfLevels.append(entry["cle-json"]['level'])
        else:
            listOfLevels.append("nullLevel")
    
    listOfLevels = set(listOfLevels)
    listOfLevels = list(listOfLevels)
    listOfLevels.sort()
    listOfLevels.remove("nullLevel")
    listOfLevels.insert(0,"nullLevel")
    nullLevel = ["nullCdf" for x in range(len(listOfLevels))]
    arrays["cdfForRemoteLevel"].append(nullLevel)
    print(listOfLevels)

    for entry in cleJson:
        CDF_flag = False
        print("ENTRY")
        print(entry)
        

        enums["cleLabel"].append(entry["cle-label"])
        if "cle-json" in entry.keys() and "level" in entry["cle-json"].keys():
            arrays['hasLabelLevel'].append(entry["cle-json"]['level'])
        else:
            arrays['hasLabelLevel'].append("nullLevel")
        
        # only checks if the first cdf has function taints, assumes they all do
        if "cle-json" in entry.keys() and "cdf" in entry["cle-json"].keys() and "codtaints" in entry["cle-json"]["cdf"][0]: 
            arrays['isFunctionAnnotation'].append("true")
        else:
            arrays['isFunctionAnnotation'].append("false")

        CDFforEntry = [] 
        #assumes only one cdf in the label has a certaint remote level
        for j in listOfLevels:
            found = 0
            if "cle-json" in entry.keys() and "cdf" in entry["cle-json"].keys():
                cdfIdx = 0
                for cdf in entry["cle-json"]["cdf"]:
                    cdfStr = entry["cle-label"] + "_cdf_" + str(cdfIdx)
                    if "remotelevel" in cdf.keys():
                        if cdf["remotelevel"] == j:
                            CDFforEntry.append(cdfStr)
                            temp = cdf["remotelevel"]
                            print(f"Found remote level: {j}")
                            found = 1
                    cdfIdx+=1
            if found == 0:
                CDFforEntry.append("nullCdf")
        arrays["cdfForRemoteLevel"].append(CDFforEntry)

        if "cle-json" in entry.keys() and "cdf" in entry["cle-json"].keys():
            cdfIdx = 0
            for cdf in entry["cle-json"]["cdf"]:
                cdfStr = entry["cle-label"] + "_cdf_" + str(cdfIdx)
                enums["cdf"].append(cdfStr)
                arrays['fromCleLabel'].append(entry["cle-label"])

                if "remotelevel" in cdf.keys():
                    arrays['hasRemotelevel'].append(cdf["remotelevel"])
                else:
                    arrays['hasRemotelevel'].append("nullLevel")

                if "direction" in cdf.keys():
                    arrays['hasDirection'].append(cdf["direction"])
                else:
                    arrays['hasDirection'].append("nullDirection")

                if "guarddirective" in cdf.keys():
                    arrays['hasGuardOperation'].append(cdf["guarddirective"]["operation"])
                else:
                    arrays['hasGuardOperation'].append("nullGuardOperation")

                if "oneway" in cdf.keys():
                    arrays['isOneway'].append(cdf["oneway"])
                else:
                    arrays['isOneway'].append("false")

                if "rettaints" in cdf.keys():
                    for label in cdf['rettaints']:
                        if label not in enums["cleLabel"]:
                            enums["cleLabel"].append(label)
                            arrays['hasLabelLevel'].append("nullLevel") 
                            arrays['isFunctionAnnotation'].append("false")
                            arrays["cdfForRemoteLevel"].append(nullLevel)
                if "codtaints" in cdf.keys():
                    for label in cdf['codtaints']:
                        if label not in enums["cleLabel"]:
                            enums["cleLabel"].append(label)
                            arrays['hasLabelLevel'].append("nullLevel") 
                            arrays['isFunctionAnnotation'].append("false")
                            arrays["cdfForRemoteLevel"].append(nullLevel)
                if "argtaints" in cdf.keys():
                    for param in cdf['argtaints']:
                        for label in param:
                            if label not in enums["cleLabel"]:
                                enums["cleLabel"].append(label)
                                arrays['hasLabelLevel'].append("nullLevel") 
                                arrays['isFunctionAnnotation'].append("false")
                                arrays["cdfForRemoteLevel"].append(nullLevel)
                cdfIdx+=1
   
    
    for level in listOfLevels:
        if level == "nullLevel":
            continue
        newLabelStr = level+"DFLT"
        enums["cleLabel"].append(newLabelStr)
        arrays['hasLabelLevel'].append(level) 
        arrays['isFunctionAnnotation'].append("false")
        arrays["cdfForRemoteLevel"].append(nullLevel)

    anyFunctionCdfs = False
    for i in arrays['isFunctionAnnotation']:
        if i == "true":
            anyFunctionCdfs = True
            break
    
    if not anyFunctionCdfs:
        enums["cleLabel"].append("EmptyFunction")
        arrays['hasLabelLevel'].append("nullLevel") 
        arrays['isFunctionAnnotation'].append("true")
        cdfStr = "EmptyFunction_cdf_0"
        enums["cdf"].append(cdfStr)
        arrays['fromCleLabel'].append("EmptyFunction")
        arrays['hasRemotelevel'].append("nullLevel")
        arrays['hasDirection'].append("nullDirection")
        arrays['hasGuardOperation'].append("nullGuardOperation")
        arrays['isOneway'].append("false")

        emptyFunLevel = ["nullCdf" for x in range(len(listOfLevels))]
        emptyFunLevel[0] = "EmptyFunction_cdf_0"
        arrays["cdfForRemoteLevel"].append(emptyFunLevel)

        entry = {}
        entry["cle-label"] = "EmptyFunction"
        entry["cle-json"] = {}
        entry["cle-json"]["level"] = "nullLevel"
        entry["cle-json"]["cdf"] = []
        cdf = {}
        cdf["remotelevel"] = "nullLevel"
        cdf["argtaints"] = []
        cdf["codtaints"] = []
        cdf["rettaints"] = []
        entry["cle-json"]["cdf"].append(cdf)
        cleJson.append(entry)


    
    for entry in cleJson:
        print("ENTRY")
        print(entry)
        
        #if codtaints is defined, all taints need to be defined
        if "cle-json" in entry.keys() and "cdf" in entry["cle-json"].keys() and "codtaints" in entry["cle-json"]["cdf"][0]:
            ARCTaint = ["false" if label != entry["cle-label"] else "true" for label in enums["cleLabel"] ]
            for cdf in entry["cle-json"]["cdf"]:
                # code taints
                taintEntry = []  
                for label in enums["cleLabel"]:
                    found = 0
                    for labelTaint in cdf["codtaints"]:
                        if label == labelTaint:
                            taintEntry.append("true")
                            found = 1
                    if found == 0:
                        taintEntry.append("false")
                arrays["hasCodtaints"].append(taintEntry)
                ARCTaint = [str(a=='true' or b=='true').lower()  for a, b in zip(ARCTaint, taintEntry)]
                
                # ret Taints
                taintEntry = []  
                for label in enums["cleLabel"]:
                    found = 0
                    for labelTaint in cdf["rettaints"]:
                        if label == labelTaint:
                            taintEntry.append("true")
                            found = 1
                    if found == 0:
                        taintEntry.append("false")
                arrays["hasRettaints"].append(taintEntry)
                ARCTaint = [str(a=='true' or b=='true').lower() for a, b in zip(ARCTaint, taintEntry)]

                # Arg Taints
                taintEntry = []
                print(cdf["argtaints"])
                paramCount = 0
                for param in cdf["argtaints"]:
                    paramEntry = []  
                    for label in enums["cleLabel"]:
                        found = 0
                        for labelTaint in param:
                            if label == labelTaint:
                                paramEntry.append("true")
                                found = 1
                            else:
                                paramEntry.append("false")
                    ARCTaint = [str(a=='true' or b=='true').lower()  for a, b in zip(ARCTaint, paramEntry)]
                    taintEntry.append(paramEntry)
                    paramCount +=1
                
                while paramCount < maxArgIdx:
                    paramEntry = []  
                    for label in enums["cleLabel"]:
                        paramEntry.append("false")
                    ARCTaint = [str(a=='true' or b=='true').lower()  for a, b in zip(ARCTaint, paramEntry)]
                    taintEntry.append(paramEntry)
                    paramCount +=1
                
                arrays["hasArgtaints"].append(taintEntry)
                arrays["hasARCtaints"].append(ARCTaint)

    maxCodTaint = 0
    # maxArgIdx = 0
    maxNumArgsTaints = 0
    maxRetTaint = 0

    # for taints in arrays["hasargtaints"]: 
    #     if len(taints) > maxArgIdx:
    #         maxArgIdx = len(taints)

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

    with open("enclave_instance.mzn", 'w') as enclaveOF:

        Levels = "Level = {"
        Enclave = "Enclave = {"
        hasEnclaveLevel = "hasEnclaveLevel = ["
        for level in listOfLevels:
            Levels += level + ","
            if level == "nullLevel":
                Enclave +=  "nullEnclave, "
            else:
                Enclave += level + "_E,"
            hasEnclaveLevel += level + ","
        Levels = Levels[:-1]
        Enclave = Enclave[:-1]
        hasEnclaveLevel = hasEnclaveLevel[:-1]
        Levels += "};\n"
        Enclave += "};\n"
        hasEnclaveLevel += "];\n"

        enclaveOF.write(Levels)
        enclaveOF.write(Enclave)
        enclaveOF.write(hasEnclaveLevel)


    with open("cle_instance.mzn", 'w') as zincOF:
        # zincOF.write(f"MaxFuncParms = {maxArgIdx}; \n")

        zincOF.write(f"cleLabel = {{")
        first = True
        for j in enums["cleLabel"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("}; \n")

        zincOF.write(f"hasLabelLevel = [")
        first = True
        for j in arrays["hasLabelLevel"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("]; \n")
        
        zincOF.write(f"isFunctionAnnotation = [")
        first = True
        for j in arrays["isFunctionAnnotation"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("]; \n")

        zincOF.write(f"cdf = {{")
        first = True
        for j in enums["cdf"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("}; \n")

        zincOF.write(f"fromCleLabel = [")
        first = True
        for j in arrays["fromCleLabel"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("]; \n")

        zincOF.write(f"hasRemotelevel = [")
        first = True
        for j in arrays["hasRemotelevel"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("]; \n")

        zincOF.write(f"hasDirection = [")
        first = True
        for j in arrays["hasDirection"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("]; \n")

        zincOF.write(f"hasGuardOperation = [")
        first = True
        for j in arrays["hasGuardOperation"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("]; \n")

        zincOF.write(f"isOneway = [")
        first = True
        for j in arrays["isOneway"]:
            if first:
                first = False
                zincOF.write(f"{j}")
            else:
                zincOF.write(f", {j} ")
        zincOF.write("]; \n")

        zincOF.write(f"cdfForRemoteLevel = [|\n ")
        for row in arrays["cdfForRemoteLevel"]:
            print(row)
            first = True
            for j in row:
                if first:
                    first = False
                    zincOF.write(f"{j}")
                else:
                    zincOF.write(f", {j} ")
            zincOF.write("\n|")
        zincOF.write("]; \n")

        numFunctionCDFS = len(arrays["hasRettaints"])
        print(f"Num Function CDFs: {numFunctionCDFS}")
        numCleLabels = len(enums["cleLabel"])
        print(f"Num CLE Labels: {numCleLabels}")


        zincOF.write(f"hasRettaints = array2d(functionCdf, cleLabel, [\n ")
        first = True
        for row in arrays["hasRettaints"]:
            print(row)
            for j in row:
                if j == "true":
                    j = "true "
                if first:
                    first = False
                    zincOF.write(f" {j} ")
                else:
                    zincOF.write(f", {j} ")
            zincOF.write("\n")
        zincOF.write(" ]); \n")
        numElts = 0
        for i in arrays["hasRettaints"]:
            for j in i:
                numElts+=1
        if numFunctionCDFS * numCleLabels != numElts:
            print("hasRettaints has incorrect dimensions")


        zincOF.write(f"hasCodtaints = array2d(functionCdf, cleLabel, [\n ")
        first = True
        for row in arrays["hasCodtaints"]:
            print(row)
            for j in row:
                if j == "true":
                    j = "true "
                if first:
                    first = False
                    zincOF.write(f" {j} ")
                else:
                    zincOF.write(f", {j} ")
            zincOF.write("\n")
        zincOF.write(" ]); \n")
        numElts = 0
        for i in arrays["hasCodtaints"]:
            for j in i:
                numElts+=1
        if numFunctionCDFS * numCleLabels != numElts:
            print("hasCodtaints has incorrect dimensions")

        zincOF.write(f"hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [\n ")
        first = True
        for row in arrays["hasArgtaints"]:
            print(row)
            argCount = 0
            for nested in row:
                for j in nested:
                    if j == "true":
                        j = "true "
                    if first:
                        first = False
                        zincOF.write(f" {j} ")
                    else:
                        zincOF.write(f", {j} ")

                    if argCount % maxArgIdx == maxArgIdx -1:
                        zincOF.write("\t\t")
                    argCount+=1
            zincOF.write("\n")
        zincOF.write(" ]); \n")
        numElts = 0
        for i in arrays["hasArgtaints"]:
            for j in i:
                for k in j:
                    numElts+=1
        if numFunctionCDFS * maxArgIdx * numCleLabels != numElts:
            print("hasArgtaints has incorrect dimensions")

        zincOF.write(f"hasARCtaints = array2d(functionCdf, cleLabel, [\n ")
        first = True
        for row in arrays["hasARCtaints"]:
            print(row)
            for j in row:
                if j == "true":
                    j = "true "
                if first:
                    first = False
                    zincOF.write(f" {j} ")
                else:
                    zincOF.write(f", {j} ")
            zincOF.write("\n")
        zincOF.write(" ]); \n")

        numElts = 0
        for i in arrays["hasARCtaints"]:
            for j in i:
                numElts+=1
        if numFunctionCDFS * numCleLabels != numElts:
            print("hasARCtaints has incorrect dimensions")

    print(enums)
    print(arrays)
        
   
    
# Parse command line argumets
def get_args():
  p = ArgumentParser(description='CLOSURE Language Extensions JSON Processor')
  p.add_argument('-f', '--file', required=True, type=str, help='Input file')
  return p.parse_args()


def main():
  args   = get_args()
  
#   print(args.file)
  f = open(args.file,"r")
  cle_json=json.load(f)
  compute_zinc(cle_json)



  


if __name__ == '__main__':
  main()
