#!/usr/bin/env python3

import os
import zmq
import csv
import subprocess
import argparse
import json
import parseMZN
from pathlib import Path
from typing import List, Union, Optional


def main() -> None:
    parser = argparse.ArgumentParser(
        description="""
        Runs the conflict analyzer given an problem instance
        """
    )

    parser.add_argument('--cle-instance','-c', type=Path, help='CLE instance', required=True)
    parser.add_argument('--enclave-instance','-e', type=Path, help='Enclave instance', required=True)
    parser.add_argument('--pdg-instance','-p', type=Path, help='PDG instance', required=True)
    parser.add_argument('--pdg-data','-pd', type=Path, help='PDG data csv', required=True)
    parser.add_argument('--constraints-dir','-cd', type=Path, help='PDG data csv', default=Path('/opt/closure/scripts/constraints'))
    parser.add_argument('--output-dir','-o', type=Path, help='Output directory', default=Path('.'))
    parser.add_argument('--zmq','-z', type=str, 
                    help='ZMQ IP Address (tcp://XXX.XXX.XXX.XXX:PORT)')

    args = parser.parse_args()
    pdg_data_path : Path = args.pdg_data
    cle_instance : Path = args.cle_instance
    enclave_instance : Path = args.enclave_instance
    pdg_instance : Path = args.pdg_instance
    constraints_dir : Path = args.constraints_dir
    output_dir : Path = args.output_dir
    zmq_addr : Optional[str] = args.zmq
    
    constraint_files = [ constraints_dir / file for file in list(os.walk(constraints_dir))[0][2] if file.endswith('.mzn') ]

    with open(pdg_data_path, 'r') as pdg_f:
        pdg_data_csv = csv.reader(pdg_f, quotechar='"', skipinitialspace=True)
        mzn_args : List[Union[Path, str]] = [
            'minizinc',
            '--solver',
            'Gecode',
            cle_instance,
            enclave_instance,
            pdg_instance,
            *constraint_files
        ]  
        minizinc_res = subprocess.run(mzn_args, capture_output=True, encoding='utf-8')
        if minizinc_res.stderr.strip() != '':
            print(minizinc_res.stderr)             
        elif "UNSATISFIABLE" in minizinc_res.stdout:
            findmus_args : List[Union[Path, str]] = [
                'minizinc',
                '--solver',
                'findmus',
                '--subsolver',
                'Gecode',
                '--depth',
                '3',
                '--output-json',
                cle_instance,
                enclave_instance,
                pdg_instance,
                *constraint_files
            ]
            findmus_res = subprocess.run(findmus_args, capture_output=True, encoding='utf-8')
            if findmus_res.stderr.strip() != '':
                print(findmus_res.stderr)
            else:
                result = parseMZN.parseFindMUS(findmus_res.stdout, pdg_data_csv)
                conflicts = result['conflicts']
                with open(output_dir / 'conflicts.json', 'w') as conflicts_f:
                   conflicts_f.write(json.dumps(conflicts, indent=4)) 
                if zmq_addr: 
                    context = zmq.Context()
                    socket = context.socket(zmq.REQ)
                    socket.connect(args.zmq)
                    socket.send_string(json.dumps(result))
                    print(f"Result sent to {zmq_addr}")
        else:
            result = parseMZN.parseAssignment(minizinc_res.stdout, pdg_data_csv)
            topology = result['topology']
            with open(output_dir / 'topology.json', 'w') as topology_f:
                topology_f.write(json.dumps(topology, indent=4)) 
            if zmq_addr: 
                context = zmq.Context()
                socket = context.socket(zmq.REQ)
                socket.connect(args.zmq)
                socket.send_string(json.dumps(result))
                print(f"Result sent to {zmq_addr}")

if __name__ == "__main__":
    main()
        