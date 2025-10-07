
#include "array.h"
#include <iostream>
#include <array>

void simpleArrayStack();

void simpleArrayHeap();

void arrayLibrary();

void sampleArray(){
    simpleArrayStack();

    simpleArrayHeap();

    arrayLibrary();
}

void passingArraysAsParameters(int* array, int arraySize){
    std::cout << "Passing size to function is lost so we need to pass it" << std::endl;
}

void simpleArrayStack(){
    //Initializing array on the stack
    int arr1[] = {1,2,3,4,5,6,7,8,9,10}; //Assumes the size of the array, {1,2,3,4,5,6,7,8,9,10}
    int arr2[5] = {1,2,3,4,5}; //Set the size, {1,2,3,4,5}
    int arr3[5] = {1,2}; //{1,2,0,0,0}
    int arr4[5] = {}; //Set the size and initialize to all 0's
    int arr5[5]; //Uninitialized array
    int arr6[2][2] = { //2x2 array as given
        {1,2},
        {3,4}
    };
    int arr7[2][2] = { //2x2 array, [1,0]
        {1},                     // [2,0]
        {2}
    };

    //Iterating through a stack array
    for(int i = 0; i < 10; i++){
        arr1[i] = i;
    }

    //Iterating stack array
    for (auto & val : arr1){ //Auto only valid for reg arrays not from 'new' as those are pointers
        std::cout << val << std::endl;
    }

    //Iterating through elements using pointer
    int thirdElement = *(arr1 + 2);
    
    //Getting the array size/length
    int sizeArray = sizeof(arr1) / sizeof(arr1[0]);

    passingArraysAsParameters(arr1, sizeArray);
}

void simpleArrayHeap(){
    //Initializing on the heap
    int* arr1 = new int[10]; //Uninitialized values just set the memory aside
    int* arr2 = new int[10](); //Initialize to all 0's, {0,0,0,0,0,0,0,0,0,0}
    int* arr3 = new int[5]{1,2}; //Partially initialized setting rest to 0's, {1,2,0,0,0}

    //Iterating through heap array using addresses and known size
    for (int* ptr = arr2; ptr < arr2+10; ptr++){
        std::cout << *ptr << std::endl;
    }

    //Iterating through elements using pointer
    int thirdElement = *(arr2 + 2);

    delete[] arr2; //Deleting heap array
}

void arrayLibrary(){
    std::array<int, 5> arr1; //Unitialized
    std::array<int, 5> arr2 = {1,2,3,4,5}; //{1,2,3,4,5}
    std::array<int, 5> arr3 = {1,2}; //{1,2,0,0,0}
    std::array<int, 5> arr4{}; //{0,0,0,0,0}

    //Accessing elements
    int first = arr2[0];
    int second = arr2.at(1);
    int front = arr2.front();
    int back = arr2.back();

    //Size operations
    size_t arraySize = arr2.size();
    bool isEmpty = arr2.empty();
    size_t maxSize = arr2.max_size();

    //Iterating 
    std::cout << "Forward Iteration: ";
    for (const auto& val : arr2){
        std::cout << val << " ";
    }
    std::cout << std::endl;

    //Reverse Iteration
    std::cout << "Reverse Iteration: ";
    for (auto it = arr2.rbegin(); it != arr2.rend(); ++it){
        std::cout << *it << " ";
    }
    std::cout << std::endl;

    //Index based iteration
    for (int i = 0; i < arr2.size(); i++){
        //Stuff
    }

    //Modification
    arr2[0] = 21; //Index access no bound checking
    arr2.at(1) = 22; //Index access with bounds check
    arr2.fill(0); //Fill all elements with a given value

    //Comparison: You can compare arrays using ==, !=, <, > 

    //Structure binding, (C++ 17), Must unpack all values
    std::array<int, 3> coords = {10,20,30};
    auto [x, y, z] = coords; //Unpack array into variables
    std::cout << "Unpacking array" << " X: " << x << " Y: " << y << " Z: " << z << std::endl;

    /*Differences:
        - Knows its size
        - Size is part of the type. (<int, 5> vs <int, 10> are not the same type)
        - Deep copy operator
        - Overloadeded operators built in
        - Bounds checking with .at()
        - Can get pointer to the object using .data()
    */
}
