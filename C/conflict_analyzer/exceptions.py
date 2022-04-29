from dataclasses import dataclass
from pathlib import Path
from subprocess import CompletedProcess
from typing import List, Optional

@dataclass
class Position:
    line: int
    character: Optional[int]

@dataclass
class Range:
    start: Position
    end: Optional[Position]

@dataclass
class Source:
    path: Path
    range: Optional[Range]

class SourcedException(Exception):
    def __init__(self, message: str, sources: List[Source]):
        self.message = message
        self.sources = sources

    def __str__(self):
        out = [] 
        out.append(f"Error: {self.message}")
        is_long = len(self.message.splitlines()) > 1
        if is_long:
            out.append("")
        for source in self.sources:
            range_msg = f":{source.range.start.line}" if source.range else "" 
            where = 'at' if source.range else 'in' 
            if is_long:
                out.append(f"{where} {str(source.path)}{range_msg}")
            else:
                out.append(f"\t{where} {str(source.path)}{range_msg}")
        return "\n".join(out)

class ProcessException(Exception):
    def __init__(self, message: str, proc: CompletedProcess):
        self.message = message
        self.proc = proc
    
    def __str__(self):
        return f"\n\n{self.message} with returncode {self.proc.returncode}:\n{self.proc.stdout}\n{self.proc.stderr}" 