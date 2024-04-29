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
int foo(int* buf) {
    printf("%d\n", buf[0]);
    return 0;
}

int main() {

    #pragma cle GREEN_SHAREABLE
    int buf[SIZE] = { 0, 1, 2, 3, 4 };
    foo(buf);
    return 0;
}