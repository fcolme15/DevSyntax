//Includes for .h files in declarations
#include "declarations/template.h"
#include "declarations/enum.h"
#include "declarations/struct.h"
#include "declarations/class.h"

//Includes for .h files in datatypes
#include "datatypes/maps.h"
#include "datatypes/string.h"
#include "datatypes/set.h"
#include "datatypes/stack.h"
#include "datatypes/deque.h"
#include "datatypes/array.h"

//Includes for .h files in fundamentals
#include "fundamentals/loops.h"
#include "fundamentals/casting.h"
#include "fundamentals/const.h"
#include "fundamentals/pointers.h"
#include "fundamentals/namespace.h"

//General Includes
#include <iostream>
#include <stdexcept>
#include <chrono>
#include <mutex>
#include <shared_mutex>
#include <condition_variable>
#include <thread>

int main (){
    std::cout << "C++ Standard: " << __cplusplus << std::endl;

    //Check CPP version
    #if __cplusplus >= 202302L
        std::cout << "C++23 supported!" << std::endl;
    #elif __cplusplus >= 202002L
        std::cout << "C++20 supported!" << std::endl;
    #endif

    //Implemented in components:
    sampleEnum();

    sampleStruct();

    sampleClass();
    
    sampleTemplateFunctions();
    
    sampleMaps();

    sampleString();
    
    sampleStack();

    sampleSet();

    sampleDeque();
    
    sampleLoops();
    
    sampleArray();
    
    sampleCast();
    
    int y = 10;
    sampleConst(y);

    sampleNamespace();

    samplePointers();
     
    return 0;
}
