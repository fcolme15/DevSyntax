#include "pointers.h"
#include "../declarations/class.h"
#include <iostream>
#include <memory>

void regularPointers();

void smartPointers();

void samplePointers(){
    regularPointers();

    smartPointers();
}

void passingPointerFunction(int* ptr){
    std::cout << "Using ptr in function: " << *ptr << std::endl;
}

void regularPointers(){
    //Declaration/Initialization
    int x = 69;
    int* ptr = &x; //Initializing to an address
    int* ptr2 = nullptr; //Initializing to nullptr
    int* heapPtr = new int(2002); //Declare variable in heap giving address to pointer
    delete heapPtr; //Frees the heap memory -> pointer points to nothing

    //Dereferencing Pointers
    std::cout << "Dereferencing pointer: " << *ptr << std::endl; //Get value
    *ptr = 6969; //Modifying the value the pointer points to

    //Pointer arithmetic
    int arr[] = {0,1,2,3,4,5,6,7,8,9};
    ptr2 = arr;
    int thirdItem = *(ptr2+2); //Get the third item in array
    ptr2++; //Move the pointer to point to the second item

    //Pointer to pointer
    int** ptrptr = &ptr;
    std::cout << "Dereferencing a pointer twice(ptr to ptr to int): " << **ptrptr << std::endl;

    //Checking for nullptr before dereferencing
    if (ptr2 != nullptr){
        //Do something or access variable
    }

    //Passing pointers/addresses to functions
    passingPointerFunction(&x); //Passing it address of variable
    passingPointerFunction(ptr2); //Passing it a pointer that holds the address
}

void smartPointers(){
    //1.) unique_ptr -> Desctructor called when owner ptr is out of scope
    //Declaration
    std::unique_ptr<ElectricCar> u1 = std::make_unique<ElectricCar>(5, 10);
    std::unique_ptr<ElectricCar> u2;

    //Using pointer
    int plate = u1->getLicensePlate();

    //Moving ownership:
    //u2 = u1; //This gives an error as it cannot transfer ownership due to uniqueness
    u2 = std::move(u1); //Transfer ownership using move

    if (!u1){ //Verify that ownership has been transferred
        std::cout << "unique ptr 1 is now empty" << std::endl;
    }

    //2.) shared_ptr -> Descturctor called when all owner ptrs are out of scope
    //Declaration
    std::shared_ptr<ElectricCar> s1 = std::make_shared<ElectricCar>(10, 15);
    std::shared_ptr<ElectricCar> s2 = s1;

    //Get num of pointers that share reference to same address
    std::cout << "Ref count = " << s1.use_count() << std::endl;
    
    /*3.) auto_ptr -> Destructor is called when owner is out of scope
    //Completely depricated in c++11(2011), removed in c++ 17(2017)

    //Declaration
    std::auto_ptr<ElectricCar> a1(new ElectricCar(20,25));
    
    //Transfer ownership
    std::auto_ptr<ElectricCar> a2 = a1; //Ownership was transfered silently


    //Check ownership
    if (!a1.get()){
        cout << "a1 lost ownership" << std::endl;
    }

    //Using the pointer
    plate = a2->getLicensePlate;*/
}