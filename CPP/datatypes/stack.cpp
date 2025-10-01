#include <iostream>
#include <stack>

void stackLibrary();

void vectorAsStack();

void sampleStack(){
    std::cout << std::endl << "General syntax for stack" << std::endl;

    std::cout << std::endl << "Stack library syntax" << std::endl;
    stackLibrary();

    std::cout << std::endl << "Vector acting as stack" << std::endl;
    vectorAsStack();
}

void stackLibrary(){
    std::stack<int> stack;

    //Insert in top of stack
    stack.push(10);
    stack.push(15);

    //Emplace into the top of stack
    stack.emplace(20);

    //Check empty
    int isEmpty = stack.empty();

    int size = stack.size(); //Get size of stack

    //Get value at top of stack
    int top = stack.top();

    //Pop value from stack
    stack.pop(); 
}

void vectorAsStack(){
    std::vector<int> stack;

    //Insert to top of stack
    stack.push_back(10);
    stack.push_back(15);
    stack.push_back(20);
    stack.push_back(25);
    stack.push_back(30);

    //Get the value at top of stack
    int val = stack.back();

    //Pop at top of stack
    stack.pop_back();

    int size = stack.size(); //Get size of stack

    stack.clear(); //Clear stack

    bool isEmpty = stack.empty(); //Check if empty
}