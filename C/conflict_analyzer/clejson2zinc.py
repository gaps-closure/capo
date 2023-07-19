#!/usr/bin/python3

from argparse import ArgumentParser
from dataclasses import dataclass
import json
from pathlib import Path
import sys
from typing import Dict, List, Set
from logging import Logger
import logging
import itertools

from preprocessor.preprocess import LabelledCleJson

class CLEUsageError(Exception):
    pass

@dataclass
class ZincSrc:
    cle_instance: str
    enclave_instance: str

def validateCle(cle: List[LabelledCleJson], max_fn_parms: int, fn_args: Dict[str,int], no_oneway: Set[str]):

    # For each entry in the list...
    for e in cle:

        # 1. MUST HAVE A 'cle-label' AND 'cle-json'
        if 'cle-label' not in e or 'cle-json' not in e:
            raise CLEUsageError("JSON entries must have a 'cle-label' and 'cle-json'")

    # 2. ALL LABELS MUST BE UNIQUE
    labels_l = [e['cle-label'] for e in cle]
    labels = set(labels_l)
    if len(labels) != len(labels_l): raise CLEUsageError("CLE labels must be unique")

    # For each CLE json...
    for e in cle:
        js = e['cle-json']

        # Generic error handler
        def check(b, s):
            if b: raise CLEUsageError(e['cle-label'] + ": " + s)

        # 3. MUST HAVE A 'level'
        check('level' not in js, "CLE entry must have a 'level' in its 'cle-json'")

        # 4. 'level' MUST NOT BE 'nullLevel'
        check(js['level'] == 'nullLevel', "'level' may not be 'nullLevel'")

        # 5. IF 'cdf' IS PRESENT, IT MUST BE A NON-EMPTY LIST
        check('cdf' in js and (not (type(js['cdf']) is list) or len(js['cdf']) == 0),
              "'cdf' must be non-empty list if it is present")

        # For each CDF...
        cdfs = ([c.copy() for c in js['cdf']] if 'cdf' in js else [])
        prev_taints = None
        for c in cdfs:

            # 6. MUST HAVE A 'remotelevel', 'direction', 'guarddirective'
            check('remotelevel' not in c or 'direction' not in c or 'guarddirective' not in c,
                    "'cdf' must have a 'remotelevel', 'direction', and 'guarddirective'")

            # 7. REMOTE LEVEL MAY NOT BE 'nullLevel'
            check(c['remotelevel'] == 'nullLevel', "'remotelevel' may not be 'nullLevel'")

            # 8. IF 'oneway' IS PRESENT, THE PROGRAM MUST NOT USE THE RETURN VALUE
            check('oneway' in c and e['cle-label'] in no_oneway and c['oneway'] == True,
                  "'oneway' cdf associatd with a function whose return value is used in the PDG")
            
            # 9. 'direction' MUST BE ONE OF 'ingress', 'egress', 'bidirectional'
            #    (direction is not used by the solver)
            check(c['direction'] not in ['ingress', 'egress', 'bidirectional'],
                    "'direction' must be one of 'ingress', 'egress', 'bidirectional'")

            # 10. 'guarddirective' JSON MUST HAVE 'operation', MUST BE ONE OF 'allow', 'redact', 'deny'
            gd = c['guarddirective']
            check('operation' not in gd or gd['operation'] not in ['allow', 'redact', 'deny'],
                    "'guarddirective must have 'operation' which is 'allow', 'redact', or 'deny'")
    
            # 11. ALL OR NONE OF 'argtaints', 'codtaints', 'rettaints' MUST BE PRESENT
            all_taints = 'argtaints' in c and 'codtaints' in c and 'rettaints' in c
            any_taints = 'argtaints' in c or  'codtaints' in c or  'rettaints' in c
            check(any_taints and not all_taints, "'cdf' must have all taint types or no taints")

            # If there are taints...
            if any_taints:

                # 12. TAINT FIELDS MUST BE LISTS
                flat = lambda l: [i for sl in l for i in sl]
                areLs = lambda l: all([type(sl) is list for sl in l])
                all_lsts = areLs([c['argtaints'], c['codtaints'], c['rettaints']]) and areLs(c['argtaints'])
                check(not all_lsts, "taints must be lists")
                
                # 13. EACH TAINT MUST BE AN EXISTING LABEL OR HAVE THE FORM "TAG_[REQUEST|RESPONSE]_{suffix}"
                taints = c['codtaints'] + c['rettaints'] + flat(c['argtaints'])
                for t in taints:
                    check(t not in labels and t[:12] != "TAG_REQUEST_" and t[:13] != "TAG_RESPONSE_",
                          "Each taint must be a label or 'TAG_[REQUEST|RESPONSE]_\{suffix\}'")

                # 14. THE LENGTH OF 'argtaints' MUST NOT EXCEED THE MAXIMUM FUNCTION ARGUMENTS
                check(len(c['argtaints']) > max_fn_parms,
                    "'argtaints' length may not exceed maximum function args ({})".format(max_fn_parms))
                
                # 15. THE LENGTH OF 'argtaints' MUST MATCH THE NUMBER OF ACTUAL ARGUMENTS IF PROVIDED
                check(e['cle-label'] in fn_args and len(c['argtaints']) != fn_args[e['cle-label']],
                      "'argtaints' length must match actual number of function arguments")
                
                # 16. IF MULTIPLE CDFS ARE PRESENT, THEY MUST HAVE THE SAME TAINTS
                taint_tpl = (c['codtaints'], c['rettaints'], c['argtaints'])
                check(prev_taints and prev_taints != taint_tpl,
                      "cdfs for a label must all have identical taints")
                prev_taints = taint_tpl
            else:
                prev_taints = (None, None, None)
                
        # 17. NO TWO CDFS FOR THE SAME LABEL MAY SHARE A REMOTE LEVEL
        rlevels = [c['remotelevel'] for c in cdfs]
        check(len(rlevels) != len(set(rlevels)), "cdf 'remotelevels' must be unique")

def toZincSrcValidated(cle: List[LabelledCleJson], max_fn_parms: int, logger: Logger) -> ZincSrc:
    
    # populate level / enclave data
    nn_levels = list({e['cle-json']['level'] for e in cle})
    levels    = ['nullLevel'] + nn_levels
    enclaves  = ['nullEnclave'] + [l + '_E' for l in nn_levels]

    # determine the set of TAG labels
    flat   = lambda l: [i for sl in l for i in sl]
    isFn   = lambda e: 'cdf' in e['cle-json'] and 'codtaints' in e['cle-json']['cdf'][0]
    fnTnts = lambda e: flat([c['codtaints'] + c['rettaints'] + flat(c['argtaints']) for c in e['cle-json']['cdf']])
    taints = set(flat([fnTnts(e) for e in cle if isFn(e)]))
    tags = taints - {e['cle-label'] for e in cle}

    # add synthetic null, TAG, and DFLT labels to JSON copy,
    # and sort with function annotations in front (creates a continuous range for minizinc)
    cle = list(cle)
    cle.sort(key=isFn, reverse=True)
    def addSyntheticLabel(n, data, idx=None):
        label = {'cle-label': n, 'cle-json': data}
        if idx != None: cle.insert(idx, label)
        else: cle.append(label)

    addSyntheticLabel('nullCleLabel', {
        'level': 'nullLevel',
        'cdf': [{
            'remotelevel': 'nullLevel',
            'direction': 'nullDirection',
            'guarddirective': {'operation': 'nullGuardOperation'}
        }]
    }, idx=0)
    for t in tags:      addSyntheticLabel(t, {'level': 'nullLevel'})
    for l in nn_levels: addSyntheticLabel(l + 'DFLT', {'level': l})

    # populate label data
    cle_labels        = [e['cle-label'] for e in cle]
    label_levels      = [e['cle-json']['level'] for e in cle]
    is_fun_annotation = [str(isFn(e)).lower() for e in cle]

    # populate cdf data
    all_cdfs             = []
    from_cle_label       = []
    has_remote_level     = []
    has_direction        = []
    has_guard_op         = []
    is_oneway            = []
    cdf_for_remote_level = []
    has_rettaints        = []
    has_codtaints        = []
    has_arctaints        = []
    has_argtaints        = []
    for e in cle:

        # get the cdfs
        l = e['cle-label']
        cdfs = e['cle-json']['cdf'] if 'cdf' in e['cle-json'] else []
        cdfs = list(filter(lambda c: c['remotelevel'] in levels, cdfs))

        # for each label, we map the cdfs to their remotelevel
        # cdf_at_level is populated below
        cdf_at_level = ['nullCdf'] * len(levels)
        cdf_for_remote_level.append(cdf_at_level)

        # iterate over cdfs to collect general and taint data
        for cdf, i in zip(cdfs, itertools.count(0)):
            cdf_id = l + '_cdf_' + str(i) if l != 'nullCleLabel' else 'nullCdf'
                
            # general cdf data
            all_cdfs.append(cdf_id)
            from_cle_label.append(l)
            has_remote_level.append(cdf['remotelevel'])
            has_direction.append(cdf['direction'])
            has_guard_op.append(cdf['guarddirective']['operation'])
            is_oneway.append(cdf['oneway'] if 'oneway' in cdf else 'false')
            cdf_at_level[levels.index(cdf['remotelevel'])] = cdf_id

            # if it's a function label, collect taint data
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
                cdf_argtaints = [['false'] * len(cle_labels) for _ in range(max_fn_parms)]
                for arg_ts in cdf['argtaints']:
                    for arg_t, j in zip(arg_ts, itertools.count(0)):
                        k = cle_labels.index(arg_t)
                        cdf_argtaints[j][k] = 'true'
                        cdf_arctaints[k] = 'true'
                has_argtaints.append(cdf_argtaints)

                # arctaints
                cdf_arctaints[cle_labels.index(l)] = 'true'
                has_arctaints.append(cdf_arctaints)

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

def toZincSrc(cle: List[LabelledCleJson], fn_args: str, pdg: str, one_way: str, logger: Logger) -> ZincSrc:

    # Get maximum function parameters
    # Ugly, but no other way to get this without digging into the opt pass
    def getMaxFnParms(pdg: str) -> int:
        for l in pdg.splitlines():
            if 'MaxFuncParms' in l: return int(l.split()[-1][:-1])
        raise CLEUsageError("MaxFuncParms not found in PDG instance")

    # Convert functionArgs file contents into a dictionary mapping labels to number of args
    def fnArgsToDict(fn_args: str) -> Dict[str,int]:
        args_d = {}
        for l in fn_args.splitlines():
            fs = l.split()
            fn_anno, n_args = fs[0], fs[1]
            if len(fs) == 3: fn_anno, n_args = fs[1], fs[2]
            if fn_anno in args_d and args_d[fn_anno] != int(n_args):
                raise CLEUsageError("Functions with different numbers of arguments use the same CLE label")
            args_d[fn_anno] = int(n_args)
        return args_d
    
    def oneWayToSet(one_way: str) -> Set[str]:
        ow_d = {}
        for l in one_way.splitlines():
            fs = l.split()
            fn_anno, ow = fs[0], fs[1]
            if len(fs) == 3: fn_anno, ow = fs[1], fs[2]
            bf = 1 if fn_anno not in ow_d else ow_d[fn_anno]
            ow_d[fn_anno] = min(int(ow), bf)
        return { anno for anno in ow_d if ow_d[anno] == 0 }

    # First validate the CLE JSON, then convert to mzn
    max_fn_parms = getMaxFnParms(pdg)
    validateCle(cle, max_fn_parms, fnArgsToDict(fn_args), oneWayToSet(one_way))
    return toZincSrcValidated(cle, max_fn_parms, logger)

class Args:
    cle_json: Path
    function_args: Path
    one_way: Path
    pdg_instance: Path
    cle_instance: Path
    enclave_instance: Path
    def __init__(self):
        pass

# parse command line argumets
def get_args() -> Args:
    parser = ArgumentParser(description='CLE Json -> Minizinc utility')
    parser.add_argument('--cle-json', '-j', required=True, type=Path, help='Input collated CLE JSON')
    parser.add_argument('--function-args', '-f', required=True, type=Path, help='function args text file')
    parser.add_argument('--pdg-instance', '-p', required=True, type=Path, help='pdg instance minizinc')
    parser.add_argument('--one-way', '-o', required=True, type=Path, help='one way text file')
    parser.add_argument('--cle-instance', '-c', required=True, type=Path, help='Output cle instance file')
    parser.add_argument('--enclave-instance', '-e', required=True, type=Path, help='Output enclave instance file')
    return parser.parse_args(namespace=Args())

# for testing toZincSrc()
def main():
    args = get_args()
    logger = logging.getLogger()
    handler = logging.StreamHandler(sys.stderr)
    logger.addHandler(handler)
    logger.setLevel(logging.DEBUG)
    output = toZincSrc(
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
