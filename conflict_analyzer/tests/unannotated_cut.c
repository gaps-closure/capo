#include <stdio.h>

#pragma cle def ORANGE {"level": "orange"}
#pragma cle def PURPLE {"level": "purple"}

int bar() {
#pragma cle begin PURPLE 
    static int i = 0;
#pragma cle end PURPLE 
    return i++;
}

int foo() {
#pragma cle begin ORANGE 
    static int j = 0;
#pragma cle end ORANGE 
    j++;
    return bar() + j;    
}
int main() {
    int a = foo();
    printf("%d\n", a);
    return 0;
}
