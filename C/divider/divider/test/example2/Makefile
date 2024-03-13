all:  		Example2

Example2:  	Example2.cpp 
	 	$(CXX) $(COPTS) -o $@ $^ -std=c++11
# stackoverflow.com/questions/61473077/didnt-pass-ldflags-ldflags
# Suggestion to add: -Wl,--hash-style=gnu

clean:
	 	rm -f *.o Example2

