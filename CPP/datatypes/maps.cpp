#include "maps.h"
#include <iostream>
#include <map>
#include <string>
#include <unordered_map>

/*DIFFERENCES, MAP VS UNORDERED MAP:
- Map is a Red-Black tree(Balanced binary search tree)
    - Insert/Find/Delete: O(log n)
    - Slower on avg but more consistent
    - Lower memory

- Unordered Map is a Hash table
    - Insert/Find/Delte O(1) avg, worst case O(n)
    - Faster on average but can have collision issues
    - Higher memory
*/

void sampleMaps(){
    std::cout << std::endl << "General syntax for both Maps and Unordered Maps" << std::endl;
    
    //Syntax for both types of maps is the exact same
    std::map<std::string, int> m;
    std::unordered_map<std::string, int> um;
    int val = 0;

    insertAndAccessingMaps();

    findingAndErasingElements();

    iteratingMaps();
    
    val = m.size(); //Size of map

    bool found3 = m.empty(); //Checks if map is empty

    m.clear(); //Clearing the map
}

void insertAndAccessingMaps(){
    //Syntax for both types of maps is the exact same
    std::map<std::string, int> m;

    /*Inserting elements:*/
    std::cout << "Inserting and accessing values" << std::endl;
    //Index notation:
    //--Overwrites the element if it already exists
    m["apple"] = 5;

    //Insert:
    //--Does not overwrite existing keys
    m.insert({"orange", 8});

    //Emplace: 
    //--Constructs directly in th emap not making temp object like insert -> more efficient that insert
    //--Better for like when values are classes/objects. Same for when integers.
    m.emplace("orange", 10);

    //Try Emplace
    //Emplace but only insert if the key doesn't exist
    m.try_emplace("grape", 23);

    /*Access values*/
    //At:
    //Always check if exists before using at
    //--Throws out of range exception if key does not exist
    int val = m.at("apple");
}

void findingAndErasingElements(){
    std::map<std::string, int> m;
    m.insert({"orange", 8});
    m.insert({"apple", 9});
    m.insert({"pineapple", 10});
    
    std::cout << "Finding elements and Erasing" << std::endl;

    //Find:
    //--Returns iterator object with vars first and second:
    //----EX: it->first & it->second
    //--Returns .end() if the item was not found
    auto item = m.find("banana");
    if (item == m.end()){
        std::cout << "No banana found" << std::endl;
    }

    //Count:
    //--Returns 1 if found and 0 if not found
    int found = m.count("banana");
    if (found == 1){
        std::cout << "Item found" << std::endl;
    }

    //Contains:
    //--Returns a bolean if it contains the element of not
    bool found1 = m.contains("apple");
    if (found1){
        std::cout << "Item found" << std::endl;

    }

    /*Erasing element*/
    //Giving it the key
    m.erase("orange");

    //Giving it the iterator object of an already found key
    auto found2 = m.find("apple");
    m.erase(found2); 
}

void iteratingMaps(){
    std::map<std::string, int> m;
    m.insert({"orange", 8});
    m.insert({"apple", 9});
    m.insert({"pineapple", 10});
    
    std::cout << "Iterating values" << std::endl;

    for (auto& [key, val] : m){ //Preparesed
        std::cout << key << " -> " << val << std::endl;
    }

    for (auto& val : m){ //Object
        std::cout << val.first << " -> " << val.second << std::endl;
    }
}