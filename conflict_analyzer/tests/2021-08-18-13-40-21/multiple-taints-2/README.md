An unannotated function can only have one label taint shared across its args, body and return.
Here in `foo()`, there are two labels 'ORANGE' and 'ORANGE_SHAREABLE', because
'ORANGE_SHAREABLE' is propagated by calling `baz()`, which has the label taint 'ORANGE_SHAREABLE'

```c
int baz() {
#pragma cle begin ORANGE_SHAREABLE
    static int x = 1;
#pragma cle end ORANGE_SHAREABLE
    x++;
    return x;
}

int foo() {
#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE
    y++;
    int x = baz();
    return x + y;
}
```