from dataclasses import dataclass
import json
from typing import Any, Callable, Dict, List, Literal, Optional, Tuple
from .parsing import ParseError, Parser, map_parser, pred_char, many, token_string, one_of

class ToDict:
    def __str__(self):
        return str(self.to_dict())

@dataclass 
class GuardDirective(ToDict):
    operation: Optional[Literal['allow', 'redact', 'deny']]
    oneway: Optional[bool]
    gapstag: Optional[Tuple[int, int, int]]
    def to_dict(self) -> dict:
        d: dict = {}
        if self.operation is not None:
            d['operation'] = self.operation
        if self.oneway is not None:
            d['oneway'] = self.oneway
        if self.gapstag is not None:
            d['gapstag'] = list(self.gapstag)
        return d

@dataclass
class Taints:
    argtaints: List[List[str]]
    codtaints: List[str]
    rettaints: List[str]

@dataclass 
class CDF(ToDict): 
    remotelevel: str 
    direction: Literal['bidirectional', 'ingress', 'egress']  
    guarddirective: Optional[GuardDirective]
    taints: Optional[Taints]
    def to_dict(self) -> dict:
        d: dict = {
            'remotelevel': self.remotelevel,
            'direction': self.direction
        }
        if self.guarddirective is not None:
            d['guarddirective'] = self.guarddirective.to_dict()
        if self.taints is not None:
            d['argtaints'] = self.taints.argtaints
            d['codtaints'] = self.taints.codtaints
            d['rettaints'] = self.taints.rettaints
        return d

@dataclass
class CLEJSON(ToDict):
    level: str 
    cdf: Optional[List[CDF]]
    schema: Optional[str] = None
    comment: Optional[str] = None
    def to_dict(self) -> dict:
        d: dict = {
            'level': self.level,
        }
        if self.cdf is not None:
            d['cdf'] = [ cdf.to_dict() for cdf in self.cdf ], 
        if self.schema is not None:
            d['$schema'] = self.schema,
        if self.comment is not None:
            d['$comment'] = self.comment
        return d
    def __str__(self):
        return str(self.to_dict())

@dataclass
class LabelDefinition(ToDict):
    name: str 
    definition: CLEJSON
    def to_dict(self) -> dict:
        return {
            'cle-label': self.name,
            'cle-json': self.definition.to_dict()
        }
    def __str__(self):
        return str(self.to_dict())

def unserialize_guarddirective(serialized: dict) -> Optional[GuardDirective]:
    if 'guarddirective' in serialized:
        assert type(serialized['guarddirective']) == dict
        serialized_gd = serialized['guarddirective']
        operation: Optional[Literal['allow', 'redact', 'deny']] = serialized_gd.get('operation') 
        oneway: Optional[bool] = serialized_gd.get('oneway')
        tag = serialized_gd.get('gapstag')
        gapstag = None 
        if tag is not None:
            mux, sec, typ = tag
            gapstag = mux, sec, typ
        return GuardDirective(operation, oneway, gapstag)
    else: 
        return None 

def unserialize_cdf(serialized: dict) -> CDF:
    assert 'remotelevel' in serialized
    remotelevel = serialized['remotelevel']
    assert 'direction' in serialized 
    direction: Literal['bidirectional', 'ingress', 'egress'] = serialized['direction']
    guarddirective = unserialize_guarddirective(serialized)
    argtaints: Optional[List[List[str]]] = serialized.get('argtaints')
    codtaints: Optional[List[str]] = serialized.get('codtaints')
    rettaints: Optional[List[str]] = serialized.get('rettaints')
    taints = None
    if argtaints is not None and codtaints is not None and rettaints is not None:
        taints = Taints(argtaints, codtaints, rettaints)
    return CDF(remotelevel, direction, guarddirective, taints)

def unserialize_cle_json(serialized: dict) -> CLEJSON: 
    assert 'level' in serialized
    level = serialized['level']
    cdfs = None
    if 'cdf' in serialized: 
        assert type(serialized['cdf']) == list 
        cdfs = [ unserialize_cdf(cdf) for cdf in serialized['cdf']]
    return CLEJSON(level, cdfs)
    
def parse_cle_json(input: str, validate: Callable[[dict], None]) -> Tuple[CLEJSON, str]:
    lines = input.splitlines()   
    rawstr = ''
    for line in lines:
        rawstr += line.replace('\\', '')
        if "".join(line.split()).endswith('}'):
            break
    rawjson = json.loads(rawstr.strip())
    validate(rawjson)
    return unserialize_cle_json(rawjson), input

def parse_label(input: str) -> Tuple[str, str]:
    c, input = pred_char(lambda x: x.isalnum())(input)     
    cs, input = many(pred_char(lambda x: x.isalnum() or x == '_'))(input)     
    label = c + "".join(cs)
    if label.strip() == "def":
        raise ParseError("Label name cannot be def", input) 
    return label, input

def parse_prefix(pre: str) -> Parser[None]:
    def parse(input: str) -> Tuple[None, str]:
        _, input = token_string('#')(input)
        _, input = token_string('pragma')(input)
        _, input = token_string('cle')(input)
        _, input = token_string(pre)(input)
        return None, input
    return parse


def parse_cle_def(input: str, validate: Callable[[dict], None]) -> Tuple[LabelDefinition, str]:
    _, input = parse_prefix('def')(input)
    label, input = parse_label(input)
    json, input = parse_cle_json(input, validate)
    return LabelDefinition(label, json), input

def parse_cle_begin(input: str) -> Tuple[str, str]:
    _, input = parse_prefix('begin')(input)
    return parse_label(input)

def parse_cle_singleline(input: str) -> Tuple[str, str]:
    _, input = parse_prefix('')(input)
    return parse_label(input)

def parse_cle_start(input: str) -> Tuple[Tuple[str, bool], str]:
    parse_cle_begin_: Parser[Tuple[str, bool]] = map_parser(lambda x: (x, False), parse_cle_begin)
    parse_cle_singleline_: Parser[Tuple[str, bool]] = map_parser(lambda x: (x, True), parse_cle_singleline)
    v, input = one_of(parse_cle_begin_, parse_cle_singleline_)(input)
    return v, input

def parse_cle_end(input: str) -> Tuple[str, str]:
    _, input = parse_prefix('end')(input)
    return parse_label(input)

def parse_definitions(source: str, validate: Callable[[dict], None]) -> List[LabelDefinition]:
    defs = []
    for i in range(len(source)):
        try:
            defn, source = parse_cle_def(source[i:], validate)
            defs.append(defn)
        except ParseError:
            continue
    return defs

Style = Literal['naive', 'type', 'both'] 
def push_attr(label: str, style: Style) -> Tuple[str, int]:
    out = ""
    count = 0
    if style == 'naive' or style == 'both':
        out += f'#pragma clang attribute push (__attribute__((annotate("{label}"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))'
        count += 1
    if style == 'type' or style == 'both':
        out += f'#pragma clang attribute push (__attribute__((type_annotate("{label}"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))'
        count += 1
    return out, count

@dataclass
class Transform(ToDict):
    preprocessed: str
    source_map: Dict[int, int]
    cle_json: List[LabelDefinition]
    def to_dict(self):
        d: dict = {
            'preprocessed': self.preprocessed,
            'source_map': self.source_map,
            'cle_json': [ defn.to_dict() for defn in self.cle_json ]
        }
        return d
                
def preprocess(source: str, style: Style, validate: Callable[[dict], None]) -> Transform:
    defs = parse_definitions(source, validate)
    label = None
    lines = []
    offset = 0
    offsets = {} 
    it = enumerate(source.splitlines())
    for i, line in it:    
        count = 0
        try:
            if label is not None:
                label, _ = parse_cle_end(line)  
                lines.append(line)
                lines.append("#pragma clang attribute pop")
                count = 1
                label = None
            else:
                (label, singleline), _ = parse_cle_start(line)  
                attr, count = push_attr(label, style)
                lines.append(attr)
                lines.append(line)
                if singleline:
                    l, next_line = next(it)
                    lines.append(next_line)
                    lines.append("#pragma clang attribute pop")
                    count += 1
                    label = None
                    for j in range(count + 1):
                        offsets[offset+j+l] = l
        except ParseError:
            lines.append(line)
        for j in range(count + 1):
            offsets[offset+j+i] = i
        offset += count
    return Transform("".join([ line + "\n" for line in lines ]), offsets, defs)   


# with open('conflict_analyzer/tests/example1.c') as f:
    # s = f.read()
# print(preprocess(s, 'naive').preprocessed)