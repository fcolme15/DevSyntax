CXX = g++
#-Wall -Wextra -> Turns on common flags
CXXFLAGS = -std=c++23 
DECLARATION_SOURCES = $(filter-out %Together.cpp, $(wildcard declarations/*.cpp))
DATATYPE_SOURCES = $(filter-out %Together.cpp, $(wildcard datatypes/*.cpp))
FUNDAMENTALS_SOURCES = $(filter-out %Together.cpp, $(wildcard fundamentals/*.cpp))

compile:
	$(CXX) $(CXXFLAGS) GeneralSyntax.cpp $(DECLARATION_SOURCES) $(DATATYPE_SOURCES) $(FUNDAMENTALS_SOURCES) -o syntaxProgramming

run: compile
	./syntaxProgramming

clean: 
	rm -f syntaxProgramming