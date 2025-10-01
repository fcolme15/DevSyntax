#include "loops.h"
#include <iostream>
#include <vector>
#include <string>

void sampleLoops(){ 
    int* arr = new int[10];
    std::vector<int> v;

    //For
    for (int i = 0; i < 10; i++){
        std::cout << i; 
        arr[i] = i;
        v.push_back(i);
    }
    std::cout << std::endl;

    //Auto Reference
    for (auto & val : v){ //Reference
        std::cout << val * 10;
    }
    std::cout << std::endl;

    //Auto no reference
    for (auto val : v){ //Makes copy for value
        std::cout << val * 10;
    }
    std::cout << std::endl;

    //While
    int i = 0;
    while (i != v.size()){
        i++;
    }

    //Do While
    std::string input;
    int count = 0;
    do{
        std::cout << "Do while... ";
        count += 1;
        if (count == 3){
            input = 'q';
        }
    }
    while(input != "q");
    std::cout << std::endl;
}