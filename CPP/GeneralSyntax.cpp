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
#include "datatypes/array.h"

//Includes for .h files in fundamentals
#include "fundamentals/loops.h"
#include "fundamentals/casting.h"
#include "fundamentals/const.h"
#include "fundamentals/pointers.h"
#include "fundamentals/namespace.h"

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
    
    sampleLoops();
    
    sampleArray();
    
    sampleCast();
    
    int y = 10;
    sampleConst(y);

    sampleNamespace();
    //Not implemented in components:
    
    sampleSmartPointers();
     
    return 0;
}

void sampleSmartPointers(){
    //unique_ptr -> Desctructor called when owner ptr is out of scope
    std::unique_ptr<ElectricCar> u1 = std::make_unique<ElectricCar>(5, 10);
    int plate = u1->getLicensePlate();

    std::unique_ptr<ElectricCar> u2;
    //u2 = u1; //This gives an error as it cannot transfer ownership due to uniqueness
    u2 = std::move(u1); //Transfer ownership using move

    if (!u1){
        std::cout << "unique ptr 1 is now empty" << std::endl;
    }

    //shared_ptr -> Descturctor called when all owner ptrs are out of scope
    std::shared_ptr<ElectricCar> s1 = std::make_shared<ElectricCar>(10, 15);
    
    std::shared_ptr<ElectricCar> s2 = s1;

    //Num of pointers that share reference to same address
    std::cout << "Ref count = " << s1.use_count() << std::endl;

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
