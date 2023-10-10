#! /usr/bin/env python3
import argparse
import subprocess
import os
from dataclasses import dataclass
from pathlib import Path


def submodules() -> None:
    subprocess.check_call(['git', 'submodule', 'init'])
    subprocess.check_call(['git', 'submodule', 'update'])


def build_ect() -> None:
    cwd = Path('ect')
    z3_lib = (cwd / 'z3-4.8.8' / 'lib').resolve()
    env = dict(os.environ, **{'LD_LIBRARY_PATH': z3_lib})
    subprocess.check_call(['stack', 'build'], cwd=cwd, env=env)

def build_pdg() -> None:
    cwd = Path('pdg2')
    subprocess.check_call(['cmake', '-B', 'build'], cwd=cwd)
    subprocess.check_call(
        ['cmake', '--build', 'build', '--', '-j', '8'], cwd=cwd)

def build_verifier() -> None:
    cwd = Path('compliance')
    subprocess.check_call(['make', '-j', '8'], cwd=cwd)


def build_gedl() -> None:
    cwd = Path('gedl')
    subprocess.check_call(['cmake', '-B', 'build'], cwd=cwd)
    subprocess.check_call(
        ['cmake', '--build', 'build', '--', '-j', '8'], cwd=cwd)


def clean_pdg() -> None:
    cwd = Path('pdg2')
    subprocess.check_call(['rm', '-rf', 'build'], cwd=cwd)

def clean_verifier() -> None:
    cwd = Path('compliance')
    subprocess.check_call(['make', 'clean'], cwd=cwd)


def clean_gedl() -> None:
    cwd = Path('gedl')
    subprocess.check_call(['rm', '-rf', 'build'], cwd=cwd)


@dataclass
class Args:
    clean: bool


def build() -> None:
    submodules()
    build_pdg()
#    build_ect()
    build_gedl()
#    build_verifier()


def clean() -> None:
    clean_pdg()
    clean_gedl()
    clean_verifier()


def main() -> None:
    parser = argparse.ArgumentParser('build.py')
    parser.add_argument('--clean', '-c', action='store_true', default=False)
    args = parser.parse_args(namespace=Args)
    if args.clean:
        clean()
    else:
        build()


if __name__ == '__main__':
    main()

