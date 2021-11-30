The number of elements inside `argtaints` must match the number
of arguments that a function has.

```c
#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "argtaints": [["ORANGE"]], \
     "codtaints": ["ORANGE"], \
     "rettaints": ["ORANGE", "TAG_RESPONSE_FOO"] \
    } \
 ] }

#pragma cle begin ORANGE
int foo() {
#pragma cle end ORANGE
    return 1;
}
```
Here, the definition of 'ORANGE' label implies that `foo` has one argument,
but `foo` actually has none.