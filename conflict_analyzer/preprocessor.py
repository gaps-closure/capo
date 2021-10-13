#!/usr/bin/python3
# A quick and dirty cle-preprocessor implementation for GAPS-CLOSURE
#
from logging import Logger
from typing import Any, Dict, List, Literal, Optional, TypedDict, cast
from clang.cindex  import Index, TokenKind
from lark.lexer    import Lexer, Token
from argparse      import ArgumentParser
from lark          import Lark, Tree
from lark.visitors import Transformer
from pathlib       import Path
from dataclasses   import dataclass
import json
import sys
import os
import os.path
import jsonschema
import pickle


# Invoke libclang tokenizer
def cindex_tokenizer(f,a):
  return Index.create().parse(f,args=a).cursor.get_tokens()

# Transform tokens for CLE parsing
class TypeLexer(Lexer):
  def __init__(self, lexer_conf): pass
  def lex(self, data):
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

def deraw(s):
  return s.replace('R"JSON(','').replace(')JSON"','').replace('\n','')

# Tranform parsed tree to extract relevant CLE information
class CLETransformer(Transformer):
  def _hlp(self, items):
    return ' '.join([x.value.spelling for x in items if isinstance(x, Token)])
  def acode(self, items):    return [i for s in items for i in s]
  def other(self, items):    return []
  def begin(self, items):    return []
  def end(self, items):      return []
  def deff(self, items):     return []
  def pfx(self, items):      return items[0].value.extent.start.line
  def label(self, items):    return self._hlp(items)
  def clejson(self, items):  return json.loads(deraw(self._hlp(items)))
  def cledef(self, items):   return [['cledef'] + items]
  def clebegin(self, items): return [['clebegin'] + items]
  def cleend(self, items):   return [['cleend'] + items]
  def cleappnl(self, items): return [['cleappnl'] + items]

def validate_cle(tree_entry, schema, logger: Logger):
  """validate the CLE entry is valid against the shcema"""
  try:
    jsonschema.validate(tree_entry[4],schema)
  except Exception as e:
    logger.error("Error parsing CLE on line %d for %s",  tree_entry[1], tree_entry[3], exc_info=e)
    raise e
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
def source_transform(source: str, ttree, astyle: str, schema, logger: Logger) -> Transform:
  if(schema is None):
    #schema check is disabled
    defs = [{"cle-label": x[3], "cle-json": x[4]} for x in ttree if x[0] == 'cledef']
  else:
    defs = [{"cle-label": x[3], "cle-json": validate_cle(x, schema, logger)} for x in ttree if x[0] == 'cledef']

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


# Parse command line argumets
def get_args():
  p = ArgumentParser(description='CLOSURE Language Extensions Preprocessor')
  p.add_argument('-f', '--file', required=True, type=str, help='Input file')
  p.add_argument('-c', '--clang_args', required=False, type=str, 
                 default='-x,c++,-stdlib=libc++', help='Arguments for clang')
  p.add_argument('-a', '--annotation_style', required=False, type=str, 
                 default='naive', help='Annotation style (naive, type, or both)')
  p.add_argument('-t', '--tool_chain', required=False, type=str, 
                 default='clang', help='Toolchain (clang)')
  p.add_argument('-s', '--schema', required=False, type=str,
                 default='../../cle-spec/schema/cle-schema.json',
                 help='override the location of the of the schema if required')
  p.add_argument('-L', '--liberal',help="Liberal mode: disable cle schema check",
                 default=False, action='store_true') 
  p.add_argument('-P', '--pickle',help="Produce pickle file with map of offsets.",
                 default=False, action='store_true') 
  p.add_argument('-o', '--output', type=str, help='Output directory')
  
  return p.parse_args()

def get_cle_schema(schema_location):
  basepath = ""
  
  #get the module paths to help find the schema in a relitive to ourself
  if(len(sys.path) > 1):
    basepath = sys.path[0]
  path = os.path.join(basepath,schema_location)
  
  if(not os.path.exists(path)):
    #schema not found relitive to the python enviroment, check a local path
    path = schema_location
    if(not os.path.exists(path)):
      #Unable to get python schema
      raise(IOError("Unable to fild cle schema (expected at): " + path))
  
  #we found the schema load it into ram
  print("Using CLE schema: " + path)
  with open(path,"r",encoding="UTF-8") as schemafile:
    return(json.loads(schemafile.read()))

def check_jsonschema_version():
  """validate the json schema version is new enogh to process
     Draft 7 schemas"""
  if(jsonschema.__version__ < "3.2.0"):
    raise(ModuleNotFoundError("Newer version of jsonschema module required"
      " (>= 3.2.0)"))
