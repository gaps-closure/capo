#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange"}

int foo() {
#pragma cle begin ORANGE
    int y = 2;
#pragma cle end ORANGE
    return y + 1;
}

int bar() {
#pragma cle begin PURPLE
    static int x = 1;
#pragma cle end PURPLE
    x += x + foo();
    return x; 
}

int main(int argc, char **argv) {
  printf("%d\n", bar());
  return 0; 
}