#include <iostream>
#include <iomanip> //setw, setpercision, and setfill
#include <limits> //For numerical limits
#include <string> 

void inputSample() {
    int hexNum, octNum, decNum;
    std::string name, fullLine;
    double price;
    
    //Read hexadecimal
    std::cout << "Enter hex number";
    std::cin >> std::hex >> hexNum;

    //Read octal
    std::cout << "Enter octal number";
    std::cin >> std::oct >> octNum;
    
    //Reset to decimal (important!)
    std::cin >> std::dec >> decNum;
    std::cout << "Enter decimal: ";
    
    //Skip leftover newline in buffer
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    
    //Get entire line with spaces
    std::cout << "Enter full name: ";
    std::getline(std::cin, fullLine);
    
    //Clear error flags if input fails
    std::cin.clear();
    
    //Ignore bad input in buffer
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
}

void outputExamples() {
    double pi = 3.14159265359;
    int num = 255;
    bool flag = true;
    
    //Set precision for floating point
    std::cout << std::setprecision(3) << pi << std::endl; //3.14
    std::cout << std::fixed << std::setprecision(2) << pi << std::endl; //3.14
    std::cout << std::scientific << pi << std::endl; //3.14e+00
    
    //Different bases
    std::cout << "Dec: " << std::dec << num << std::endl; //255
    std::cout << "Hex: " << std::hex << num << std::endl; //ff
    std::cout << "Oct: " << std::oct << num << std::endl; //377
    std::cout << std::dec;  //Reset to decimal
    
    //Show base prefixes
    std::cout << std::showbase << std::hex << num << std::endl; // 0xff
    std::cout << std::noshowbase << std::dec;
    
    //Booleans as true/false
    std::cout << std::boolalpha << flag << std::endl; //true
    std::cout << std::noboolalpha << flag << std::endl; //1
    
    //Width and justification
    std::cout << std::setw(10) << std::left << "Left" << "|" << std::endl;
    std::cout << std::setw(10) << std::right << "Right" << "|" << std::endl;
    std::cout << std::setw(10) << std::internal << -123 << "|" << std::endl;
    
    //Fill character
    std::cout << std::setfill('*') << std::setw(10) << 42 << std::endl;//*******42
    std::cout << std::setfill(' '); //Reset
    
    //Show positive sign
    std::cout << std::showpos << 42 << std::endl; //+42
    std::cout << std::noshowpos;
}