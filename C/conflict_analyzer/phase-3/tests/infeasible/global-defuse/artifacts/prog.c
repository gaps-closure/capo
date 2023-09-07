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
#pragma clang attribute push (__attribute__((annotate("ORANGE_NOSHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
const int glob1 = 0;
#pragma clang attribute pop

#pragma cle ORANGE_SHARE
#pragma clang attribute push (__attribute__((annotate("ORANGE_SHARE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
int glob2 = glob1;
#pragma clang attribute pop

int main() {
  printf("%d\n", glob2);
  return 0;
}
