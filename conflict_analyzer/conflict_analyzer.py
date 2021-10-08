import argparse
import json
from pathlib import Path
from dataclasses import dataclass
from conflict_analyzer.compile import compile_c, opt
from conflict_analyzer.minizinc import minizinc
from conflict_analyzer.preprocessor import Transform
from typing import Any, Dict, List, Optional, Tuple
import conflict_analyzer.preprocessor as preprocessor
import tempfile
import conflict_analyzer.clejson2zinc as clejson2zinc

@dataclass
class Args:
    sources: List[Path]
    temp_dir: Path
    clang_args: List[str]
    schema: Optional[Path]
    pdg_lib: Path
    constraint_files: List[Path]

def preprocess(source: Path, clang_args: List[str], schema: Optional[Any]) -> Transform:
    toks = preprocessor.cindex_tokenizer(source, clang_args)
    tree = preprocessor.cle_parser().parser.parse(toks)
    tree = preprocessor.CLETransformer().transform(tree)
    with open(source) as source_f:
        transform = preprocessor.source_transform(source_f.read(), tree, 'naive', None)
    return transform

def collate_json(jsons: List[List[Dict[str, Any]]]) -> List[Dict[str, Any]]: 
    collated = {}
    for cle_json in jsons:
        for obj in cle_json:
            collated[obj['cle-label']] = obj
    return list(collated.values())

@dataclass
class SourceEntity:
    path: Path
    preprocessed: str
    cle_json: List[Dict[str, Any]]
    source_map: Dict[int, int]


def collate_source_map(entities: List[SourceEntity], temp_dir: Path) -> Dict[Tuple[str, int], Tuple[str, int]]:
    src_map = {}
    for entity in entities:
        for key in entity.source_map:
            src_map[(str(temp_dir / entity.path.name), key)] = (str(entity.path), entity.source_map[key])
    return src_map


def main() -> None: 
    constraints_def = Path('/opt/closure/scripts/constraints/conflict_analyzer_constraints.mzn') 
    decls_def = Path('/opt/closure/scripts/constraints/conflict_variable_declarations.mzn') 

    parser = argparse.ArgumentParser("Conflict Analyzer") 
    parser.add_argument('sources', help=".c or .h to run through conflict analyzer", type=Path, nargs="+")
    parser.add_argument('--temp-dir', help="Temporary directory.", type=Path, default=Path(tempfile.mkdtemp()), required=False)
    parser.add_argument('--clang-args', help="Arguments to pass to clang", type=str, nargs="*", required=False, default=[])
    parser.add_argument('--schema', help="CLE schema", type=Path, nargs="?", required=False)
    parser.add_argument('--pdg-lib', help="Path to pdg lib", 
        type=Path, required=False, default=Path('/opt/closure/lib/libpdg.so'))
    parser.add_argument('--constraint-files', help="Path to constraint files", 
        type=Path, required=False, nargs="*", default=[constraints_def, decls_def])
    args = parser.parse_args(namespace=Args)
    schema = None

    if args.schema:
        with open(args.schema) as schema_f:
            schema = json.loads(schema_f.read())

    def make_source_entity(source: Path) -> SourceEntity:
        transform = preprocess(source, args.clang_args, schema)
        return SourceEntity(source, transform.preprocessed, transform.cle_json, transform.source_map) 

    entities = [ make_source_entity(source) for source in args.sources ]
    collated = collate_json([ entity.cle_json for entity in entities ])
    bitcode = compile_c([ (entity.path.name, entity.preprocessed) for entity in entities ], args.temp_dir, args.clang_args)
    opt_out = opt(args.pdg_lib, bitcode, args.temp_dir) 
    zinc_src = clejson2zinc.compute_zinc(collated, opt_out.function_args, opt_out.pdg_instance) 
    collated_map = collate_source_map(entities, args.temp_dir) 
    out = minizinc(args.temp_dir, zinc_src.cle_instance, opt_out.pdg_instance, zinc_src.enclave_instance, args.constraint_files, opt_out.pdg_csv, collated_map) 
    print(json.dumps(out, indent=2))


if __name__ == '__main__':
    main()

