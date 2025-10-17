#ifndef ENUM_H
#define ENUM_H

#include <string>
#include <optional>
#include <iostream>

//Enum class declaration of type int
//Different from c-style as this style needs explicit casting for type safety and namespace/name conflicts
enum class Weather : int {
    sunny, rainy, cloudy, cold, snowy
};

enum class Weather2 : char {
    sunny = 'S', rainy = 'R', cloudy = 'C', cold = 'O', snowy = 'N'
};

constexpr Weather operator|(Weather a, Weather b);

void sampleEnum();

void printWeather(Weather weather);

std::string weatherToString(Weather weather);

Weather stringToWeather(std::string weather);

int enumToInt(Weather weather);

std::optional<Weather> intToEnum(int val);

#endif 