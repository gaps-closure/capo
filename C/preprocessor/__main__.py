#!/usr/bin/env python3 
import pickle
from typing import Literal 
import argparse
from pathlib import Path
from dataclasses import dataclass
import json
from .preprocess import Preprocessor 


@dataclass
class Args:
    input_file: Path
    clang_args: str
    annotation_style: Literal['naive', 'type', 'both']
    schema: Path
    pickle: bool
    output: Path

    def __init__(self):
        pass


def parsed_args() -> Args:
    p = argparse.ArgumentParser(
        description='CLOSURE Language Extensions Preprocessor')
    p.add_argument('-f', '--input-file', required=True,
                type=Path, help='Input file')
    p.add_argument('-a', '--annotation_style', required=False, type=str,
                default='naive', help='Annotation style (naive, type, or both)',
                choices=['naive', 'type', 'both'])
    p.add_argument('-s', '--schema', required=False, type=Path,
                help='override the location of the of the schema if required')
    p.add_argument('-p', '--pickle', help="Produce pickle file with map of offsets.",
                default=False, action='store_true')
    p.add_argument('-o', '--output', type=Path,
                help='Output directory', required=True)
    return p.parse_args(namespace=Args())

def main() -> None:
    args = parsed_args()
    preprocessor = Preprocessor(args.annotation_style, args.schema)
    transform = preprocessor.preprocess(args.input_file)
    (args.output / args.input_file.name.replace(args.input_file.suffix, f'.mod{args.input_file.suffix}')) \
        .write_text(transform.preprocessed)
    (args.output / args.input_file.name.replace(args.input_file.suffix, f'{args.input_file.suffix}.clemap.json')) \
        .write_text(json.dumps(transform.cle_json, indent=2))
    if args.pickle:
        (args.output / args.input_file.name \
            .replace(args.input_file.suffix, f'{args.input_file.name}.{args.input_file.suffix}.pickle')) \
            .write_bytes(pickle.dumps(transform.source_map))

if __name__ == '__main__':
    main()

