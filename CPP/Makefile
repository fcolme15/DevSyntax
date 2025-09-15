CXX = g++
#-Wall -Wextra -> Turns on common flags
CXXFLAGS = -std=c++23 

compile:
	$(CXX) $(CXXFLAGS) GeneralSyntax.cpp declarations/*.cpp -o syntaxProgramming

run: compile
	./syntaxProgramming

clean: 
	rm -f syntaxProgramming