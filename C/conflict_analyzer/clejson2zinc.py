#!/usr/bin/python3

from   argparse      import ArgumentParser
from dataclasses import dataclass
import json
import sys
import os
import os.path
from collections import defaultdict
from typing import Any, Dict, List
from logging import Logger
import logging
import csv

from preprocessor.preprocess import LabelledCleJson

class DimensionError(Exception):
    pass

class CLEUsageError(Exception):
    pass


output_order_enums = [
  "cleLabel",
  "cdf",
  "remotelevel",
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

@dataclass
class ZincSrc:
    cle_instance: str
    enclave_instance: str


def compute_zinc(cleJson: List[LabelledCleJson], function_args: str, pdg_instance: str, one_way: str, logger: Logger) -> ZincSrc:
    hasCDF = []
    hasArgTaints = []
    listOfLevels = []

    one_way_map = {}
    logger.debug(one_way)
    for line in one_way.splitlines():
        logger.debug(line)
        one_way_map[line.split()[0]] =  line.split()[1]

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

    labelList = []
    for entry in cleJson:
      labelList.append(entry["cle-label"])
    
    #group function annotations
    cleJson2 = cleJson[:]
    for entry in cleJson:
        # print("Updating Order")
        if "cle-json" in entry.keys() and "cdf" in entry["cle-json"].keys() and "codtaints" in entry["cle-json"]["cdf"][0]: 
            logger.debug("Updating Order")
            cleJson2.insert(0,cleJson2.pop(cleJson.index(entry)))
    cleJson = cleJson2
    
    maxCDFIdx = 0
    maxArgIdx = 0
    data = pdg_instance.splitlines()
    for d in data:
        if 'MaxFuncParms' in d:
            maxArgIdx = int(d.split()[-1][:-1])
            break
    logger.debug(maxArgIdx)

    fun2ArgCount = {}
    data = function_args.splitlines()
    for d in data:
        fun2ArgCount[d.split()[0]] = int(d.split()[1])

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
    # TODO: Need to check that for each CDF there is exactly one entry and if not raise an error.
    arrays["cdfForRemoteLevel"].append(nullLevel)
    logger.debug(listOfLevels)

    for entry in cleJson:
        CDF_flag = False
        logger.debug("ENTRY")
        logger.debug(entry)
        

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
                            logger.debug(f"Found remote level: {j}")
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
                    if entry["cle-label"] in one_way_map.keys() and one_way_map[entry["cle-label"]] == "false":
                        logger.error("Error, oneway function has uses!")
                        raise CLEUsageError("Oneway function has uses!")
                    arrays['isOneway'].append(cdf["oneway"])
                else:
                    arrays['isOneway'].append("false")

                if "rettaints" in cdf.keys():
                    for label in cdf['rettaints']:
                        if label not in enums["cleLabel"] and not label in labelList:
                            enums["cleLabel"].append(label)
                            arrays['hasLabelLevel'].append("nullLevel") 
                            arrays['isFunctionAnnotation'].append("false")
                            arrays["cdfForRemoteLevel"].append(nullLevel)
                if "codtaints" in cdf.keys():
                    for label in cdf['codtaints']:
                        if label not in enums["cleLabel"] and not label in labelList:
                            enums["cleLabel"].append(label)
                            arrays['hasLabelLevel'].append("nullLevel") 
                            arrays['isFunctionAnnotation'].append("false")
                            arrays["cdfForRemoteLevel"].append(nullLevel)
                if "argtaints" in cdf.keys():
                    for param in cdf['argtaints']:
                        for label in param:
                            if label not in enums["cleLabel"] and not label in labelList:
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
        logger.debug("ENTRY")
        logger.debug(entry)
        
        #if codtaints is defined, all taints need to be defined
        if "cle-json" in entry.keys() and "cdf" in entry["cle-json"].keys():
            if "codtaints" in entry["cle-json"]["cdf"][0] or "rettaints" in entry["cle-json"]["cdf"][0] or "argtaints" in entry["cle-json"]["cdf"][0]:
                if not("codtaints" in entry["cle-json"]["cdf"][0] and "rettaints" in entry["cle-json"]["cdf"][0] and "argtaints" in entry["cle-json"]["cdf"][0]):
                    errorLabel = entry["cle-label"]
                    logger.error(f"Label: {errorLabel} Missing 1 or more function taints!")
                    raise CLEUsageError(f"Label: {errorLabel} Missing 1 or more function taints!")

        if entry["cle-label"] != "EmptyFunction" and entry["cle-label"] in fun2ArgCount.keys():
            if "cle-json" in entry.keys() and "cdf" in entry["cle-json"].keys():
                if not("codtaints" in entry["cle-json"]["cdf"][0] and "rettaints" in entry["cle-json"]["cdf"][0] and "argtaints" in entry["cle-json"]["cdf"][0]):
                    errorLabel = entry["cle-label"]
                    logger.error(f"Label: {errorLabel} Function Annotation missing function taints!")
                    raise CLEUsageError(f"Label: {errorLabel} Function Annotation missing function taints!")
            else:
                errorLabel = entry["cle-label"]
                logger.error(f"Label: {errorLabel} Function Annotation missing CDF!")
                raise CLEUsageError(f"Label: {errorLabel} Function Annotation missing CDF!")

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
                hasArgFlag = 1
                # Arg Taints
                taintEntry = []
                logger.debug(cdf["argtaints"])
                
                arcParamCount = 0
                arcEntry = []
                for param in cdf["argtaints"]:
                    arcParamCount+=1
                    if len(param) == 0:
                        hasArgFlag = 0
                        break
                      
                    for label in enums["cleLabel"]:
                        found = 0
                        for labelTaint in param:
                            if label == labelTaint:
                                arcEntry.append("true")
                                found = 1
                        if found == 0:
                            arcEntry.append("false")

                while arcParamCount < maxArgIdx:
                    for label in enums["cleLabel"]:
                        arcEntry.append("false")
                    arcParamCount += 1

                
                actualParamCount = len(cdf["argtaints"]) -1
                for label in enums["cleLabel"]:
                    # print(f"Checking label:{label}")
                    paramCount = 0
                    paramEntry = []
                    while paramCount < maxArgIdx:
                        if paramCount < len(cdf["argtaints"]):
                            param = cdf["argtaints"][paramCount]
                            # print(f"Checking Param{param}")
                            if label in param:
                                paramEntry.append("true")
                            else:
                                paramEntry.append("false")
                        else:
                            paramEntry.append("false")
                        paramCount +=1
                    taintEntry.append(paramEntry)

                    ARCTaint = [str(a=='true' or b=='true').lower()  for a, b in zip(ARCTaint, arcEntry)]
                    
                    logger.debug(taintEntry)
                    
                

                if entry["cle-label"] in fun2ArgCount.keys() and entry["cle-label"] != "EmptyFunction" and fun2ArgCount[entry["cle-label"]] < actualParamCount and hasArgFlag:
                    errorLabel = entry["cle-label"]
                    logger.error(f"Label: {errorLabel} ERROR! Function annotation argument mismatch!")
                    raise CLEUsageError(f"Label: {errorLabel} Function annotation argument mismatch!")

                # while paramCount < maxArgIdx:
                #     paramEntry = []  
                #     for label in enums["cleLabel"]:
                #         paramEntry.append("false")
                #     ARCTaint = [str(a=='true' or b=='true').lower()  for a, b in zip(ARCTaint, paramEntry)]
                #     taintEntry.append(paramEntry)
                #     paramCount +=1
                
                arrays["hasArgtaints"].append(taintEntry)
                arrays["hasARCtaints"].append(ARCTaint)

    if len(enums["cleLabel"]) > len(set(enums["cleLabel"])):
        logger.error("Error! Duplicate CLE Lables detected.")
        raise CLEUsageError("Duplicate CLE Lables detected.")

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

    enclave_instance = ""
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

    enclave_instance += Levels 
    enclave_instance += Enclave
    enclave_instance += hasEnclaveLevel


    cle_instance = ""

    cle_instance += f"cleLabel = {{"
    first = True
    for j in enums["cleLabel"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("}; \n")

    cle_instance += (f"hasLabelLevel = [")
    first = True
    for j in arrays["hasLabelLevel"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("]; \n")
    
    cle_instance += (f"isFunctionAnnotation = [")
    first = True
    for j in arrays["isFunctionAnnotation"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("]; \n")

    cle_instance += (f"cdf = {{")
    first = True
    for j in enums["cdf"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("}; \n")

    cle_instance += (f"fromCleLabel = [")
    first = True
    for j in arrays["fromCleLabel"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("]; \n")

    cle_instance += (f"hasRemotelevel = [")
    first = True
    for j in arrays["hasRemotelevel"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("]; \n")

    cle_instance += (f"hasDirection = [")
    first = True
    for j in arrays["hasDirection"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("]; \n")

    cle_instance += (f"hasGuardOperation = [")
    first = True
    for j in arrays["hasGuardOperation"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("]; \n")

    cle_instance += (f"isOneway = [")
    first = True
    for j in arrays["isOneway"]:
        if first:
            first = False
            cle_instance += (f"{j}")
        else:
            cle_instance += (f", {j} ")
    cle_instance += ("]; \n")

    cle_instance += (f"cdfForRemoteLevel = [|\n ")
    for row in arrays["cdfForRemoteLevel"]:
        logger.debug(row)
        first = True
        for j in row:
            if first:
                first = False
                cle_instance += (f"{j}")
            else:
                cle_instance += (f", {j} ")
        cle_instance += ("\n|")
    cle_instance += ("]; \n")

    numFunctionCDFS = len(arrays["hasRettaints"])
    logger.debug(f"Num Function CDFs: {numFunctionCDFS}")
    numCleLabels = len(enums["cleLabel"])
    logger.debug(f"Num CLE Labels: {numCleLabels}")


    cle_instance += (f"hasRettaints = array2d(functionCdf, cleLabel, [\n ")
    first = True
    for row in arrays["hasRettaints"]:
        logger.debug(row)
        for j in row:
            if j == "true":
                j = "true "
            if first:
                first = False
                cle_instance += (f" {j} ")
            else:
                cle_instance += (f", {j} ")
        cle_instance += ("\n")
    cle_instance += (" ]); \n")
    numElts = 0
    for i in arrays["hasRettaints"]:
        for j in i:
            numElts+=1
    if numFunctionCDFS * numCleLabels != numElts:
        logger.error("hasRettaints has incorrect dimensions")
        raise DimensionError("hasRettaints has incorrect dimensions")


    cle_instance += (f"hasCodtaints = array2d(functionCdf, cleLabel, [\n ")
    first = True
    for row in arrays["hasCodtaints"]:
        logger.debug(row)
        for j in row:
            if j == "true":
                j = "true "
            if first:
                first = False
                cle_instance += (f" {j} ")
            else:
                cle_instance += (f", {j} ")
        cle_instance += ("\n")
    cle_instance += (" ]); \n")
    numElts = 0
    for i in arrays["hasCodtaints"]:
        for j in i:
            numElts+=1
    if numFunctionCDFS * numCleLabels != numElts:
        logger.error("hasCodtaints has incorrect dimensions")
        raise DimensionError("hasCodtaints has incorrect dimensions")

    cle_instance += (f"hasArgtaints = array3d(functionCdf, parmIdx, cleLabel, [\n ")
    first = True
    for row in arrays["hasArgtaints"]:
        logger.debug(row)
        argCount = 0
        for nested in row:
            for j in nested:
                if j == "true":
                    j = "true "
                if first:
                    first = False
                    cle_instance += (f" {j} ")
                else:
                    cle_instance += (f", {j} ")

                if argCount % maxArgIdx == maxArgIdx -1:
                    cle_instance += ("\t\t")
                argCount+=1
        cle_instance += ("\n")
    cle_instance += (" ]); \n")
    numElts = 0
    for i in arrays["hasArgtaints"]:
        for j in i:
            for k in j:
                numElts+=1
    if numFunctionCDFS * maxArgIdx * numCleLabels != numElts:
        logger.error("hasArgtaints has incorrect dimensions")
        raise DimensionError("hasArgtaints has incorrect dimensions")

    cle_instance += (f"hasARCtaints = array2d(functionCdf, cleLabel, [\n ")
    first = True
    for row in arrays["hasARCtaints"]:
        logger.debug(row)
        for j in row:
            if j == "true":
                j = "true "
            if first:
                first = False
                cle_instance += (f" {j} ")
            else:
                cle_instance += (f", {j} ")
        cle_instance += ("\n")
    cle_instance += (" ]); \n")

    numElts = 0
    for i in arrays["hasARCtaints"]:
        for j in i:
            numElts+=1
    if numFunctionCDFS * numCleLabels != numElts:
        logger.debug("hasARCtaints has incorrect dimensions")
        raise DimensionError("hasARCtaints has incorrect dimensions")

    logger.debug(enums)
    logger.debug(arrays)

    return ZincSrc(cle_instance, enclave_instance)   
   
    
# Parse command line argumets
def get_args():
  p = ArgumentParser(description='CLOSURE Language Extensions JSON Processor')
  p.add_argument('-f', '--file', required=True, type=str, help='Input file')
  return p.parse_args()


def main():
    args   = get_args()
    logger = logging.getLogger()
    handler = logging.StreamHandler(sys.stderr)
    logger.addHandler(handler)
    logger.setLevel(logging.DEBUG)
    with open('tests/example/orange/tmp/pdg_instance.mzn') as pdg_f:
        pdg_instance = pdg_f.read()
    with open('tests/example/orange/tmp/functionArgs.txt') as fn_args_f:
        function_args = fn_args_f.read()
    with open('tests/example/orange/tmp/pdg_data.csv') as pdg_f:
        pdg_data = list(csv.reader(
            pdg_f, quotechar='"', skipinitialspace=True))
    try:
        with open('tests/example/orange/tmp/oneway.txt') as one_way_f:
            one_way = one_way_f.read()
    except:
        one_way = ""
#   print(args.file)
    f = open(args.file,"r")
    cle_json=json.load(f)
    src = compute_zinc(cle_json,function_args,pdg_instance,one_way,logger)
    with open("cle_instance.mzn", "w") as cle_f:
        cle_f.write(src.cle_instance)
    with open("enclave_instance.mzn", "w") as enclave_f:
        enclave_f.write(src.enclave_instance)


if __name__ == '__main__':
  main()
