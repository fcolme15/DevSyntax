#include "set.h"
#include <iostream>
#include <set>
#include <unordered_set>

//All syntax is the same for SET vs Unordered SET except bounds.

/*DIFFERENCES, SET VS UNORDERED SET:
- Set is a Red-Black tree(Balanced binary search tree)
    - Set is sorted
    - Insert/Find/Delete: O(log n)
    - Slower on avg but more consistent
    - Lower memory

- Unordered Set is a Hash table
    - Unordered set is not sorted
    - Insert/Find/Delte O(1) avg, worst case O(n)
    - Faster on average but can have collision issues
    - Higher memory
*/

void extractingElementInSet();

void combiningSets();

void insertingElements();

void findingAndErasingElements();

void gettingUpperOrLowerValues();

void sampleSet(){
    std::cout << std::endl << "General syntax for both Sets and Unordered Sets" << std::endl;

    std::set<int> s;

    //Loop through set
    for (auto & val : s){
        std::cout << " " << val << " ";
    }
    std::cout << std::endl;
    
    int size = s.size(); //Get the current size of set

    bool isEmpty = s.empty(); //Check if empty

    s.clear(); //Clear the whole set
    
    extractingElementInSet();

    combiningSets();

    insertingElements();

    findingAndErasingElements();

    gettingUpperOrLowerValues();
}

void extractingElementInSet(){
    std::set<int> set1 = {1, 2, 3, 4, 5};
    std::set<int> set2 = {10, 20, 30};

    //Extract from set1
    //Of type node_type that owns the element
    auto node = set1.extract(3);

    //Insert into set2
    set2.insert(std::move(node));
}

void combiningSets(){
    std::set<std::string> s1 = {"apple", "banana"};
    std::set<std::string> s2 = {"cherry", "date"};
    std::unordered_set<int> set3 = {1, 2, 3};
    std::unordered_set<int> set4 = {4, 5, 6};

    //Inserts all elements of set2 into set1 
    //These are copies so they still exist in set 2
    //Works if they are unordered vs ordered sets
    s1.insert(s2.begin(), s2.end());

    //Merges the two sets
    //Now set 4 is empty as everything is now in set 3
    //Does not work for the different types of sets
    set3.merge(set4);
}

void insertingElements(){
    std::set<int> s;

    //Insert single values into set
    s.insert(5);
    s.insert(6);
    s.insert(7);
    s.insert(8);
    s.insert(9);

    //Insert but construct the element in-place for memory efficiency
    //Only for large classes not really integers to save memory
    s.emplace(15); 
}

void findingAndErasingElements(){
    std::set<int> s = {5,6,7,8,9,10,11,12,13,14,15};
    //Check existance of value in set. Returns 1 or 0
    bool found = s.count(7);

    //Returns an iterator to the item itself if found
    auto found2 = s.find(7);
    if (found2 != s.end()){
        std::cout << "Found element: " << *found2 << std::endl;
    } 

    s.erase(8); //Remove value
}

void gettingUpperOrLowerValues(){
    std::set<int> s = {5,6,7,8,9,10,11,12,13,14,15};

    //Set only not unordered set:
    //Returns an iterator to the item above or below the bound given
    auto start = s.lower_bound(5);
    auto end = s.upper_bound(5);
}