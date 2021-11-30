#include <stdio.h>

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def ORANGE {"level":"orange"}

#pragma cle begin ORANGE 
int a = 1;
#pragma cle end ORANGE 

#pragma cle begin PURPLE 
int b = 1;
#pragma cle end PURPLE 

int foo() {
    a++;
    b++;
    return a + b;
}

int main(int argc, char **argv) {
  printf("%d\n", foo());
  return 0; 
}