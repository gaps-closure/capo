#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def XD_BAR {"level":"purple",	\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [[]], \
     "codtaints": [], \
     "rettaints": [] },\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["TAG_REQUEST_GET_EWMA"]], \
     "codtaints": ["PURPLE", "PURPLE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_GET_EWMA"] }\
  ] }

#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma clang attribute push (__attribute__((annotate("XD_BAR"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin XD_BAR
int bar(int x) {
#pragma cle end XD_BAR
#pragma clang attribute pop
    return x + 1;
}

int foo() {
    int x = 1;
    return bar(x);    
}

int main() {
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
    #pragma cle begin ORANGE
    int y = foo();
    #pragma cle end ORANGE
#pragma clang attribute pop
    printf("%d\n", y);
    return 0;
}