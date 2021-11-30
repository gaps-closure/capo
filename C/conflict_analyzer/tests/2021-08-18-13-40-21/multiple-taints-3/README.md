An unannotated function can only have one label taint shared across its args, body and return.
Here in `foo()`, there are two labels 'ORANGE' and 'ORANGE_SHAREABLE', because the argument
`y` has argtaint 'ORANGE' while the argument `z` has argtaint 'ORANGE_SHAREABLE'. The argument
`z` gets its taint propagated from calling `baz()`.

```c
int baz() {
#pragma cle begin ORANGE_SHAREABLE
    static int z = 1;
#pragma cle end ORANGE_SHAREABLE
    z++;
    return z;
}

int foo(int y, int z) {
    return y + z;
}

#pragma cle begin XD_ORANGE
int get_foo() {
#pragma cle end XD_ORANGE

#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE
    y++;
    int z = baz();
    return foo(y, z);
}


```