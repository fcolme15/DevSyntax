#include "casting.h"
#include "../declarations/class.h"
#include <iostream>
#include <bit>

void staticCast();

void constCast();

void reinterpretCast();

void dynamicCast();

void bitCast();

void cStyleCast();

void sampleCast(){
    staticCast();

    dynamicCast();

    constCast();

    reinterpretCast();

    bitCast();

    cStyleCast();
}

void staticCast(){
    float x = 2.2;

    /*Static cast conversion:
        - Performs the cast no matter what 
    */
    int y = static_cast<int>(x); 
}

void dynamicCast(){
    /*Dynamic cast conversion:
        - If cast fails returns nullptr
        - Polymosphic downcasting
        - Runtime type safety for validity
        - Mainly for working with inheritance
    */
    BaseCar* carPtr1 = new ElectricCar(5, 10); 
    ElectricCar* electricCarPtr1 = dynamic_cast<ElectricCar*>(carPtr1);

    // BaseCar* carPtr2 = new BaseCar(5, 10); 
    // ElectricCar* electricCarPtr2 = dynamic_cast<ElectricCar*>(carPtr2); //Nullptr
}

void constCast(){
    int y = 2;
    /*Const cast: 
        - Removes const
        - Removes volatile
        - Calling a non-const function from a const context
        - For interfacing eith legacy APIs
    */
    const int* yptr = &y;
    int* ptry = const_cast<int*>(yptr);
}

void reinterpretCast(){
    /*Reinterpret cast does bit reinterpretation
        - 
    */
    //Convert int into a char
    int n = 50;
    char* charPtr = reinterpret_cast<char*>(&n); //First byte of int as a char

    //Pointer to int conversion and back
    int* ptr = new int(42);
    uintptr_t addr = reinterpret_cast<uintptr_t>(ptr);
    int* ptr2 = reinterpret_cast<int*>(addr);
}

void cStyleCast(){
    float x = 2.2;
    /*C-Style casting
        - Can perform any cast and considered too dangerous
        - No compile time safety
        - Tries in the order of: static -> const -> Reinterpret cast
    */ 
    int y2 = (int)x;
}

void bitCast(){
    /*Bit Cast
        - Converts the bits of one variable into another without any reinterpretation or change
        - Used for sending data in a given variable when its current interpretation is a different type
        - Convert from float -> int to send then after receiving convert int -> float. 
        - This way no bits are changed or affected keeping all data clean and the same.
    */
    float original = 3.14159f;

    uint32_t asBytes = std::bit_cast<uint32_t>(original);

    float restored = std::bit_cast<float>(asBytes);
}