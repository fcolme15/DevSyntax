#include <iostream>

void bitwiseSample() {
    unsigned int a = 60; //0011 1100
    unsigned int b = 13; //0000 1101
    
    //AND (&) -> Both bits must be 1
    unsigned int andResult = a & b; //0000 1100
    std::cout << "a & b = " << andResult << std::endl;
    
    //OR (|) -> At least one bit must be 1
    unsigned int orResult = a | b; //0011 1101
    std::cout << "a | b = " << orResult << std::endl;
    
    //XOR (^) -> Bits must be different
    unsigned int xorResult = a ^ b; //0011 0001
    std::cout << "a ^ b = " << xorResult << std::endl;
    
    //NOT (~) -> Flip all bits
    unsigned int notResult = ~a; //1100 0011 (in 32-bit)
    std::cout << "~a = " << notResult << std::endl;
    
    //Left shift (<<) -> Multiply by 2^n
    unsigned int leftShift = a << 2; //1111 0000 (60 * 4)
    std::cout << "a << 2 = " << leftShift << std::endl;
    
    //Right shift (>>) -> Divide by 2^n
    unsigned int rightShift = a >> 2; //0000 1111 (60 / 4)
    std::cout << "a >> 2 = " << rightShift << std::endl;
}