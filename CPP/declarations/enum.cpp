#include "enum.h"
#include <iostream>
#include <optional>
#include <string>

/*Bitwise overload for the enum. Identified at run time using the ADL table 
with the correct argument positions in the same namespace scope*/
constexpr Weather operator|(Weather a, Weather b) {
    return static_cast<Weather>(
        static_cast<int>(a) | static_cast<int>(b)
    );
}

void sampleEnum(){
    std::cout << "Running Enum Sample" << std::endl << std::endl;

    //Declaring an enum
    Weather weather = Weather::rainy;

    std::cout << "Printing the current enum representation using switch: " << std::endl;
    //Print the enum value
    printWeather(weather);

    
    //Convert the enum to string
    std::string stringWeather = weatherToString(weather);
    std::cout << "Converting enum to string using switch: " << stringWeather <<  std::endl;

    //Convert the string to enum    
    weather = stringToWeather("Rainy");
    std::cout << "Converting string to Weather enum using if-else if's" <<  std::endl;
    
    //Get the integer value of the enum var
    int enumValue = enumToInt(weather);
    std::cout << "Converting enum to int using static cast: " << enumValue <<  std::endl;

    //Static cast from integer to enum
    auto weather1 = intToEnum(2);
    std::cout << "Converting int to enum using static cast" <<  std::endl;
    
    //Looping through enum values:
    //Choose the last enun and loop until you get to the end static casting into enum
    for (int i = 0; i < static_cast<int>(Weather::snowy); i++){
        auto weather2 = intToEnum(i);
    }
}

void printWeather(Weather weather){
    switch(weather){
        case Weather::sunny:
            std::cout << "Sunny" << std::endl;
            break;
        case Weather::rainy:
            std::cout << "Rainy" << std::endl;
            break;
        case Weather::cloudy:
            std::cout << "Cloudy" << std::endl;
            break;
        case Weather::cold:
            std::cout << "Cold" << std::endl;
            break;
        case Weather::snowy:
            std::cout << "Snowy" << std::endl;
            break;
    }
}

std::string weatherToString(Weather weather){
    switch(weather){
        case Weather::sunny:
            return "Sunny";
        case Weather::rainy:
            return "Rainy";
        case Weather::cloudy:
            return "Cloudy";
        case Weather::cold:
            return "Cold";
        case Weather::snowy:
            return "Snowy";
    }
    return "None";
}

Weather stringToWeather(std::string weather){
    if(weather == "Sunny") {
        return Weather::sunny;
    }
    else if(weather == "Rainy") {
        return Weather::rainy;
    }
    else if(weather == "Cloudy") {
        return Weather::cloudy;
    }
    else if(weather == "Cold") {
        return Weather::cold;
    }
    else if(weather == "Snowy") {
        return Weather::snowy;
    }
    
    //Default to sunny 
    return Weather::sunny;

}

int enumToInt(Weather weather){
    return static_cast<int>(weather);
}

/*If the enum doesn't have a value for the given number then it just give a random value 
    with no runtime error. Creating a function that returns nullopt is better to not get random values*/
std::optional<Weather> intToEnum(int val) {
    switch (val) {
        case static_cast<int>(Weather::sunny):    // 0
        case static_cast<int>(Weather::rainy):    // 1
        case static_cast<int>(Weather::cloudy):   // 2
        case static_cast<int>(Weather::cold):     // 3
        case static_cast<int>(Weather::snowy):    // 4
            return static_cast<Weather>(val);
        default:
            return std::nullopt;  // Invalid value
    }
}


