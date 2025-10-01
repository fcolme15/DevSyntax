#include "deque.h"
#include <deque>
#include <iostream>

void insertionDeque();

void gettingElementDeque();

void removingElementsDeque();

void sampleDeque(){
    std::cout << std::endl << "General syntax for deque" << std::endl;

    std::deque<int> dq;

    std::cout << "Deque have fast access on both ends, but can have normal index access too" << std::endl;
    std::cout << "Insertion, getting element, and popping elements" << std::endl;
    
    insertionDeque();

    gettingElementDeque();

    removingElementsDeque();

    //Loop through elements
    for (auto val : dq){
        std::cout << val << " ";
    }
    std::cout << std::endl;

    dq.resize(10); //Resize the deque to 10

    int size = dq.size();

    bool isEmpty = dq.empty();

    dq.clear();
}   

void insertionDeque(){
    std::deque<int> dq;

    dq.push_back(1); //Insert to back of deque

    dq.push_front(4); //Insert to front of deque

    dq.emplace_front(12); //Insert to front of deque in place

    dq.emplace_back(10); //Insert to back of deque in place

    //Inserting into arbitrary postions
    dq.insert(dq.begin()+2, 99); //Insert 99 at index 2
}

void gettingElementDeque(){
    std::deque<int> dq;
    dq.push_back(1);
    dq.push_back(2);
    dq.push_back(3);

    int front = dq.front(); //Get value at front of deque

    int back = dq.back(); //Get value at back of deque
    
    //Index access the item at index 0, no bounds checking
    int val1 = dq[0]; 

    //Access the item at index 0, with bounds checking
    int val2 = dq.at(0);
}

void removingElementsDeque(){
    std::deque<int> dq;
    dq.push_back(1);
    dq.push_back(2);
    dq.push_back(3);
    dq.push_back(4);
    dq.push_back(5);

    //Removing values from front and end
    dq.pop_back();
    dq.pop_front();

    //Remove the second element in the deque
    dq.erase(dq.begin()+2);
}
