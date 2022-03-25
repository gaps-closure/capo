#!/usr/bin/python3
# A quick and dirty cle-preprocessor implementation for GAPS-CLOSURE
#
import json
from logging import Logger
import pickle
from typing import Any, Callable, Literal, Optional 
import argparse
from pathlib import Path
from dataclasses import dataclass
from preprocessor.preprocessor import preprocess
import jsonschema
@dataclass
class Args:
    input_file: Path
    clang_args: str
    annotation_style: Literal['naive', 'type', 'both']
    schema: Optional[Path]
    pickle: bool
    output: Path
    def __init__(self):
        pass

def validate_with_schema(schema: Optional[Any]) -> Callable[[dict], None]:
    def validate(inst: dict) -> None:
        if schema is not None:
            jsonschema.validate(inst, schema) 
    return validate

# Create and invoke tokenizer, parser, tree transformer, and source transformer
def main() -> None:
    p = argparse.ArgumentParser(
        description='CLOSURE Language Extensions Preprocessor')
    p.add_argument('-f', '--input-file', required=True,
                   type=Path, help='Input file')
    p.add_argument('-a', '--annotation_style', required=False, type=str,
                   default='naive', help='Annotation style (naive, type, or both)')
    p.add_argument('-s', '--schema', required=False, type=Path,
                   help='override the location of the of the schema if required')
    p.add_argument('-p', '--pickle', help="Produce pickle file with map of offsets.",
                   default=False, action='store_true')
    p.add_argument('-o', '--output', type=Path,
                   help='Output directory', required=True)
    args = p.parse_args(namespace=Args())
    schema = None
    with open(args.input_file) as f:
        source = f.read()  
    if args.schema:
        with open(args.schema) as s:
            schema = json.load(s)
    transform = preprocess(source, args.annotation_style, validate=validate_with_schema(schema))
    src_suffix = f'.mod{args.input_file.suffix}'
    cle_suffix = f'{args.input_file.suffix}.clemap.json'
    with open(args.output / args.input_file.with_suffix(src_suffix).name, 'w') as f:
        f.write(transform.preprocessed)
    with open(args.output / args.input_file.with_suffix(cle_suffix).name, 'w') as f:
        f.write(json.dumps([ defn.to_dict() for defn in transform.cle_json ], indent=2))

    if args.pickle:
        with open(args.output / args.input_file.with_suffix('.pickle').name, 'wb') as f_pickle:
            pickle.dump(transform.source_map, f_pickle)


if __name__ == '__main__':
    main()

