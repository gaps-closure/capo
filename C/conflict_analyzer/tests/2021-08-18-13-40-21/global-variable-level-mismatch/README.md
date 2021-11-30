Since a function can only be assigned to one level, it can only access a variable
from the level it is assigned. Thus, in function `foo`, it cannot access both `a` and `b`,
which come from different levels

```c
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
```