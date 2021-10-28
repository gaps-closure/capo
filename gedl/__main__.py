import argparse
from pathlib import Path
import tempfile
from dataclasses import dataclass
from typing import Any, List, Optional, Tuple, Union
from preprocessor import __main__ as preprocessor
from preprocessor.__main__ import Transform
from logging import Logger
import logging
import subprocess

@dataclass
class Args:
    gedl_lib: Path
    temp_dir: Path
    clang_args: str
    schema: Optional[Path]
    divvied: Path
    heuristics: Path
    output: Optional[Path]

def preprocess(source: Path, clang_args: List[str], schema: Optional[Any], logger: Logger) -> Transform:
    toks = preprocessor.cindex_tokenizer(source, clang_args)
    tree = preprocessor.cle_parser().parser.parse(toks)
    tree = preprocessor.CLETransformer().transform(tree)
    with open(source) as source_f:
        transform = preprocessor.source_transform(source, source_f.read(), tree, 'naive', schema, logger)
    return transform

def compile_c(sources: List[Tuple[str, str]], temp_dir: Path, clang_flags: List[str]) -> bytes: 
    for name, src in sources:
        with open(temp_dir / name, "w") as src_f:
            src_f.write(src)
    source_files = [ temp_dir / name for name, _ in sources ]
    clang_args : List[Union[Path, str]] = ['clang', '-g', '-c', '-emit-llvm', '-S', '-fno-builtin', *[ f.resolve() for f in source_files ], *clang_flags] 
    clang_out = subprocess.run(clang_args, capture_output=True, cwd=temp_dir)
    if clang_out.returncode != 0:
        raise Exception("clang failed", clang_out)
    ll_files = [ source_file.with_suffix('.ll') for source_file in source_files ]
    link_args : List[Union[Path, str]] = ['llvm-link', '-S', *ll_files]   
    link_out = subprocess.run(link_args, capture_output=True, cwd=temp_dir)
    if link_out.returncode != 0:
        raise Exception("llvm-link failed", link_out)
    return link_out.stdout

@dataclass
class TextFiles:
    imported_func: str
    lock_func: str
    static_func: str
    static_funcptr: str
    defined_func: str

def opt1(gedl_so: Path, ll: bytes, temp_dir: Path) -> TextFiles:
    args : List[Union[Path, str]] = ['opt', '-load', gedl_so, '-llvm-test']
    out = subprocess.run(args, capture_output=True, cwd=temp_dir, input=ll)
    if out.returncode != 0:
        raise Exception("opt failed", out)

    def readfile(path: Path) -> str:
        with open(path) as f:
            return f.read()
    imported_func = readfile(temp_dir / 'imported_func.txt')
    lock_func = readfile(temp_dir / 'lock_func.txt')
    static_func = readfile(temp_dir / 'static_func.txt')
    static_funcptr = readfile(temp_dir / 'static_funcptr.txt')
    defined_func = readfile(temp_dir / 'defined_func.txt')
    return TextFiles(imported_func, lock_func, static_func, static_funcptr, defined_func)


def opt2(prog: str, heuristics: Path, gedl_so: Path, ll: bytes, temp_dir: Path) -> str:
    args : List[Union[Path, str]] = ['opt', '-disable-output', '-load', gedl_so, '-accinfo-track', '-d', '1', '-prog', prog, '-he', heuristics]
    out = subprocess.run(args, capture_output=True, cwd=temp_dir, input=ll)
    if out.returncode != 0:
        raise Exception("opt failed", out)
    with open(temp_dir / f"{prog}.gedl") as f:
        return f.read()

def main() -> None:
    parser = argparse.ArgumentParser(description = "GEDL generator")
    parser.add_argument('--gedl-lib', '-g', help="Path to GEDL generator", type=Path, required=True)  
    parser.add_argument('--temp-dir', '-t', help="Temporary working directory", type=Path, default=Path(tempfile.mkdtemp()))
    parser.add_argument('--clang-args', help="Args to pass to clang", type=str, default="")
    parser.add_argument('--schema', help="CLE schema", type=Path, nargs="?", required=False)
    parser.add_argument('--heuristics', help="Heuristics directory", type=Path, required=True)
    parser.add_argument('--output', '-o', help="Output file", type=Path, nargs="?")
    parser.add_argument('divvied', help="Divvied directory", type=Path)  
    args = parser.parse_args(namespace=Args)
    clang_args = args.clang_args.split(",")

    logger = logging.getLogger()
    enclaves = [ f for f in args.divvied.iterdir() if f.is_dir() ]
    lls = []
    for enclave in enclaves:
        enclave_temp_dir = args.temp_dir / enclave.name
        enclave_temp_dir.mkdir(exist_ok=True, parents=True)
        sources = [ f for f in enclave.iterdir() if f.suffix in ['.c', '.h'] ]
        transforms = [ (source, preprocess(source, clang_args, args.schema, logger)) for source in sources ]
        ll = compile_c([ (source_path.name, transform.preprocessed) for (source_path, transform) in transforms ], enclave_temp_dir, clang_args)
        lls.append((enclave.name, ll))
        opt1(args.gedl_lib.resolve(), ll, enclave_temp_dir)
    for (name, ll) in lls:
        with open(args.temp_dir / f"{name}.ll", "wb") as f:
            f.write(ll)
    lls_ = [ (args.temp_dir / f"{name}.ll").resolve() for (name, _) in lls ]
    link_out = subprocess.run(['llvm-link', '-S', *lls_], cwd=args.temp_dir, capture_output=True)
    link_out.check_returncode()
    gedl = opt2('temp', args.heuristics.resolve(), args.gedl_lib.resolve(), link_out.stdout, args.temp_dir)
    if args.output:
        with open(args.output, "w") as gedl_f:
            gedl_f.write(gedl)
    else:
        print(gedl)




if __name__ == '__main__':
    main()