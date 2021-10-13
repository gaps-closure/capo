from pathlib import Path
import subprocess
from typing import Iterable, List, Tuple, Union
from dataclasses import dataclass
import csv

def compile_c(sources: List[Tuple[str, str]], temp_dir: Path, clang_flags: List[str]) -> bytes: 
    for name, src in sources:
        with open(temp_dir / name, "w") as src_f:
            src_f.write(src)
    source_files = [ temp_dir / name for name, _ in sources ]
    clang_args : List[Union[Path, str]] = ['clang', '-g', '-c', '-emit-llvm', *[ f.resolve() for f in source_files ], *clang_flags] 
    clang_out = subprocess.run(clang_args, capture_output=True, cwd=temp_dir)
    if clang_out.returncode != 0:
        raise Exception("clang failed", clang_out)
    bc_files = [ source_file.with_suffix('.bc') for source_file in source_files ]
    link_args : List[Union[Path, str]] = ['llvm-link', *bc_files]   
    link_out = subprocess.run(link_args, capture_output=True, cwd=temp_dir)
    if link_out.returncode != 0:
        raise Exception("llvm-link failed", link_out)
    return link_out.stdout

@dataclass
class OptOutput:
    pdg_instance: str
    function_args: str 
    pdg_csv: list


def opt(pdg_so: Path, bitcode: bytes, temp_dir: Path) -> OptOutput:
    out_bc_path = temp_dir / 'out.bc'
    with open(out_bc_path, "wb") as bc_f:
        bc_f.write(bitcode)
    args : List[Union[Path, str]] = ['opt', '-load', pdg_so, '-minizinc', out_bc_path]
    out = subprocess.run(args, cwd=temp_dir, capture_output=True)
    if out.returncode != 0:
        raise Exception("opt failed", out)
    with open(temp_dir / 'pdg_instance.mzn') as pdg_f:
        pdg_instance = pdg_f.read()
    with open(temp_dir / 'functionArgs.txt') as fn_args_f:
        function_args = fn_args_f.read()
    with open(temp_dir / 'pdg_data.csv') as pdg_f:
        pdg_data = list(csv.reader(pdg_f, quotechar='"', skipinitialspace=True))
    with open(temp_dir / 'oneway.txt') as one_way_f:
        one_way = one_way_f.read()
    return OptOutput(pdg_instance, function_args, pdg_data, one_way)