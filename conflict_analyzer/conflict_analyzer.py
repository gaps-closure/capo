import argparse
import json
from pathlib import Path
from dataclasses import dataclass
from typing import Any, Dict, List, Literal, Optional, Tuple
from logging import Logger
from conflict_analyzer.compile import compile_c, opt
from conflict_analyzer.minizinc import minizinc
from conflict_analyzer.preprocessor import LabelledCleJson, Transform
import conflict_analyzer.preprocessor as preprocessor
import conflict_analyzer.clejson2zinc as clejson2zinc
import tempfile
import logging
import sys

@dataclass
class Args:
    sources: List[Path]
    temp_dir: Path
    clang_args: str
    schema: Optional[Path]
    pdg_lib: Path
    constraint_files: List[Path]
    log_level: str 

def preprocess(source: Path, clang_args: List[str], schema: Optional[Any], logger: Logger) -> Transform:
    toks = preprocessor.cindex_tokenizer(source, clang_args)
    tree = preprocessor.cle_parser().parser.parse(toks)
    tree = preprocessor.CLETransformer().transform(tree)
    with open(source) as source_f:
        transform = preprocessor.source_transform(source_f.read(), tree, 'naive', None, logger)
    return transform

@dataclass
class SourceEntity:
    source_path: Path
    preprocessed: str
    cle_json: List[LabelledCleJson]
    source_map: Dict[int, int]

def collate_json(jsons: List[List[LabelledCleJson]]) -> List[LabelledCleJson]: 
    collated = {}
    for cle_json in jsons:
        for obj in cle_json:
            collated[obj['cle-label']] = obj
    return list(collated.values())

def collate_source_map(entities: List[SourceEntity], temp_dir: Path) -> Dict[Tuple[str, int], Tuple[str, int]]:
    src_map = {}
    for entity in entities:
        for key in entity.source_map:
            src_map[(str(temp_dir / entity.source_path.name), key)] = (str(entity.source_path), entity.source_map[key])
    return src_map


def main() -> None: 
    constraints_def = Path('/opt/closure/scripts/constraints/conflict_analyzer_constraints.mzn') 
    decls_def = Path('/opt/closure/scripts/constraints/conflict_variable_declarations.mzn') 

    parser = argparse.ArgumentParser("Conflict Analyzer") 
    parser.add_argument('sources', help=".c or .h to run through conflict analyzer", type=Path, nargs="+")
    parser.add_argument('--temp-dir', help="Temporary directory.", type=Path, default=Path(tempfile.mkdtemp()), required=False)
    parser.add_argument('--clang-args', help="Arguments to pass to clang", type=str, required=False, default="")
    parser.add_argument('--schema', help="CLE schema", type=Path, nargs="?", required=False)
    parser.add_argument('--pdg-lib', help="Path to pdg lib", 
        type=Path, required=False, default=Path('/opt/closure/lib/libpdg.so'))
    parser.add_argument('--constraint-files', help="Path to constraint files", 
        type=Path, required=False, nargs="*", default=[constraints_def, decls_def])
    parser.add_argument('--log-level', '-v', choices=[ logging.getLevelName(l) for l in [ logging.DEBUG, logging.INFO, logging.ERROR]] , default="ERROR")
    args = parser.parse_args(namespace=Args)
    schema = None

    clang_args = args.clang_args.split(",")
    log_level_map = {
        "INFO": logging.INFO,
        "DEBUG": logging.DEBUG,
        "ERROR": logging.ERROR
    }
    logger = logging.getLogger()
    handler = logging.StreamHandler(sys.stderr)
    formatter = logging.Formatter(f'[%(asctime)s %(levelname)s] %(message)s')
    handler.setFormatter(formatter)
    level = log_level_map[args.log_level]
    logger.setLevel(level)
    logger.addHandler(handler)
    logger.info("Set up logger with log level %s", logging.getLevelName(level))
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

    entities = [ make_source_entity(source) for source in args.sources ]
    collated = collate_json([ entity.cle_json for entity in entities ])
    logger.info("Collated JSON")
    logger.debug("%s", json.dumps(collated, indent=2))
    bitcode = compile_c([ (entity.source_path.name, entity.preprocessed) for entity in entities if entity.source_path.suffix == ".c" ], args.temp_dir, clang_args)
    logger.info("Compiled c files into LLVM IR")
    opt_out = opt(args.pdg_lib, bitcode, args.temp_dir) 
    logger.debug(opt_out.pdg_instance)
    logger.info("Produced pdg related data from opt")
    zinc_src = clejson2zinc.compute_zinc(collated, opt_out.function_args, opt_out.pdg_instance, logger) 
    logger.info("Produced minizinc enclave and cle instances")
    logger.debug(zinc_src.cle_instance)
    logger.debug(zinc_src.enclave_instance)
    collated_map = collate_source_map(entities, args.temp_dir) 
    logger.info("Collated source maps")
    out = minizinc(args.temp_dir, zinc_src.cle_instance, opt_out.pdg_instance, zinc_src.enclave_instance, args.constraint_files, opt_out.pdg_csv, collated_map, logger) 
    logger.info("Produced JSON result from minizinc")
    print(json.dumps(out, indent=2))


if __name__ == '__main__':
    main()

