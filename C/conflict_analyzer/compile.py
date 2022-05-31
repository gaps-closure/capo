from pathlib import Path
import subprocess
from typing import List, Tuple, Union
from dataclasses import dataclass
import csv
import sys

from conflict_analyzer.exceptions import ProcessException
csv.field_size_limit(sys.maxsize)

def compile_c(sources: List[Tuple[str, str]], temp_dir: Path, clang_flags: List[str]) -> bytes:
    for name, src in sources:
        with open(temp_dir / name, "w") as src_f:
            src_f.write(src)
    source_files = [temp_dir / name for name, _ in sources]
    clang_args: List[Union[Path, str]] = ['clang', '-g', '-c',
                                          '-emit-llvm', *[f.resolve() for f in source_files], *clang_flags]
    clang_out = subprocess.run(clang_args, capture_output=True, cwd=temp_dir)
    if clang_out.returncode != 0:
        raise ProcessException("clang failed", clang_out)
    bc_files = [source_file.with_suffix('.bc') for source_file in source_files]
    link_args: List[Union[Path, str]] = ['llvm-link', *bc_files]
    link_out = subprocess.run(link_args, capture_output=True, cwd=temp_dir)
    if link_out.returncode != 0:
        raise ProcessException("llvm-link failed", link_out)
    return link_out.stdout


@dataclass
class OptOutput:
    pdg_instance: str
    function_args: str
    pdg_csv: list
    one_way: str

def opt(pdg_so: Path, bitcode: bytes, temp_dir: Path) -> OptOutput:
    out_bc_path = temp_dir / 'out.bc'
    with open(out_bc_path, "wb") as bc_f:
        bc_f.write(bitcode)
    args: List[Union[Path, str]] = ['opt', '-load',
                                    pdg_so, '-minizinc', '-zinc-debug', out_bc_path]
    out = subprocess.run(args, cwd=temp_dir, capture_output=True)
    if out.returncode != 0:
        raise ProcessException("opt failed", out)
    pdg_instance = (temp_dir / 'pdg_instance.mzn').read_text()
    function_args = (temp_dir / 'functionArgs.txt').read_text()
    with open(temp_dir / 'pdg_data.csv') as pdg_f:
        pdg_data = list(csv.reader(
            pdg_f, quotechar='"', skipinitialspace=True))
    # Temporary to easily have or not have oneway.txt
    try:
        one_way = (temp_dir / 'oneway.txt').read_text()
    except:
        one_way = ""
    return OptOutput(pdg_instance, function_args, pdg_data, one_way)

