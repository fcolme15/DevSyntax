#ifndef TEMPLATE_H
#define TEMPLATE_H

#include "enum.h"
#include <iostream>

//NOTE - Template functions cannot be separated into .h and .cpp implementations
//NOTE - Inline is needed for template<> functions

//Function is a runtime time deduction of the type T and U, but U has a default.
template <typename T, typename U = int>
void templateFunction(T value, U size){
    std::cout << "Template value: " << value << " and " << size << std::endl;
}

//Specialized function that is chosen over templateFunction only when the type is a string
//With many parameters this still works but each combination is a unique specialization
template <>
inline void templateFunction<std::string, int>(std::string value, int size){
    std::cout << "Specialized: Template value: " << value << " and " << size << std::endl;
}

//Function uses compile time deduction so it need to be specified in <> of the function call
/*The use of constexpr and copile time deduction means that this function is deduced on compilation
in a way that it will delete any other if else or more branches and only leave the if.
This compile time deduction works every time its called even with the same types -> Speed vs size */
template <Weather w, typename T>
void templateFunctionEnums(T num){
    if constexpr (w == Weather::sunny){
        std::cout << "Template value: " << num << std::endl;
    }
}
//Calculates the factorial all inside compile time not runtime
template<int N>
constexpr int templateFunctionFactorial() {
    if constexpr (N <= 1) {
        return 1;
    } else {
        return N * templateFunctionFactorial<N-1>();
    }
}

template <int size>
void templateFunctionFixedArraySize(){
    int arr[size];
}

//Template c style arrays size deduction
template <typename T, std::size_t N>
void templateFunctionSizeDeduction(T(&arr)[N]){
    std::cout << "Array size: " << N << " Contents:" << std::endl;
    for (int i = 0; i < N; i++){
        std::cout << arr[i] << " ";
    }
    std::cout << std::endl;
}

template<typename... Args>
void templateFunctionVariadic(Args... args){
    //Get the number of arguments
    int numberArgs = sizeof...(args);

    //Calculate the sum
    int sum = 0;
    ((sum += args), ...);
    std::cout << "Sum: " << sum << std::endl;
}

//SFINAE(Substitution Failure Is Not An Error)
//Filters so that it only runs with integral types and otherwise doesn't run the function
template<typename T>
typename std::enable_if<std::is_integral<T>::value, void>::type
templateFunctionIntegralOnly(T value){
    std::cout << "This only works with integral types: " << value << std::endl;
}

void sampleTemplateFunctions();

#endif