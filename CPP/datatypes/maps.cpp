#include "maps.h"
#include <iostream>
#include <map>
#include <string>
#include <unordered_map>

void sampleMap(){
    std::map<std::string, int> m;
    std::unordered_map<std::string, int> um;
    int val = 0;
    //Insert elements
    m["apple"] = 5;
    m.insert({"orange", 8});

    //Access 
    val = m.at("apple");

    //Iteration
    for (auto& [key, val] : m){
        std::cout << key << " -> " << val << std::endl;
    }

    //Find
    if (m.find("banana") == m.end()){
        std::cout << "No banana found" << std::endl;
    }

    //Erase
    m.erase("orange");

    //Size
    val = m.size();
}