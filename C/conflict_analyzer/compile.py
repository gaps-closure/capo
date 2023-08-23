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
    clang_args_ll: List[Union[Path, str]] = ['clang', '-g', '-c', '-S',
                                             '-emit-llvm', *[f.resolve() for f in source_files], *clang_flags]
    clang_out = subprocess.run(clang_args, capture_output=True, cwd=temp_dir)
    clang_out_ll = subprocess.run(clang_args_ll, capture_output=True, cwd=temp_dir)
    if clang_out.returncode != 0 or clang_out_ll.returncode != 0:
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
    pdg_ids: list
    svf_ids: list
    svf_edges: list
    pdg_csv: list
    one_way: str

def run_dump_ptg(dump_ptg: Path, pts: str, out_bc_path: Path, temp_dir: Path):
    args_ptg: List[Union[Path, str]] = [dump_ptg, '-{}'.format(pts), out_bc_path,
                                        'svf_node_to_llid.csv', 
                                        'svf_edges.csv']
    out_ptg = subprocess.run(args_ptg, cwd=temp_dir, capture_output=True)
    if out_ptg.returncode != 0:
        raise ProcessException("dump-ptg failed", out_ptg)
    with open(temp_dir / 'svf_node_to_llid.csv') as svf_f:
        svf_ids = list(csv.reader(svf_f, quotechar="'", skipinitialspace=True))
    with open(temp_dir / 'svf_edges.csv') as svf_f:
        svf_edges = list(csv.reader(svf_f, quotechar="'", skipinitialspace=True))
    return svf_ids, svf_edges

def opt(pdg_so: Path, dump_ptg: Path, pts: str, bitcode: bytes, temp_dir: Path) -> OptOutput:
    
    # Write bytes to .bc file
    out_bc_path = temp_dir / 'out.bc'
    with open(out_bc_path, "wb") as bc_f:
        bc_f.write(bitcode)

    # Get SVF nodes and edges, and pre-processed .bc file
    svf_ids, svf_edges = run_dump_ptg(dump_ptg, pts, out_bc_path, temp_dir)
    out_bc_path = temp_dir / 'out.svf.bc'

    # Get pre-processed ll file
    out = subprocess.run(['llvm-dis', out_bc_path], cwd=temp_dir, capture_output=True)
    if out.returncode != 0:
        raise ProcessException("llvm-dis failed", out)
    
    # Run opt pass on .bc file
    args: List[Union[Path, str]] = ['opt-14', '-enable-new-pm=0', '-load',
                                    pdg_so, '-minizinc', '-zinc-debug', out_bc_path]
    out = subprocess.run(args, cwd=temp_dir, capture_output=True)
    if out.returncode != 0:
        raise ProcessException("opt failed", out)
    
    # Process results of opt
    pdg_instance = (temp_dir / 'pdg_instance.mzn').read_text()
    function_args = (temp_dir / 'functionArgs.txt').read_text()
    with open(temp_dir / 'pdg_node_to_llid.csv') as pdg_f:
        pdg_ids = list(csv.reader(pdg_f, quotechar="'", skipinitialspace=True))
    with open(temp_dir / 'pdg_data.csv') as pdg_f:
        pdg_data = list(csv.reader(
            pdg_f, quotechar="'", skipinitialspace=True))
    try:
        one_way = (temp_dir / 'oneway.txt').read_text()
    except:
        one_way = ""

    return OptOutput(pdg_instance, function_args, pdg_ids, svf_ids, svf_edges, pdg_data, one_way)

