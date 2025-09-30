#include "string.h"
#include <iostream>
#include <string>



void sampleString(){
    std::cout << std::endl << "Starting std::string sample usage: " << std::endl;

    insertString();

    deleteFromString();

    accessingString();

    checkingSizeString();

    stringConversions();

    stringSearch();

    std::cout << "Covering: Insertion, Deleting, Accessing, Size checking, Conversions, and Searching " << std::endl;
}

void deleteFromString(){
    std::string val = "Hello World";

    //Erase 5 chars starting from index 0
    //If given more than its length it just deletes the whole string and stops,
    // but if the staring index is out of range then out of range error
    val.erase(0, 5);

    //Replace 2 characters starting at index 0 with "HI"
    val.replace(0, 2, "HI");

    val.clear();

    //Delete the last char of the string
    //Unknown behavior if empty
    val.pop_back(); 
}

void insertString(){
    std::string val = "Hello world";
    std::string val2 = "Hello world2";

    val.append("!!!"); //Append a whole string to end of a string
    
    //Concatenation
    //--As long as one of the strings is std::string type then the + concatenates
    val = val + val2 + "!!!";

    //Insert string at index 12
    val.insert(12, "Beautiful world");

    val.push_back('!'); //Push back a char to end of string

}

void accessingString(){
    std::string val = "Hello world of strings";

    char first = val[0]; //No bounds check
    first = val.at(0); //Bound check throwing out of bounds error

    char front = val.front();
    char back = val.back();
    
    //Get a cstyle pointer to start of string 
    const char* cstring = val.c_str(); //Get a null terminated string in c style
    const char* dataptr = val.data(); //Pointer to string data 
}

void checkingSizeString(){
    std::string val = "Hello world of sizes";
    
    size_t len = val.size();
    
    size_t capacity = val.capacity();
    
    bool isEmpty = val.empty();

    val.resize(10); //Change size of string to 10
    
    val.reserve(100); //Reserve space for 100 chars
}

void stringConversions(){
    std::string val = "122";
    std::string values = "Hello";
    //String to int
    int x = std::stoi(val);
    std::cout << "Str to int " << x << std::endl;

    //Int to string
    std::string val5 = std::to_string(x);
    std::cout << "int to str " << val << std::endl;

    //Char to ASCII
    char c = values.at(0);
    int ascii = static_cast<int>(c);
}

void stringSearch(){
    std::string val = "Hello world!!";
    
    //Find string index
    int index = val.find("world"); //Find string from start, idx
    index = val.rfind("world"); //Find string from end, idx
    if (index == std::string::npos){
        std::cout << "Substring not found" << std::endl;
    }

    //Get substring for given start and end index
    //If start index non existent then out of range exception 
    //If length longer that the string then just gives till the end of string with no exceptions
    std::string sub = val.substr(6,11);
    
    size_t pos = val.find_first_of("aeiou"); //Last vowel position

    size_t pos1 = val.find_last_of("aeiou"); //Last vowel position

    size_t pos2 = val.find_first_not_of(" \t"); //First non-whitespace

    size_t pos3 = val.find_last_not_of(" "); //Last non-space (trim right)
}