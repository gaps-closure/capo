Every label is defined at most once. Here, the label 'ORANGE' is defined multiple times.

```c
#pragma cle def ORANGE {"level":"orange"}
#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "argtaints": [], \
     "codtaints": ["ORANGE"], \
     "rettaints": ["ORANGE", "TAG_RESPONSE_FOO"] \
    } \
 ] }
```

The user must rename, or remove the second definition of 'ORANGE' 