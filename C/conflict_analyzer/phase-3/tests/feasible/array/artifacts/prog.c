#include <stdio.h>

#pragma cle def GREEN {"level":"green"}
#pragma cle def GREEN_SHAREABLE {"level":"green",\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma cle def ORANGE {"level":"orange"}
#pragma cle def ORANGE_SHAREABLE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"green", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma cle def FOO {"level":"orange",\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \ 
     "argtaints": [["TAG_REQUEST_FOO", "ORANGE_SHAREABLE"]], \
     "codtaints" : ["ORANGE", "ORANGE_SHAREABLE"], \
     "rettaints" : ["ORANGE_SHAREABLE", "TAG_RESPONSE_FOO"] \
    }, \
    {"remotelevel":"green", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \ 
     "argtaints": [["TAG_REQUEST_FOO", "ORANGE_SHAREABLE"]], \
     "codtaints" : ["ORANGE", "ORANGE_SHAREABLE"], \
     "rettaints" : ["ORANGE_SHAREABLE", "TAG_RESPONSE_FOO"] \
    } \
  ] \
}


#define SIZE 5

#pragma cle FOO
#pragma clang attribute push (__attribute__((annotate("FOO"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int foo(int* buf) {
#pragma clang attribute pop
    printf("%d\n", buf[0]);
    return 0;
}

int main() {

    #pragma cle GREEN_SHAREABLE
#pragma clang attribute push (__attribute__((annotate("GREEN_SHAREABLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
    int buf[SIZE] = { 0, 1, 2, 3, 4 };
#pragma clang attribute pop
    foo(buf);
    return 0;
}
