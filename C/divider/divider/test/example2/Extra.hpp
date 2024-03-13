#include "Parent.hpp"

class Extra : public Parent
{
private:
  // @Purple
  int a2LUE;

  // @PurpleOrangeConstructable
public:
  Extra() {
    a2LUE = 42;
  }

  // @PurpleOrangeCallable
  int getValue() {
     return this->a2LUE;
  }
};

