#include <stdio.h>

#pragma cle def ORANGE_NOSHARE { "level": "orange"}
#pragma cle def ORANGE_SHARE { "level": "orange", \
    "cdf": [ \
        { \
            "remotelevel":"purple", \
            "direction": "egress", \
            "guarddirective": { "operation": "allow" } \
        } \
    ] \
}

#pragma cle ORANGE_NOSHARE
const int glob1 = 0;

#pragma cle ORANGE_SHARE
int glob2 = glob1;

int main() {
  printf("%d\n", glob2);
  return 0;
}