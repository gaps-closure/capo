#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange"}

int foo() {
#pragma cle begin PURPLE
    static int x = 1;
#pragma cle end PURPLE

#pragma cle begin ORANGE
    static int y = 1;
#pragma cle end ORANGE

    int a = x + y;
    x++;
    y++;
    return a;
}

int main(int argc, char **argv) {
  printf("%d\n", foo());
  return 0; 
}