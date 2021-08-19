All functions that are in the cut must be annotatd. Below, bar is in the cut, but isn't annotated.

```
int bar() {
#pragma cle begin PURPLE 
    static int i = 0;
#pragma cle end PURPLE 
    return i++;
}

int foo() {
#pragma cle begin ORANGE 
    static int j = 0;
#pragma cle end ORANGE 
    j++
    return bar() + j;    
}
```