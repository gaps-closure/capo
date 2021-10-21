#! /usr/bin/env python3
import argparse
from dataclasses import dataclass
from shutil import copyfile
from pathlib import Path
import subprocess
import sys
import build

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

def install_python_package(out: Path) -> None:
    subprocess.run([sys.executable, '-m', 'pip', 'install', '.', '--upgrade', '--target', out])   

def make_env(out: Path) -> None:
    with open(out / 'closureenv', 'a') as env_f: 
        env_f.writelines([
            f'export PYTHONPATH={out.resolve()}:$PYTHONPATH',
            f'export PATH={out.resolve()}/bin:$PATH'
        ])

@dataclass
class Args:
    output: Path

def main() -> None: 
    parser = argparse.ArgumentParser('install.py') 
    parser.add_argument('--output', '-o', default=False, help="Output directory", type=Path, required=True)
    args = parser.parse_args(namespace=Args)
    args.output.mkdir(parents=True, exist_ok=True)
    build.build()
    install_pdg(args.output)
    install_gedl(args.output)
    install_verifier(args.output)
    install_python_package(args.output)
    make_env(args.output)

    
if __name__ == '__main__':
    main()