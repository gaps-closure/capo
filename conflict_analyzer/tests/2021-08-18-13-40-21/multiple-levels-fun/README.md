A function can only be assigned to one level. Here in `foo()`, there are
two labels with different levels 'purple' and 'orange'. Thus, the user must decide
which one to use.

```c
#pragma cle begin PURPLE
    static int x = 1;
#pragma cle end PURPLE

#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE
```
