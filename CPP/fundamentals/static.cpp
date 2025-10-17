#include <iostream>


//1.) Static variable in function - retains value between calls
void staticInFunction() {
    static int callCount = 0;  //Initialized only once, persists between calls
    callCount++;
    std::cout << "Function called " << callCount << " times" << std::endl;
}

//2.) Static member variable - shared by all instances
class Counter {
public:
    static int totalInstances;  //Shared across all Counter objects
    
    Counter() {
        totalInstances++;
    }
};
int Counter::totalInstances = 0;  //Must define outside class

//3.) Static member function - can only access static members
class MathUtils {
public:
    static int add(int a, int b) {  //No 'this' pointer, class-level function
        return a + b;
    }
};

//4.) Static global variable - internal linkage (file scope only)
static int fileLocalVar = 100;  //Only visible in this .cpp file

//5.) Static in anonymous namespace
namespace {
    static int anotherFileLocal = 200;  //File-local, not visible to other translation units
}

void staticSample() {
    //Function static -> Int counter created once for all function calls
    staticInFunction();  
    staticInFunction();  
    staticInFunction();  
    
    //Static member variable
    Counter c1, c2, c3;
    std::cout << "Total instances: " << Counter::totalInstances << std::endl;  // 3
    
    //Static member function (call without instance)
    int sum = MathUtils::add(5, 10);  //No object needed
    std::cout << "Sum: " << sum << std::endl;
    
    //6.) Static duration - exists for program lifetime
    static int persistentValue = 999;  //Created once, never destroyed until program ends
}