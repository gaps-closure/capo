class Bar {};

class Foo : public Bar
{ 
private:
    __attribute__((cle_annotate("PURPLE")))
    int bar;

    int baz;
public:
    Foo() {}
    ~Foo() {}
    int get_bar(); 
};

int Foo::get_bar()
{
    return bar;
}

__attribute__((cle_annotate("ORANGE")))
int foo(int x)
{
    Foo f;

    __attribute__((cle_annotate("BLUE")))
    int y = 1;
    int z;
    if (y) {
        int yy = 5;
        z = yy + 5;
    } else {
        z = 1;
    }

    int w = f.get_bar();
    return 10 * w;
}


int main()
{
    foo(5);
    return 0;
}
