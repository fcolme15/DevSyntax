#ifndef TEMPLATE_H
#define TEMPLATE_H

#include "enum.h"
#include <iostream>

//Function is a runtime time deduction of the type T and U, but U has a default.
template <typename T, typename U = int>
void templateFunction(T value, U size);

//Specialized function that is chosen over templateFunction only when the type is a string
//With many parameters this still works but each combination is a unique specialization
template <>
void templateFunction<std::string, int>(std::string value, int size);

//Function uses compile time deduction so it need to be specified in <> of the function call
/*The use of constexpr and copile time deduction means that this function is deduced on compilation
in a way that it will delete any other if else or more branches and only leave the if.
This compile time deduction works every time its called even with the same types -> Speed vs size */
template <Weather w, typename T>
void templateFunctionEnums(T num);

//Calculates the factorial all inside compile time not runtime
template<int N>
constexpr int templateFunctionFactorial();

template <int size>
void templateFunctionFixedArraySize();

//Template c style arrays size deduction
template <typename T, std::size_t N>
void templateFunctionSizeDeduction(T(&arr)[N]);

template<typename... Args>
void templateFunctionVariadic(Args... args);

//SFINAE(Substitution Failure Is Not An Error)
//Filters so that it only runs with integral types and otherwise doesn't run the function
template<typename T>
typename std::enable_if<std::is_integral<T>::value, void>::type
templateFunctionIntegralOnly(T value);


void sampleTemplateFunctions();


#endif