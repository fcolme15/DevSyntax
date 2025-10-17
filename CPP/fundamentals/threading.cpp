#include <iostream>
#include <thread>
#include <mutex>

void threadingSample() {
    std::mutex mtx; //Protects shared data from race conditions
    int sharedCounter = 0;
    
    //Basic lambda function
    auto incrementCounter = [&]() {
        for (int i = 0; i < 1000; i++) {
            std::lock_guard<std::mutex> lock(mtx);  //Lock the mutex
            sharedCounter++;
        }
    };
    
    //Lambda function with variables
    auto printMessage = [](const std::string& msg, int times) {
        for (int i = 0; i < times; i++) {
            std::cout << msg << std::endl;
        }
    };
    
    //Create and start threads
    std::thread t1(incrementCounter);
    std::thread t2(incrementCounter);
    
    //Wait for threads to finish (Need to join or detach)
    t1.join(); //Block until t1 completes
    t2.join(); //Block until t2 completes
    
    //Detached thread (runs independently, can't join)
    std::thread t3(incrementCounter);
    t3.detach(); //Thread runs in background
    
    std::thread t4(printMessage, "Hello", 3);
    t4.join();
    
    //Get thread ID
    std::cout << "Thread ID: " << std::this_thread::get_id() << std::endl;
    
    //Sleep current thread
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
    
    //Hardware concurrency (number of CPU cores)
    unsigned int cores = std::thread::hardware_concurrency();
    std::cout << "CPU cores: " << cores << std::endl;
}