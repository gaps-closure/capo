import argparse
import json
from os import environ
from pathlib import Path
from dataclasses import dataclass
from typing import Any, Dict, List, Literal, Optional, Tuple, Type
from logging import Logger
from conflict_analyzer.compile import compile_c, opt
from conflict_analyzer.minizinc import minizinc
from preprocessor.__main__ import LabelledCleJson, Transform
import preprocessor.__main__ as preprocessor
import conflict_analyzer.clejson2zinc as clejson2zinc
from conflict_analyzer.exceptions import SourcedException, Source
import tempfile
import logging
import sys
import zmq

@dataclass
class Args:
    sources: List[Path]
    temp_dir: Path
    clang_args: str
    schema: Optional[Path]
    pdg_lib: Path
    source_path: Path
    output: Optional[Path]
    zmq: Optional[str]
    constraint_files: List[Path]
    log_level: str 

def preprocess(source: Path, clang_args: List[str], schema: Optional[Any], logger: Logger) -> Transform:
    toks = preprocessor.cindex_tokenizer(source, clang_args)
    tree = preprocessor.cle_parser().parser.parse(toks)
    tree = preprocessor.CLETransformer().transform(tree)
    with open(source) as source_f:
        transform = preprocessor.source_transform(source, source_f.read(), tree, 'naive', schema, logger)
    return transform

@dataclass
class SourceEntity:
    source_path: Path
    preprocessed: str
    cle_json: List[LabelledCleJson]
    source_map: Dict[int, int]

def collate_json(entities: List[SourceEntity]) -> List[LabelledCleJson]: 
    collated = {}
    for entity in entities:
        for obj in entity.cle_json:
            if obj['cle-label'] in collated:
                raise SourcedException(f"Label {obj['cle-label']} is defined twice", [Source(entity.source_path, None)])
            collated[obj['cle-label']] = obj
    return list(collated.values())

def collate_source_map(entities: List[SourceEntity], temp_dir: Path) -> Dict[Tuple[str, int], Tuple[str, int]]:
    src_map = {}
    for entity in entities:
        for key in entity.source_map:
            src_map[(str(temp_dir / entity.source_path.name), key)] = (str(entity.source_path), entity.source_map[key])
    return src_map


def start(args: Type[Args], logger: Logger) -> Optional[Dict[str, Any]]:
    schema = None
    log_level_map = {
        "INFO": logging.INFO,
        "DEBUG": logging.DEBUG,
        "ERROR": logging.ERROR
    }
    level = log_level_map[args.log_level]
    logger.setLevel(level)
    logger.info("Set up logger with log level %s", logging.getLevelName(level))
    clang_args = args.clang_args.split(",")
    if args.schema:
        with open(args.schema) as schema_f:
            schema = json.loads(schema_f.read())
            logger.info("Schema found at %s", args.schema) 
    else:
        logger.info("No schema provided, using liberal mode in preprocessor") 

    def make_source_entity(source: Path) -> SourceEntity:
        transform = preprocess(source, clang_args, schema, logger)
        logger.info("Preprocessed source file %s", source)
        return SourceEntity(source, transform.preprocessed, transform.cle_json, transform.source_map) 

    def analyze() -> Dict[str, Any]:
        entities = [ make_source_entity(source) for source in args.sources ]
        collated = collate_json(entities)
        logger.info("Collated JSON")
        logger.debug("%s", json.dumps(collated, indent=2))
        bitcode = compile_c([ (entity.source_path.name, entity.preprocessed) for entity in entities if entity.source_path.suffix == ".c" ], args.temp_dir, clang_args)
        logger.info("Compiled c files into LLVM IR")
        opt_out = opt(args.pdg_lib.resolve(), bitcode, args.temp_dir) 
        logger.debug(opt_out.pdg_instance)
        logger.info("Produced pdg related data from opt")
        zinc_src = clejson2zinc.compute_zinc(collated, opt_out.function_args, opt_out.pdg_instance, opt_out.one_way, logger) 
        logger.info("Produced minizinc enclave and cle instances")
        logger.debug(zinc_src.cle_instance)
        logger.debug(zinc_src.enclave_instance)
        collated_map = collate_source_map(entities, args.temp_dir) 
        logger.info("Collated source maps")
        out = minizinc(args.temp_dir, zinc_src.cle_instance, opt_out.pdg_instance, zinc_src.enclave_instance, args.constraint_files, opt_out.pdg_csv, args.source_path, collated_map, logger) 
        logger.info("Produced JSON result from minizinc")
        return out

    return analyze()
   


def main() -> None: 
    constraints_def = Path(__file__).parent / 'constraints/conflict_analyzer_constraints.mzn'
    decls_def = Path(__file__).parent / 'constraints/conflict_variable_declarations.mzn'
    parser = argparse.ArgumentParser("Conflict Analyzer") 
    parser.add_argument('sources', help=".c or .h to run through conflict analyzer", type=Path, nargs="+")
    parser.add_argument('--temp-dir', help="Temporary directory.", type=Path, default=Path(tempfile.mkdtemp()), required=False)
    parser.add_argument('--clang-args', help="Arguments to pass to clang", type=str, required=False, default="")
    parser.add_argument('--schema', help="CLE schema", type=Path, nargs="?", required=False)
    parser.add_argument('--pdg-lib', help="Path to pdg lib", 
        type=Path, required=True)
    parser.add_argument('--source-path', help="Source path for output topology. Defaults to current directory", 
        default=Path('.'))
    parser.add_argument('--constraint-files', help="Path to constraint files", 
        type=Path, required=False, nargs="*", default=[constraints_def, decls_def])
    parser.add_argument('--output', help="Output path for topology json",
        type=Path)
    parser.add_argument('--zmq', help="zmq url to post result to", type=str, nargs="?")
    parser.add_argument('--log-level', '-v', choices=[ logging.getLevelName(l) for l in [ logging.DEBUG, logging.INFO, logging.ERROR]] , default="ERROR")
    args = parser.parse_args(namespace=Args)
    
    logger = logging.getLogger()
    handler = logging.StreamHandler(sys.stderr)
    logger.addHandler(handler)
    # formatter = logging.Formatter(f'[%(asctime)s %(levelname)s] %(message)s')
    # handler.setFormatter(formatter)
    # try:
    out = start(args, logger)
    # except Exception as e:
        # logger.error(str(e))
    # else: 
    def output_to_file(path: Path):
        def _out(top: Any):
            with open(path, "w") as f:
                f.write(top)
        return _out
    def err_fn(err: Any):
        print(err) 
        if args.zmq:
            context = zmq.Context()
            socket = context.socket(zmq.REQ)
            socket.bind(args.zmq)
            socket.send(err)

    output_fn = output_to_file(args.output) if args.output else print 
    if out:
        result = out["result"]
        if result == "Success":
            output_fn(json.dumps(out["topology"], indent=2))
        elif result == "Conflict":
            print(out["conflicts"])
            print(json.dumps(out["conflicts"], indent=2))
        else:
            logger.error("Internal error")
                  

    

if __name__ == '__main__':
    main()

