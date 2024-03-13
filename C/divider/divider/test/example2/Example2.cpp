#include <cstdio>
#include <string>

#include "Extra.hpp"

template <typename T, int label>
using annotate = T;

#define ORANGE 1

class Example2
{
private:
  Extra extra;

public:
  // @OrangeShareable
  annotate<int, ORANGE> myConstant;

  int getValue() {
    return this->extra.getValue();
  }

  Example2() : extra() {
  }
};

// @OrangeMain
int main(int argc, char **argv)
{
  Example2 e;
  printf("Hello Example 1: %d\n", e.getValue());
}
