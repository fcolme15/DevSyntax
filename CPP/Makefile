CXX = g++
#-Wall -Wextra -> Turns on common flags
CXXFLAGS = -std=c++23 
DECLARATION_SOURCES = $(filter-out %Together.cpp, $(wildcard declarations/*.cpp))
compile:
	$(CXX) $(CXXFLAGS) GeneralSyntax.cpp $(DECLARATION_SOURCES) -o syntaxProgramming

run: compile
	./syntaxProgramming

clean: 
	rm -f syntaxProgramming