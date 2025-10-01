//Includes for .h files in declarations
#include "declarations/template.h"
#include "declarations/enum.h"
#include "declarations/struct.h"
#include "declarations/class.h"
//Includes for .h files in datatypes
#include "datatypes/maps.h"
#include "datatypes/string.h"
#include "datatypes/set.h"
#include "datatypes/stack.h"
#include "datatypes/deque.h"
//General Includes
#include <iostream>
#include <string>
#include <set>
#include <deque>
#include <vector>
#include <stdexcept>
#include <chrono>
#include <mutex>
#include <shared_mutex>
#include <condition_variable>
#include <thread>

//Set the namespace 
using std::cout;
using std::endl;
using std::cin;
using std::string;

void sampleLoops();

void sampleConst(const int& y);

void sampleCast();

void sampleArray();

void sampleSmartPointers();

int main (){
    std::cout << "C++ Standard: " << __cplusplus << std::endl;

    #if __cplusplus >= 202302L
        std::cout << "C++23 supported!" << std::endl;
    #elif __cplusplus >= 202002L
        std::cout << "C++20 supported!" << std::endl;
    #endif

    //Implemented in components:
    sampleEnum();

    sampleStruct();

    sampleClass();
    
    sampleTemplateFunctions();
    
    sampleMaps();

    sampleString();
    
    sampleStack();

    sampleSet();

    sampleDeque();
    //Not implemented in components:
    
    sampleLoops();
    
    int y = 10;
    sampleConst(y);

    sampleCast();

    sampleArray();

    sampleSmartPointers();
     
    return 0;
}

void sampleLoops(){ 
    int* arr = new int[10];
    std::vector<int> v;
    //For
    for (int i = 0; i < 10; i++){
        cout << i; 
        arr[i] = i;
        v.push_back(i);
    }
    cout << std::endl;

    //Auto
    for (auto & val : v){ //Reference
        cout << val * 10;
    }
    cout << std::endl;

    for (auto val : v){ //Makes copy for value
        cout << val * 10;
    }
    cout << std::endl;

    //While
    int i = 0;
    while (i != v.size()){
        i++;
    }

    //Do While
    std::string input;
    int count = 0;
    do{
        cout << "input 'q': " << std::endl;
        count += 1;
        if (count == 5){
            input = 'q';
        }
    }
    while(input != "q");
}

void sampleConst(const int& y){ //Const parameter so can't be chaged
    int a = 5, b = 6;

    const int x = 10; //Cant change value
    const int* p = &a; //Pointer to const int
    int* const q = &a; //Const pointer to int
    const int* const r = &a; //Const pointer to const int
}

void sampleCast(){
    float x = 2.2;

    //Static cast conversion
    int y = static_cast<int>(x); 

    //Dynamic cast conversion. If cast fails returns nullptr
    BaseCar* carPtr1 = new ElectricCar(5, 10); 
    ElectricCar* electricCarPtr1 = dynamic_cast<ElectricCar*>(carPtr1);

    // BaseCar* carPtr2 = new BaseCar(5, 10); 
    // ElectricCar* electricCarPtr2 = dynamic_cast<ElectricCar*>(carPtr2); //Nullptr

    //const cast removes the const qualifier from the ptr
    const int* yptr = &y;
    int* ptry = const_cast<int*>(yptr);

    //reinterpret cast does bit reinterpretation
    int n = 50;
    char* charPtr = reinterpret_cast<char*>(&n); //First byte of int as a char
}



void sampleArray(){
    int arr1[] = {1,2,3,4,5,6,7,8,9};
    int* arr2 = new int[10];

    for(int i = 0; i < 10; i++){
        arr2[i] = i;
    }

    for (auto & val : arr1){ //Auto only valid for reg arrays not from 'new' as those are pointers
        cout << val << std::endl;
    }

    int* ptr = arr2;
    for (;ptr < arr2+10; ptr++){
        cout << *ptr << std::endl;
    }
    delete[] arr2;
}



void sampleSmartPointers(){
    //unique_ptr -> Desctructor called when owner ptr is out of scope
    std::unique_ptr<ElectricCar> u1 = std::make_unique<ElectricCar>(5, 10);
    int plate = u1->getLicensePlate();

    std::unique_ptr<ElectricCar> u2;
    //u2 = u1; //This gives an error as it cannot transfer ownership due to uniqueness
    u2 = std::move(u1); //Transfer ownership using move

    if (!u1){
        cout << "unique ptr 1 is now empty" << std::endl;
    }

    //shared_ptr -> Descturctor called when all owner ptrs are out of scope
    std::shared_ptr<ElectricCar> s1 = std::make_shared<ElectricCar>(10, 15);
    
    std::shared_ptr<ElectricCar> s2 = s1;

    //Num of pointers that share reference to same address
    cout << "Ref count = " << s1.use_count() << std::endl;

    //Completely depricated in c++11, 2011 & removed in c++ 17, 2017
    //auto_ptr -> Destructor is called when owner is out of scope
    // std::auto_ptr<ElectricCar> a1(new ElectricCar(20,25));
    
    // std::auto_ptr<ElectricCar> a2 = a1; //Ownership was transfered silently


    // //Check ownership
    // if (!a1.get()){
    //     cout << "a1 lost ownership" << std::endl;
    // }

    // plate = a2->getLicensePlate;
}

void sampleExtras(){
    //Get timestamp - uint64
    // auto timestamp = std::chrono::duration_cast<std::chrono::milliseconds>(
    //     now.time_since_epoch()
    // ).count();
    
    std::mutex mtx;
    std::shared_mutex shared_mtx;
    std::condition_variable cv;
    {
        std::unique_lock<std::mutex> lock(mtx);
        lock.unlock();
        lock.lock();
    } //Auto unlocks out of scope

    {
        std::shared_lock<std::shared_mutex> read_lock(shared_mtx);
    } //Auto unlocks out of scope

    std::thread worker_thread(sampleLoops);
    worker_thread.join();
}

void practice(){
    std::shared_ptr<ElectricCar> ptr = std::make_shared<ElectricCar>(10,15);
    std::shared_ptr<ElectricCar> ptr2 = ptr;

    std::unique_ptr<ElectricCar> uptr = std::make_unique<ElectricCar>(10,20);
    std::unique_ptr<ElectricCar> uptr2 = std::move(uptr);

    

    //vector
    std::vector<int> vector;
    vector.push_back(9);
    vector.push_back(15);
    vector.push_back(10);

    int val = vector.size();
    val = vector.back();
    vector.pop_back();
    vector.insert(vector.begin()+1, 100);
    vector.erase(vector.begin()+1);
}