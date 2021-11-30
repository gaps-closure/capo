Here `get_foo()` is only allowed the body taint of 'ORANGE', but it receives body taint 'ORANGE_SHAREABLE' from `baz`, which isn't allowed in the 'XD_ORANGE' label.

```c
#pragma cle def XD_ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow" }, \
     "argtaints": [], \
     "codtaints": ["ORANGE"], \
     "rettaints": ["ORANGE", "ORANGE_SHAREABLE", "TAG_RESPONSE_GET_FOO"] \
    } \
 ] }

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
    return x + y;
}

#pragma cle begin XD_ORANGE
int get_foo() {
#pragma cle end XD_ORANGE
    int x = baz();
    return x + foo();
}

```