#!/usr/bin/python3

from argparse import ArgumentParser
from dataclasses import dataclass
import json
from pathlib import Path
import sys
from collections import defaultdict
from typing import Any, Dict, List
from logging import Logger
import logging
import itertools

from preprocessor.preprocess import LabelledCleJson

class DimensionError(Exception):
    pass

class CLEUsageError(Exception):
    pass

@dataclass
class ZincSrc:
    cle_instance: str
    enclave_instance: str

def compute_zinc(cleJson: List[LabelledCleJson], function_args: str, pdg_instance: str, one_way: str, logger: Logger) -> ZincSrc:

    # get maximum number of function args
    max_fn_parms = 0
    for l in pdg_instance.splitlines():
        if 'MaxFuncParms' in l:
            max_fn_parms = int(l.split()[-1][:-1])
            break
    
    # level / enclave data
    nn_levels = list({e['cle-json']['level'] for e in cleJson})
    levels    = ['nullLevel'] + nn_levels
    enclaves  = ['nullEnclave'] + [l + '_E' for l in nn_levels]

    # determine the set of TAG labels
    flat   = lambda l: [i for sl in l for i in sl]
    isFn   = lambda e: 'cdf' in e['cle-json'] and 'codtaints' in e['cle-json']['cdf'][0]
    fnTnts = lambda e: flat([c['codtaints'] + c['rettaints'] + flat(c['argtaints']) for c in e['cle-json']['cdf']])
    taints = set(flat([fnTnts(e) for e in cleJson if isFn(e)]))
    tags = taints - {e['cle-label'] for e in cleJson}

    # add synthetic null, TAG, and DFLT labels to JSON copy
    cleJson = list(cleJson)
    def addSyntheticLabel(n, data, idx=None):
        label = {'cle-label': n, 'cle-json': data}
        if idx != None: cleJson.insert(idx, label)
        else: cleJson.append(label)
    for t in tags:      addSyntheticLabel(t, {'level': 'nullLevel'})
    for l in nn_levels: addSyntheticLabel(l + 'DFLT', {'level': l})
    addSyntheticLabel('nullCleLabel', {
        'level': 'nullLevel',
        'cdf': [{ 
            'remotelevel': 'nullLevel',
            'direction': 'nullDirection',
            'guarddirective': {'operation': 'nullGuardOperation'}
        }]
    }, idx=0)

    # label data
    cle_labels        = [e['cle-label'] for e in cleJson]
    label_levels      = [e['cle-json']['level'] for e in cleJson]
    is_fun_annotation = ['true' if isFn(e) else 'false' for e in cleJson]

    # cdf data
    one_way_false = {l.split()[0] for l in one_way.splitlines() if l.split()[1] == "false"}
    all_cdfs = []
    from_cle_label = []
    has_remote_level = []
    has_direction = []
    has_guard_op = []
    is_oneway = []
    cdf_for_remote_level = []
    has_rettaints = []
    has_codtaints = []
    has_arctaints = []
    has_argtaints = []
    for e in cleJson:
        l = e['cle-label']
        cdfs = e['cle-json']['cdf'] if 'cdf' in e['cle-json'] else []
        cdf_at_level = ['nullCdf'] * len(levels)
        for cdf, i in zip(cdfs, itertools.count(0)):
            cdf_id = l + '_cdf_' + str(i) if l != 'nullCleLabel' else 'nullCdf'
                
            # general cdf info
            all_cdfs.append(cdf_id)
            from_cle_label.append(l)
            has_remote_level.append(cdf['remotelevel'])
            cdf_at_level[levels.index(cdf['remotelevel'])] = cdf_id
            has_direction.append(cdf['direction'])
            has_guard_op.append(cdf['guarddirective']['operation'])

            # oneway
            if 'oneway' in cdf:
                if l in one_way_false: raise CLEUsageError('Oneway function has uses!')
                is_oneway.append(cdf['oneway'])
            else:
                is_oneway.append('false')

            if isFn(e):

                # codtaints, rettaints
                cdf_arctaints = ['false'] * len(cle_labels)
                def addTaints(name, ts):
                    cdf_taints = ['false'] * len(cle_labels)
                    for t in cdf[name]:
                        j = cle_labels.index(t)
                        cdf_taints[j] = 'true'
                        cdf_arctaints[j] = 'true'
                    ts.append(cdf_taints)
                addTaints('rettaints', has_rettaints)
                addTaints('codtaints', has_codtaints)
                
                # argtaints
                cdf_argtaints = [['false'] * len(cle_labels)] * max_fn_parms
                for arg_ts in cdf['argtaints']:
                    for arg_t, j in zip(arg_ts, itertools.count(0)):
                        k = cle_labels.index(arg_t)
                        cdf_argtaints[j][k] = 'true'
                        cdf_arctaints[k] = 'true'
                has_argtaints.append(cdf_argtaints)

                # arctaints
                cdf_arctaints[cle_labels.index(l)] = 'true'
                has_arctaints.append(cdf_arctaints)
        cdf_for_remote_level.append(cdf_at_level)

    # string conversion helpers
    def mkMznSet(n, br_open, eles):
        br_close = ']' if br_open == '[' else '}'
        return '{} = {} {} {};'.format(n, br_open, ', '.join(eles), br_close)
    def mkMznArr(n, dims, eles):
        d = len(dims)
        eles_s = ""
        if d == 2: eles_s = ",\n  ".join([", ".join(e) for e in eles])
        else:      eles_s = ",\n  ".join([", ".join(flat(e)) for e in eles])
        return '{} = array{}d({}, [\n  {}\n]);'.format(n, d, ", ".join(dims), eles_s)

    # enclave instance
    enc_s = '\n'.join([
        mkMznSet('Level', '{', levels),
        mkMznSet('Enclave', '{', enclaves),
        mkMznSet('hasEnclaveLevel', '[', levels)
    ])

    # cle instance
    cle_s = '\n'.join([
        mkMznSet('cleLabel', '{', cle_labels),
        mkMznSet('hasLabelLevel', '[', label_levels),
        mkMznSet('isFunctionAnnotation', '[', is_fun_annotation),
        mkMznSet('cdf', '{', all_cdfs),
        mkMznSet('fromCleLabel', '[', from_cle_label),
        mkMznSet('hasRemotelevel', '[', has_remote_level),
        mkMznSet('hasDirection', '[', has_direction),
        mkMznSet('hasGuardOperation', '[', has_guard_op),
        mkMznSet('isOneway', '[', is_oneway),
        mkMznArr('cdfForRemoteLevel', ['cleLabel', 'Level'], cdf_for_remote_level),
        mkMznArr('hasRettaints', ['functionCdf', 'cleLabel'], has_rettaints),
        mkMznArr('hasCodtaints', ['functionCdf', 'cleLabel'], has_codtaints),
        mkMznArr('hasArgtaints', ['functionCdf', 'parmIdx', 'cleLabel'], has_argtaints),
        mkMznArr('hasARCtaints', ['functionCdf', 'cleLabel'], has_arctaints)
    ])
    
    return ZincSrc(cle_s, enc_s)

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
    max_fn_parms = 0
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

                ARCTaint = [str(a=='true' or b=='true').lower()  for a, b in zip(ARCTaint, arcEntry)]
                
                actualParamCount = len(cdf["argtaints"]) -1
                paramCount = 0
                paramEntry = []
                while paramCount < maxArgIdx:
                    for label in enums["cleLabel"]:
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
   

class Args:
    cle_json: Path
    function_args: Path
    one_way: Path
    pdg_instance: Path
    cle_instance: Path
    enclave_instance: Path
    def __init__(self):
        pass
# Parse command line argumets
def get_args() -> Args:
    parser = ArgumentParser(description='CLE Json -> Minizinc utility')
    parser.add_argument('--cle-json', '-j', required=True, type=Path, help='Input collated CLE JSON')
    parser.add_argument('--function-args', '-f', required=True, type=Path, help='function args text file')
    parser.add_argument('--pdg-instance', '-p', required=True, type=Path, help='pdg instance minizinc')
    parser.add_argument('--one-way', '-o', required=True, type=Path, help='one way text file')
    parser.add_argument('--cle-instance', '-c', required=True, type=Path, help='Output cle instance file')
    parser.add_argument('--enclave-instance', '-e', required=True, type=Path, help='Output enclave instance file')
    return parser.parse_args(namespace=Args())

def main():
    args   = get_args()
    logger = logging.getLogger()
    handler = logging.StreamHandler(sys.stderr)
    logger.addHandler(handler)
    logger.setLevel(logging.DEBUG)
    output = compute_zinc(
        json.loads(args.cle_json.read_text()),
        args.function_args.read_text(),
        args.pdg_instance.read_text(),
        args.one_way.read_text(),
        logger
    )
    args.cle_instance.write_text(output.cle_instance)
    args.enclave_instance.write_text(output.enclave_instance)

if __name__ == '__main__':
  main()
