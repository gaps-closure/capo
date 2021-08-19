An unannotated function can only have one label taint shared across its args, body and return.
Here in `foo()`, there are two labels 'ORANGE' and 'ORANGE_SHAREABLE'. 
```c
#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE

#pragma cle begin ORANGE_SHAREABLE
    static int z = 1;
#pragma cle end ORANGE_SHAREABLE
    y++;
    z++;
    return y + z;
```
The user here must annotate `foo()` and provide the allowed rettaints, argtaints and codtaints explicitly.