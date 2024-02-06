import argparse
import json
from os import environ
from pathlib import Path
from dataclasses import dataclass
from typing import Any, Dict, List, Literal, Optional, Tuple, Type
from logging import Logger
from conflict_analyzer.compile import compile_c, opt
from conflict_analyzer.pdg_table import PdgLookupTable, PdgLookupNode, PdgLookupEdge, SourceMap
from conflict_analyzer.minizinc import run_model, run_cmdline, Topology, MinizincResult, str_artifact
from conflict_analyzer.pdg2zinc import pdg_to_zinc
from conflict_analyzer.unify_pdg_svf import unify_pdg_svf
from preprocessor.preprocess import LabelledCleJson, Transform
import preprocessor.preprocess as preprocessor
import conflict_analyzer.clejson2zinc as clejson2zinc
from conflict_analyzer.exceptions import SourcedException, FindmusException, Source, ConflictJSON
import tempfile
import logging
import sys
import csv


@dataclass
class Args:
    def __init__(self):
        pass
    sources: List[Path]
    temp_dir: Path
    clang_args: str
    schema: Optional[Path]
    pdg_lib: Path
    source_path: Path
    output: Optional[Path]
    output_json: bool 
    conflicts: Optional[Path]
    constraint_files: List[Path]
    artifact: Optional[Path]
    dump_ptg: Path
    pts_to_algo: str 
    z3_explanation: bool
    log_level: Literal['INFO', 'DEBUG', 'ERROR'] 

SourceEntity = Tuple[Path, Transform] 

def collate_json(entities: List[SourceEntity]) -> List[LabelledCleJson]: 
    collated = {}
    for path, transform in entities:
        for labelledjson in transform.cle_json:
            if labelledjson['cle-label'] in collated:
                raise SourcedException(f"Label {labelledjson['cle-label']} is defined twice", [Source(path, None)])
            collated[labelledjson['cle-label']] = labelledjson
    return list(collated.values())

def collate_source_map(entities: List[SourceEntity], temp_dir: Path) -> SourceMap: 
    src_map = {}
    for path, transform in entities:
        for key in transform.source_map:
            src_map[(str(temp_dir / path.name), key)] = (str(path), transform.source_map[key])    

    def source_map(src: Tuple[str, int]) -> Tuple[str, int]:
        if src in src_map:
            return src_map[src]
        else:
            return src
    return source_map

def output_zinc(src: clejson2zinc.ZincSrc, pdg_instance: str, temp_dir: Path) -> None:
    (temp_dir / 'cle_instance.mzn').write_text(src.cle_instance)
    (temp_dir / 'enclave_instance.mzn').write_text(src.enclave_instance)
    (temp_dir / 'pdg_svf_instance.mzn').write_text(pdg_instance)

def start(args: Args, logger: Logger) -> MinizincResult:
    schema = json.loads(args.schema.read_text()) if args.schema else None
    pre = preprocessor.Preprocessor(schema=schema)
    clang_args = args.clang_args.split(",")

    def make_source_entity(source: Path) -> SourceEntity:
        transform = pre.preprocess(source)
        logger.info("Preprocessed source file %s", source)
        return source, transform 

    def analyze() -> MinizincResult:
        entities = [ make_source_entity(source) for source in args.sources ]
        collated = collate_json(entities)
        with open(args.temp_dir / 'collated.json', "w") as f:
            f.write(json.dumps(collated, indent=4))
        logger.info("Collated JSON")
        logger.debug("%s", json.dumps(collated, indent=2))
        bitcode = compile_c([ (path.name, transform.preprocessed) for path, transform in entities if path.suffix == ".c" ], args.temp_dir, clang_args)
        logger.info("Compiled c files into LLVM IR")
        opt_out = opt(args.pdg_lib, args.dump_ptg, args.pts_to_algo, bitcode, args.temp_dir)
        opt_out.pdg_csv = unify_pdg_svf(opt_out.pdg_csv, opt_out.pdg_ids, opt_out.svf_edges, opt_out.svf_ids)
        with open(args.temp_dir / 'pdg_svf_data.csv', "w") as f:
            writer = csv.writer(f, delimiter=",", quotechar="'")
            for r in opt_out.pdg_csv: writer.writerow(r)
        logger.info("Produced pdg related data from opt")
        max_fn_parms = clejson2zinc.getMaxFnParms(opt_out.pdg_instance)
        zinc_src = clejson2zinc.compute_zinc(collated, opt_out.function_args, max_fn_parms, opt_out.one_way, logger)
        logger.info("Produced minizinc enclave and cle instances")
        logger.debug(zinc_src.cle_instance)
        logger.debug(zinc_src.enclave_instance)
        pdg_instance = pdg_to_zinc(opt_out.pdg_csv, max_fn_parms)
        logger.debug(pdg_instance)
        output_zinc(zinc_src, pdg_instance, args.temp_dir)
        collated_map = collate_source_map(entities, args.temp_dir)
        logger.info("Collated source maps")
        out = run_cmdline([*[ f.read_text() for f in args.constraint_files], 
            zinc_src.cle_instance, pdg_instance, zinc_src.enclave_instance], [], PdgLookupTable(opt_out.pdg_csv), args.temp_dir, collated_map, args.z3_explanation,
            args.temp_dir / 'pdg_svf_data.csv', max_fn_parms, args.temp_dir / 'collated.json', args.temp_dir / 'functionArgs.txt', args.temp_dir / 'oneway.txt')
        logger.info("Produced JSON result from minizinc")
        return out

    return analyze()
   

def parsed_args() -> Args:
    constraints_def = Path(__file__).parent / 'constraints/conflict_analyzer_constraints.mzn'
    decls_def = Path(__file__).parent / 'constraints/conflict_variable_declarations.mzn'
    parser = argparse.ArgumentParser("Conflict Analyzer") 
    parser.add_argument('sources', help=".c or .h to run through conflict analyzer", type=Path, nargs="+")
    parser.add_argument('--temp-dir', help="Temporary directory.", type=Path, default=Path(tempfile.mkdtemp()), required=False)
    parser.add_argument('--clang-args', help="Arguments to pass to clang (paths should be absolute)", type=str, required=False, default="")
    parser.add_argument('--schema', help="CLE schema", type=Path, nargs="?", required=False)
    parser.add_argument('--pdg-lib', help="Path to pdg lib", 
        type=Path, required=True)
    parser.add_argument('--dump-ptg', help="Path to dump-ptg utility", type=Path, required=True)
    parser.add_argument('--pts-to-algo', help="Points-to algorithm that SVF should use (ander, fspta)",
        choices=["ander", "fspta"], default="ander", required=False)
    parser.add_argument('--source-path', help="Source path for output topology. Defaults to current directory", 
        default=Path('.').resolve())
    parser.add_argument('--constraint-files', help="Path to constraint files", 
        type=Path, required=False, nargs="*", default=[constraints_def, decls_def])
    parser.add_argument('--output', help="Output path for topology json",
        type=Path)
    parser.add_argument('--artifact', help="artifact json path", type=Path, required=False)
    parser.add_argument('--conflicts', help="conflicts json path", type=Path, required=False, default=Path("conflicts.json"))
    parser.add_argument('--output-json', help="whether to output json", action='store_true')
    parser.add_argument('--no-z3', help="run findMUS instead of z3 on unsatisfiable minizinc instances", action='store_true')
    parser.add_argument('--log-level', '-v', choices=[ logging.getLevelName(l) for l in [ logging.DEBUG, logging.INFO, logging.ERROR]] , default="ERROR")
    args = parser.parse_args(namespace=Args())
    args.temp_dir = args.temp_dir.resolve()
    args.pdg_lib = args.pdg_lib.resolve()
    args.dump_ptg = args.dump_ptg.resolve()
    args.z3_explanation = not(args.no_z3)
    return args

def setup_logger(log_level: Literal['INFO', 'DEBUG', 'ERROR']) -> Logger:
    logger = logging.getLogger()
    handler = logging.StreamHandler(sys.stderr)
    logger.addHandler(handler)
    log_level_map = {
        "INFO": logging.INFO,
        "DEBUG": logging.DEBUG,
        "ERROR": logging.ERROR
    }
    level = log_level_map[log_level]
    logger.setLevel(level)
    logger.info("Set up logger with log level %s", logging.getLevelName(level))
    # Alternative logging format 
    # formatter = logging.Formatter(f'[%(asctime)s %(levelname)s] %(message)s')
    # handler.setFormatter(formatter)
    return logger

def main() -> None: 
    args = parsed_args()        
    logger = setup_logger(args.log_level)
    out: Optional[MinizincResult] = None
    try:
        out = start(args, logger)
    except FindmusException as e:
        if args.output_json:
            conflicts: List[ConflictJSON] = e.to_conflict_json_list()
        else:
            raise e

    if args.output:
        if out:
            args.output.write_text(
                json.dumps(out.topology(args.source_path), indent=2)
            )
        elif args.conflicts:
            args.conflicts.write_text(
                json.dumps(conflicts)
            )
    if args.output_json:
        if out:
            print(json.dumps({
                "result": "Success",
                "topology": out.topology(args.source_path)
            })) 
        else:
            print(json.dumps({
                "result": "Conflict",
                "conflicts": conflicts 
            })) 
    else:
        assert out is not None # exception reraised
        print(json.dumps(out.topology(args.source_path), indent=2))
        print('\n')
        print(str_artifact(out.artifact(args.source_path)))

    if args.artifact and out:
        args.artifact.write_text(
            str_artifact(out.artifact(args.source_path)) 
        )
                  
if __name__ == '__main__':
    main()

