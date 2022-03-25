from .colors import Colors, format 
from typing import Any, Callable, List, Optional, Tuple, TypeVar

class ParseError(Exception):
    def __init__(self, message, input):
        self.message = message
        self.input = input
    def __str__(self):
        inp = self.input.replace('\n', '\n\t')
        return f"\n{format('Parse Error:', Colors.red)}\n\t{self.message}\n{format('while processing input:', Colors.red)}\n\t{inp}"

class EmptyInput(ParseError):
    def __init__(self):
        super().__init__("Input is empty", '')

class EmptyArgs(ParseError):
    def __init__(self, fun_name, input):
        super().__init__(f"Function {fun_name} expected at least one argument", input)

class PredicateError(ParseError):
    def __init__(self, predicate, input):
        super().__init__(f"Predicate {predicate} failed", input)

class ExpectationError(ParseError):
    def __init__(self, expected, actual, input):
        super().__init__(f"Expected '{expected}', got '{actual}'", input)
    

class DuplicateKeyError(ParseError):
    def __init__(self, key, input):
        super().__init__(f"Duplicate key {key}", input)


A = TypeVar('A')
Parser = Callable[[str], Tuple[A, str]]
def parse_char(ch: str) -> Parser:
    def parse(input: str) -> Tuple[str, str]:
        if len(input) == 0:
            raise EmptyInput 
        else:
            c, cs = input[0], input[1:]
            if c == ch:
                return (c, cs)
            else:
                raise ExpectationError(expected=ch, actual=c, input=cs)
    return parse

B = TypeVar('B')
def map_parser(f: Callable[[A], B], p: Parser[A]) -> Parser[B]:
    def parse(input: str) -> Tuple[B, str]:
        x, input = p(input)
        return f(x), input
    return parse

def parse_string(string: str) -> Parser[str]:
    def parse(input: str) -> Tuple[str, str]:
        if len(string) == 0:
            return '', input 
        else:
            c, input = parse_char(string[0])(input)
            cs, input = parse_string(string[1:])(input)
            return c + cs, input
    return parse

def whitespace(input: str) -> Tuple[None, str]:
    if len(input) == 0:
        raise EmptyInput
    else:
        c, cs = input[0], input[1:]
        if c.isspace():
            return None, cs
        else:
            raise ExpectationError("a whitespace character", c, input)

def sep_by_1(p: Parser[A], sep: Parser[Any]) -> Parser[List[A]]:
    def parse(input: str) -> Tuple[List[A], str]:
        x, input = p(input)
        try:
            _, input = sep(input)
            xs, input = sep_by_1(p, sep)(input)
        except ParseError:
            return [x], input
        return [x, *xs], input
    return parse
def sep_by(p: Parser[A], sep: Parser[Any]) -> Parser[List[A]]:
    def parse(input: str) -> Tuple[List[A], str]:
        xs, input = optional(sep_by_1(p, sep))(input)
        if xs is None:
            return [], input
        else:
            return xs, input
    return parse

def some(p: Parser[A]) -> Parser[List[A]]:
    def parse(input: str) -> Tuple[List[A], str]:
        x, input = p(input)
        try:
            xs, input = some(p)(input)
            return [x, *xs], input
        except ParseError:
            return [x], input
    return parse

def optional(p: Parser[A]) -> Parser[Optional[A]]:
    def parse(input: str) -> Tuple[Optional[A], str]:
        try:
            x, input = p(input)
            return x, input
        except:
            return None, input
    return parse

def many(p: Parser[A]) -> Parser[List[A]]:
    def parse(input: str) -> Tuple[List[A], str]:
        xs, input = optional(some(p))(input)
        if xs is None:
            return [], input
        else:
            return xs, input
    return parse

def token(p: Parser[A], w: Parser) -> Parser[A]:
    def parse(input: str) -> Tuple[A, str]:
        x, input = p(input) 
        _, input = many(w)(input)
        return x, input 
    return parse

def pred_char(f: Callable[[str], bool]) -> Parser[str]:
    def parse(input: str) -> Tuple[str, str]:
        if len(input) == 0:
            raise EmptyInput
        else:
            c, cs = input[0], input[1:] 
            if f(c):
                return c, cs
            else:
                raise PredicateError(f, input)  
    return parse

def one_of(*args: Parser[A]) -> Parser[A]:
    if len(args) == 0:
        raise EmptyArgs("one_of", input) 
    def parse(input: str) -> Tuple[A, str]:
        p, ps = args[0], args[1:]
        try:
            return p(input)
        except ParseError as p:
            if len(ps) == 0:
                raise p  
            return one_of(*ps)(input)
    return parse

def token_string(string: str) -> Parser[str]:
    return token(parse_string(string), one_of(whitespace, parse_char('\\')))

def any_string(input: str) -> Tuple[str, str]:
    _, input = parse_char('\"')(input)
    xs, input = many(pred_char(lambda x: x != '\"'))(input)
    _, input = parse_char('\"')(input)
    return "".join(xs), input