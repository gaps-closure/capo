#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def XD_BAR {"level":"purple",	\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [[]], \
     "codtaints": ["PURPLE", "PURPLE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_BAR"] },\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [[]], \
     "codtaints": ["PURPLE", "PURPLE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_BAR"] }\
  ] }

#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma cle begin XD_BAR
int bar(int x) {
#pragma cle end XD_BAR
    return x + 1;
}

int foo() {
    int x = 1;
    return bar(x);    
}

int main() {
    #pragma cle begin ORANGE
    int y = foo();
    #pragma cle end ORANGE
    printf("%d\n", y);
    return 0;
}