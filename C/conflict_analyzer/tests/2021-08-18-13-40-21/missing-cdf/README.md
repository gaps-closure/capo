For any CLE function annotation, the argtaints, the codtaints and the rettaints must all be provided.

```c
#pragma cle def ORANGE {"level":"orange"}
```

In the definition for `ORANGE`, no `cdf` field is provided with the taints. Perhaps, the user accidentally
used a global variable annotation in place of a function annotation. 