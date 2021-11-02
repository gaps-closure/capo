#!/usr/bin/python3
# A quick and dirty cle-preprocessor implementation for GAPS-CLOSURE
#
from logging import Logger
from typing import Any, Dict, Generator, Iterator, List, Literal, Optional, Type, TypedDict, cast
from clang.cindex  import Index, TokenKind 
from clang         import cindex
from jsonschema.exceptions import ValidationError
from lark.lexer    import Lexer, Token
import argparse      
from lark          import Lark, Tree
from lark.visitors import Transformer
from pathlib       import Path
from dataclasses   import dataclass
from conflict_analyzer.exceptions import Source, SourcedException, Range, Position
import json
import sys
import os
import os.path
import logging
import pickle
import jsonschema


# Invoke libclang tokenizer
def cindex_tokenizer(f: Path, a: List[str]) -> Iterator[cindex.Token]:
  return Index.create().parse(f,args=a).cursor.get_tokens()

# Transform tokens for CLE parsing
class TypeLexer(Lexer):
  def __init__(self, lexer_conf): pass
  def lex(self, data: Iterator[cindex.Token]) -> Generator[Token, None, None]:
    for x in data:
      if x.kind == TokenKind.PUNCTUATION:
        yield Token('HASH' if x.spelling=='#' else 'PUNCT', x)
      elif x.kind == TokenKind.IDENTIFIER:
        if   x.spelling == 'pragma': yield Token('PRAGMA', x)
        elif x.spelling == 'cle':    yield Token('CLE', x)
        elif x.spelling == 'def':    yield Token('DEF', x)
        elif x.spelling == 'begin':  yield Token('BEGIN', x)
        elif x.spelling == 'end':    yield Token('END', x)
        else:                        yield Token('IDENT', x)
      elif x.kind == TokenKind.LITERAL:
        yield Token('LITERAL', x)
      elif x.kind == TokenKind.COMMENT:
        yield Token('COMMENT', x)
      elif x.kind == TokenKind.KEYWORD:
        if   x.spelling == 'true':   yield Token('TRUE', x)
        elif x.spelling == 'false':  yield Token('FALSE', x)
        else:                        yield Token('KWD', x)
      else:
        raise TypeError(x)

# Grammar and parser for CLE
def cle_parser() -> Lark:
  return Lark(r"""
    acode:       acode_item+
    ?acode_item: cdirective
                 | other
    ?cdirective: cledef
                 | clebegin
                 | cleend
                 | cleappnl
    cleappnl:    pfx label
    clebegin:    pfx begin label
    cleend:      pfx end label
    cledef:      pfx deff label clejson
    pfx:         HASH PRAGMA CLE
    begin:       BEGIN
    end:         END
    deff:        DEF
    label:       IDENT
    clejson:     LITERAL
                 | PUNCT (PUNCT | LITERAL | TRUE | FALSE)+
    other:       COMMENT
                 | nonhash+
                 | HASH (PRAGMA | IDENT | KWD)
                 | HASH HASH (IDENT | KWD)
    ?nonhash:    PUNCT
                 | KWD 
                 | LITERAL 
                 | IDENT
                 | PRAGMA
                 | CLE
                 | DEF
                 | BEGIN
                 | END
                 | TRUE
                 | FALSE
    %declare PUNCT COMMENT KWD LITERAL IDENT HASH PRAGMA CLE DEF BEGIN END TRUE FALSE
  """, start='acode', parser='lalr', lexer=TypeLexer)

# Tranform parsed tree to extract relevant CLE information
class CLETransformer(Transformer):
  def _deraw(self, s):
    return s.replace('R"JSON(','').replace(')JSON"','').replace('\n','')
  def _hlp(self, items: List[Token]):
    return ' '.join([x.value.spelling for x in items])
  def acode(self, items: List[Token]):    return [i for s in items for i in s]
  def other(self, items: List[Token]):    return []
  def begin(self, items: List[Token]):    return []
  def end(self, items: List[Token]):      return []
  def deff(self, items: List[Token]):     return []
  def pfx(self, items: List[Token]):      return items[0].value.extent.start.line
  def label(self, items: List[Token]):    return self._hlp(items)
  def clejson(self, items: List[Token]):  return json.loads(self._deraw(self._hlp(items)))
  def cledef(self, items: List[Token]):   return [['cledef'] + items]
  def clebegin(self, items: List[Token]): return [['clebegin'] + items]
  def cleend(self, items: List[Token]):   return [['cleend'] + items]
  def cleappnl(self, items: List[Token]): return [['cleappnl'] + items]

def validate_cle(tree_entry, schema, path: Path, logger: Logger):
  """validate the CLE entry is valid against the shcema"""
  err = None
  try:
    jsonschema.validate(tree_entry[4],schema)
  except ValidationError as e:
    err = SourcedException(str(e), [Source(path, Range(Position(tree_entry[1], None), None))]) 
  if err:
    raise err
  logger.info("CLE line %d (%s) is valid", tree_entry[1],tree_entry[3])
  return tree_entry[4]

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
  'codttaints': Optional[List[str]],
  'rettaints': Optional[List[str]]
})  

CleJson = TypedDict('CleJson', {'level': str, 'cdf': Optional[List[Cdf]] }) 
LabelledCleJson = TypedDict('LabelledCleJson', {'cle-label': str, 'cle-json': CleJson}) 

@dataclass
class Transform:
  preprocessed: str
  source_map: Dict[int, int] 
  cle_json: List[LabelledCleJson]

# Based on transformed tree create modified source and mappings file
def source_transform(path: Path, source: str, ttree, astyle: str, schema: Any, logger: Logger) -> Transform:
  if(schema is None):
    #schema check is disabled
    defs = [{"cle-label": x[3], "cle-json": x[4]} for x in ttree if x[0] == 'cledef']
  else:
    defs = [{"cle-label": x[3], "cle-json": validate_cle(x, schema, path, logger)} for x in ttree if x[0] == 'cledef']

  curline = 0
  offset = 0
  offsetDic = {}
  unproc = source.splitlines()
  preproc = [] 
  for x in sorted(ttree, key=lambda x: x[1]):
    if x[0] == 'clebegin':
      while curline < x[1] - 1: 
        preproc.append(unproc[curline])
        curline += 1
        offsetDic[curline+offset] = curline
      if astyle == 'naive' or astyle == 'both':
        preproc.append(
          f'#pragma clang attribute push (__attribute__((annotate("{x[3]}"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))'
        )
        offset+=1
        offsetDic[curline+offset] = curline
      if astyle == 'type' or astyle == 'both':
        preproc.append(
          f'#pragma clang attribute push (__attribute__((type_annotate("{x[3]}"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))'
        )
        offset+=1
        offsetDic[curline+offset] = curline
    elif x[0] == 'cleend':
      while curline < x[1]: 
        preproc.append(unproc[curline])
        curline += 1
        offsetDic[curline+offset] = curline
      preproc.append('#pragma clang attribute pop')
      offset+=1
      offsetDic[curline+offset] = curline
  while curline < len(unproc):
    preproc.append(unproc[curline])
    offsetDic[curline+offset] = curline
    curline += 1
  return Transform("\n".join(preproc), offsetDic, cast(List[LabelledCleJson], defs))


@dataclass
class Args:
  input_file: Path
  clang_args: str
  annotation_style: Literal['naive', 'type', 'both']
  schema: Path
  pickle: bool
  output: Path

# Create and invoke tokenizer, parser, tree transformer, and source transformer
def main() -> None:
  p = argparse.ArgumentParser(description='CLOSURE Language Extensions Preprocessor')
  p.add_argument('-f', '--input-file', required=True, type=Path, help='Input file')
  p.add_argument('-c', '--clang_args', required=False, type=str, 
                 default='-x,c++,-stdlib=libc++', help='Arguments for clang')
  p.add_argument('-a', '--annotation_style', required=False, type=str, 
                 default='naive', help='Annotation style (naive, type, or both)')
  p.add_argument('-s', '--schema', required=False, type=Path,
                 help='override the location of the of the schema if required')
  p.add_argument('-p', '--pickle',help="Produce pickle file with map of offsets.",
                 default=False, action='store_true') 
  p.add_argument('-o', '--output', type=Path, help='Output directory', required=True)
  args = p.parse_args(namespace=Args)
  toks = cindex_tokenizer(args.input_file, args.clang_args.split(','))
  tree = cle_parser().parser.parse(toks)
  ttree = CLETransformer().transform(tree)
  try:
    with open(args.input_file) as f:
      with open(args.schema) as s:
        transform = source_transform(args.input_file, f.read(), ttree, args.annotation_style, json.loads(s.read()), logging.getLogger())
  except jsonschema.exceptions.ValidationError as schemaerr:
    print(schemaerr)
    sys.exit(-1)
  src_suffix = f'.mod{args.input_file.suffix}'
  cle_suffix = f'{args.input_file.suffix}.clemap.json'
  with open(args.output / args.input_file.with_suffix(src_suffix).name, 'w') as f: 
    f.write(transform.preprocessed)
  with open(args.output / args.input_file.with_suffix(cle_suffix).name, 'w') as f:
    f.write(json.dumps(transform.cle_json, indent=2))
  
  if args.pickle:
    with open(args.output / args.input_file.with_suffix('.pickle').name, 'wb') as f_pickle:
      pickle.dump(transform.source_map, f_pickle)
  

if __name__ == '__main__':
  main()