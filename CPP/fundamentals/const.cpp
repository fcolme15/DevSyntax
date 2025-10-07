#include "const.h"
#include <iostream>

void sampleConst(const int& y){ //Const parameter -> can't be chaged
    int a = 5, b = 6;

    const int x = 10; //Can't change value

    const int* p = &a; //Pointer to const int

    int* const q = &a; //Const pointer to int

    const int* const r = &a; //Const pointer to const int
}

