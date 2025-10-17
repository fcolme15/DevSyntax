#include <iostream>
#include <exception>

void exceptionHandlingSummary() {
    //Basic try-catch
    try {
        int x = 10, y = 0;
        if (y == 0) {
            throw std::runtime_error("Division by zero");
        }
        int result = x / y;
    }
    catch (const std::runtime_error& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
    catch (const std::exception& e) { //Catch base class
        std::cerr << "Exception: " << e.what() << std::endl;
    }
    catch (...) { //Catch all
        std::cerr << "Unknown exception" << std::endl;
    }
    
    //Multiple exception types
    try {
        std::vector<int> vec = {1, 2, 3};
        vec.at(10); //Throws out_of_range
    }
    catch (const std::out_of_range& e) {
        std::cerr << "Out of range: " << e.what() << std::endl;
    }
    
    //Common standard exceptions:
    //std::runtime_error - general runtime errors
    //std::logic_error - programming logic errors
    //std::out_of_range - access beyond bounds
    //std::invalid_argument - invalid function argument
    //std::bad_alloc - memory allocation failure
    
    //Custom exception
    class MyException : public std::exception {
    public:
        const char* what() const noexcept override {
            return "My custom error";
        }
    };
    
    try {
        throw MyException();
    }
    catch (const MyException& e) {
        std::cerr << e.what() << std::endl;
    }
    
    //Rethrowing
    try {
        try {
            throw std::runtime_error("Error");
        }
        catch (...) {
            std::cout << "Caught, now rethrowing" << std::endl;
            throw; //Rethrow same exception
        }
    }
    catch (const std::exception& e) {
        std::cerr << "Caught again: " << e.what() << std::endl;
    }
}