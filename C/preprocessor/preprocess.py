from os import PathLike
from typing import Dict, List, Literal, Optional, Tuple, TypedDict
from pathlib import Path
from dataclasses import dataclass
import json
import jsonschema
import re

Guarddirective = TypedDict('Guarddirective', {
    'operation': Optional[Literal['allow', 'block', 'redact']],
    'oneway': Optional[bool],
    'gapstag': List[int]
})

Cdf = TypedDict('Cdf', {
    'remotelevel': str,
    'direction': Literal['egress', 'ingress', 'bidirectional'],
    'guarddirective': Guarddirective,
    'argtaints': Optional[List[List[str]]],
    'codtaints': Optional[List[str]],
    'rettaints': Optional[List[str]]
})

CleJson = TypedDict('CleJson', {'level': str, 'cdf': Optional[List[Cdf]]})
LabelledCleJson = TypedDict(
    'LabelledCleJson', {'cle-label': str, 'cle-json': CleJson})

@dataclass
class Transform:
    preprocessed: str
    source_map: Dict[int, int]
    cle_json: List[LabelledCleJson]


AnnotationStyle = Literal['naive', 'type', 'both'] 

class Preprocessor:
    def __init__(self, annotation_style: AnnotationStyle = 'naive', schema: Optional[Path] = None) -> None:
        self.annotation_style = annotation_style
        self.schema = schema

    def _parse_cle_def(self, idx: int, lines: List[str]) -> Optional[LabelledCleJson]: 
        def_match = re.match(r'#\s*pragma\s+cle\s+def\s+(\w+)\s+(.*)', lines[idx])

        def traverse_until_end(begin_json: str) -> List[str]:
            out: List[str] = []
            for i in range(idx, len(lines)):
                line = lines[i]
                if i == idx:
                    out.append(begin_json)
                else:
                    out.append(line)

                if re.search(r'(\\\s*)$', line) is None:
                    break
            return out

        if def_match:
            label = def_match.group(1)
            lines = traverse_until_end(def_match.group(2)) 
            rawjson = "\n".join([ line.replace('\\', '') for line in lines ])
            clejson = json.loads(rawjson)
            if self.schema:
                jsonschema.validate(clejson, schema=json.loads(self.schema.read_text()))
            return { "cle-label": label, "cle-json": clejson }
        else:
            return None

    def begin_line(self, label: str) -> Tuple[int, str]:
        output_str = ""
        offset = 0
        if self.annotation_style == 'naive' or self.annotation_style == 'both':  
            output_str += f'#pragma clang attribute push (__attribute__((annotate("{label}"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))'
            offset += 1
        if self.annotation_style == 'type' or self.annotation_style == 'both':
            output_str += f'#pragma clang attribute push (__attribute__((type_annotate("{label}"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))'
            offset += 1
        return offset, output_str

    def preprocess(self, path: PathLike) -> Transform:
        p = Path(path) 
        lines = p.read_text().splitlines()
        jsons : List[LabelledCleJson] = []

        output_lines: List[str] = []
        cur_offset = 0
        offset_dict: Dict[int, int] = {}

        for (i, line) in (it := enumerate(lines)):
            begin_match = re.match(r'#pragma cle begin (\w+)', line)
            single_line_match = re.match(r'#pragma cle (\w+)', line)
            end_match = re.match(r'#pragma cle end (\w+)', line)

            if (cledef := self._parse_cle_def(i, lines)):
                jsons.append(cledef)
                output_lines.append(line)

            elif begin_match: 
                label = begin_match.group(1)
                offset, begin_line = self.begin_line(label)
                output_lines.extend([line, begin_line])

                for i in range(cur_offset, cur_offset + offset):
                    offset_dict[i] = cur_offset 
                cur_offset += offset 

            elif end_match:
                output_lines.extend(["#pragma clang attribute pop", line])
                offset_dict[cur_offset + 1] = cur_offset 
                offset_dict[cur_offset] = cur_offset 
                cur_offset += 2

            elif single_line_match:
                label = single_line_match.group(1)
                offset, begin_line = self.begin_line(label)
                output_lines.extend([line, begin_line])

                for i in range(cur_offset, cur_offset + offset):
                    offset_dict[i] = cur_offset 
                cur_offset += offset 

                _, next_line = next(it) 

                output_lines.extend([next_line, "#pragma clang attribute pop"])
                offset_dict[cur_offset + 1] = cur_offset 
                offset_dict[cur_offset] = cur_offset 
                cur_offset += 2

            else:
                output_lines.append(line)
                offset_dict[cur_offset] = cur_offset
                cur_offset += 1

        return Transform("\n".join(output_lines) + "\n", offset_dict, jsons) 
