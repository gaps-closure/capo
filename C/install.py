#! /usr/bin/env python3
import argparse
from dataclasses import dataclass
from shutil import copyfile, copytree
from pathlib import Path
import subprocess
import sys
import os
from typing import Dict, Optional, Type

def install_pdg(out: Path) -> None:
    path = Path('pdg2')
    out_lib = out / 'lib' 
    out_lib.mkdir(parents=True, exist_ok=True)
    copyfile(path / 'build' / 'libpdg.so', out_lib / 'libpdg.so')

def install_gedl(out: Path) -> None:
    path = Path('gedl')
    out_lib = out / 'lib' 
    out_lib.mkdir(parents=True, exist_ok=True)
    copyfile(path / 'build' / 'libgedl.so', out_lib / 'libgedl.so')

def install_verifier(out: Path) -> None:
    path = Path('compliance')
    out_bin = out / 'bin'
    out_bin.mkdir(parents=True, exist_ok=True)
    copyfile(path / 'verifier', out_bin / 'verifier')
    os.chmod(out_bin / 'verifier', 0o755)

def install_ect(out: Path) -> None:
    cwd = Path('ect')
    z3_lib = cwd / 'z3-4.8.8' / 'lib'
    env: dict = dict(os.environ, **{'LD_LIBRARY_PATH': z3_lib})
    subprocess.check_call(['stack', 'install', '--local-bin-path', out / 'bin'], cwd=cwd, env=env)

def install_python_package(out: Path) -> None:
    subprocess.run([sys.executable, '-m', 'pip', 'install', '.', '--target', out / 'python'])   


def install_gedl_schema(out: Path) -> None:
    path = Path('gedl') / 'schema'
    out_schemas = out / 'schemas'
    out_schemas.mkdir(parents=True, exist_ok=True)
    copyfile(path / 'gedl-schema.json', out_schemas / 'gedl-schema.json')

@dataclass
class Args:
    output: Path

def install(args: Type[Args], should_install_python_package: bool = False) -> Dict[str, str]:
    args.output = args.output.resolve()
    install_pdg(args.output)
    install_gedl(args.output)
    install_verifier(args.output)
    install_gedl_schema(args.output)
    install_ect(args.output)
    if should_install_python_package:
        install_python_package(args.output)
    return {
        "PATH": f"{args.output}/bin:{args.output}/python/bin",
        "PYTHONPATH": f"{args.output}/python",
    }

def main() -> None: 
    import build
    parser = argparse.ArgumentParser('install.py') 
    parser.add_argument('--output', '-o', default=False, help="Output directory", type=Path, required=True)
    args = parser.parse_args(namespace=Args)
    args.output.mkdir(parents=True, exist_ok=True)
    build.build()
    install(args, True)
    
if __name__ == '__main__':
    main()