#include <iostream>

void conversionsSample() {
    /*String to number*/

    std::string str1 = "123";
    std::string hexStr = "0x1A"; //With base and position
    size_t pos;

    //std::stoi -> string to int (C++11, throws exception on error)
    int num1 = std::stoi(str1);
    int hexNum = std::stoi(hexStr, &pos, 16); //Base 16 (hex)
    long num2 = std::stol("123456789"); //string to long
    long long num3 = std::stoll("9876543210"); //string to long long
    float num4 = std::stof("3.14"); //string to float
    double num5 = std::stod("2.71828"); //string to double
    long double num6 = std::stold("1.41421"); //string to long double
    
    /*Number to string. Works for all data types*/
    //std::to_string -> number to string (C++11)
    int intVal = 42;
    std::string str2 = std::to_string(intVal);
    
    /*Char to ASCII value*/
    char ch = 'A';
    int ascii = static_cast<int>(ch);
    
    /*ASCII to char*/
    char character = static_cast<char>(ascii);
    
    /*Character clasification*/
    
    char testChar = 'a';
    
    //isdigit - check if digit (0-9) -> Non-zero for true, 0 for false
    std::cout << "isdigit('5'): " << std::isdigit('5') << std::endl;
    
    //isalpha - check if letter (A-Z, a-z) -> Non-zero for true, 0 for false
    std::cout << "isalpha('A'): " << std::isalpha('A') << std::endl;

    //isalnum - check if alphanumeric (letter or digit) -> Non-zero for true, 0 for false
    std::cout << "isalnum('a'): " << std::isalnum('a') << std::endl;
    
    //islower - check if lowercase letter -> Non-zero for true, 0 for false
    std::cout << "islower('a'): " << std::islower('a') << std::endl;
    
    //isupper - check if uppercase letter -> Non-zero for true, 0 for false
    std::cout << "isupper('A'): " << std::isupper('A') << std::endl;
    
    //isspace - check if whitespace (space, tab, newline, etc.) -> Non-zero for true, 0 for false
    std::cout << "isspace(' '): " << std::isspace(' ') << std::endl;
    
    //ispunct - check if punctuation -> Non-zero for true, 0 for false
    std::cout << "ispunct('!'): " << std::ispunct('!') << std::endl;
    
    /*Character conversion*/
    char upper = 'A';

    //Convert to lower case
    char lower = std::tolower(upper);

    //Convert to upper case
    char upperChar = std::toupper(lower);
}