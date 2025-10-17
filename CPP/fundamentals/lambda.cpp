#include <iostream>

void lambdaSample() {
    int x = 10;
    int y = 20;

    /*Capture clause is the [] part that specifies which variables from the surrounding
        scope the function will have access to. This capture happens when the lambda is created/defined.
        - [] -> Capture Nothing
        - [=] -> Capture all by value
        - [&] -> Capture all by reference
        - [x] -> Capture the variable x by value
        - [&x] -> Capture the variable x by reference
        - [=, &x] -> Capture all variables by value, but x by reference
        - [&, x] -> Capture all by reference , but x by value */
    
    //Basic lambda -> no capture
    auto add = [](int a, int b) { return a + b; };
    std::cout << add(5, 3) << std::endl;
    
    //Capture by value [=] -> copies variables
    auto captureValue = [=]() { return x + y; };
    std::cout << captureValue() << std::endl;
    x = 100; //Changes don't affect lambda because the x is set at instantiation
    std::cout << captureValue() << std::endl;
    
    //Capture by reference [&] -> uses original variables and their newest values
    auto captureRef = [&]() { return x + y; };
    std::cout << captureRef() << std::endl; 
    
    //Capture specific variables
    auto captureMixed = [x, &y]() { return x + y; }; //x by value, y by ref
    
    //Mutable lambda -> can modify captured values (by value)
    int count = 0;
    auto increment = [count]() mutable { return ++count; };
    std::cout << increment() << std::endl;  // 1
    std::cout << increment() << std::endl;  // 2
    std::cout << count << std::endl;        // 0 (original unchanged)
    
    //Return type specification (optional, auto-deduced usually)
    auto divide = [](int a, int b) -> double { return (double)a / b; };
    std::cout << divide(5, 2) << std::endl;
    
    //Generic lambda (C++14) -> auto parameters
    auto print = [](auto value) { std::cout << value << std::endl; };
    print(42);
    print("Hello");
    print(3.14);
    
    //Immediately invoked lambda
    int result = [](int a, int b) { return a * b; }(5, 4);
    
    //Lambda as function parameter
    auto applyOperation = [](int a, int b, auto op) { return op(a, b); };
    std::cout << applyOperation(10, 5, [](int x, int y) { return x - y; }) << std::endl;
}