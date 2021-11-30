#include <stdio.h>

#pragma cle def ORANGE {"level": "orange"}
#pragma cle def PURPLE {"level": "purple"}

int bar() {
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin PURPLE 
    static int i = 0;
#pragma cle end PURPLE 
#pragma clang attribute pop
#pragma clang attribute pop
    return i++;
}

int foo() {
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable(unless(is_parameter)),field))
#pragma cle begin ORANGE 
    static int j = 0;
#pragma cle end ORANGE 
#pragma clang attribute pop
#pragma clang attribute pop
    j++;
    return bar() + j;    
}
int main() {
    int a = foo();
    printf("%d\n", a);
    return 0;
}
