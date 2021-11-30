For any CLE function annotation, the argtaints, the codtaints and the rettaints must all be provided.

```c
#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "rettaints": ["ORANGE", "TAG_RESPONSE_FOO"] \
    } \
```

In the definition for `ORANGE`, only the `rettaints` are provided.