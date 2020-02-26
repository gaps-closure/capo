include ../../common.mk

SOURCES := TaintTracking.cpp
HEADERS := ../../TypeAnnotations.h
TARGET := TaintTracking.$(LIBEXT)

OBJS := $(SOURCES:%.cpp=%.o)

CXXFLAGS += -fPIC -I../..

$(TARGET): $(OBJS)
	$(CXX) $(PLUGIN_LDFLAGS) $(CXXFLAGS) \
		$(LLVM_CXXFLAGS) $(LLVM_LDFLAGS) \
		-o $@ $^

%.o: %.cpp $(HEADERS)
	$(CXX) -c $(CXXFLAGS) $(LLVM_CXXFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -rf $(TARGET) $(OBJS)

# Testing stuff.
.PHONY: test dump smoke
test: $(TARGET)
	$(BUILD)/llvm/bin/llvm-lit -v test
dump: $(TARGET)
	cd test ; ../ttclang -S -emit-llvm -o - ok.c
example: $(TARGET)
	cd test ; ../ttclang -S -emit-llvm -o /dev/null example-typeannot.c
cond: $(TARGET)
	cd test ; ../ttclang -S -emit-llvm -o /dev/null cond.c
ok: $(TARGET)
	cd test ; ../ttclang -S -emit-llvm -o /dev/null ok.c
endorsement: $(TARGET)
	cd test ; ../ttclang -S -emit-llvm -o /dev/null endorsement.c
funcs: $(TARGET)
	cd test ; ../ttclang -S -emit-llvm -o /dev/null funcs.c
codegen_simple: $(TARGET)
	cd test ; ../ttclang -S -emit-llvm -o /dev/null codegen_simple.c
simple: $(TARGET)
	cd test ; ../ttclang -S -emit-llvm -o /dev/null simple.c
