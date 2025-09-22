#include "template.h"
#include "enum.h"
#include <iostream>

void sampleTemplateFunctions(){
    //Calls the regular template function
    templateFunction(10, "string");
    templateFunction(10, 10);
    templateFunction<double, int>(10.5, 10);

    //Calls the specialized version of the function
    templateFunction<std::string, int>("String", 10);

    //Compile time deduction using enums
    templateFunctionEnums<Weather::sunny>(10);

    //Compile time deductions for factorial
    //Template mainly works to specify the value at compile time
    templateFunctionFactorial<5>();

    //Specifying values so that they're known at compile time not  runtime 
    templateFunctionFixedArraySize<10>();

    //Deduct the size of c style arrays using template
    int arr[5] = {0,1,2,3,4};
    templateFunctionSizeDeduction(arr);

    //Variadic - Unknown/specified number of parameters
    templateFunctionVariadic(1,2,3,4,5);
    templateFunctionVariadic(1,2,3);
    templateFunctionVariadic();

    //Filter out unacceptable types. SFINAE(Substitution Failure Is Not An Error)
    templateFunctionIntegralOnly(10);
    //Give an error because the function does not exist for a string only integral types
    //templateFunctionIntegralOnly("String");
}
