#include "class.h"
#include <iostream>
#include <string>

//BASE CLASS DEFINITIONS

//Constructor 
BaseCar::BaseCar(int licensePlate, int carId){
    this->licensePlate = licensePlate;
    this->carId = carId;
}

//Pure virtual function. Nothing is included in the .cpp

//Virtual function
void BaseCar::drive(){ 
    std::cout << "Car is driving! " << std::endl;
}

//Member functions
int BaseCar::accelerationPerSecond() const {
    return 5;
}

int BaseCar::getCarId() const {
    return carId;
}

//Virtual destructor set as defalt. Nothing in .cpp just the .h.



//INHERITED CLASS DEFINITIONS

//This is needed to define the variable because it is static in .h file
//The compiler knows about static variable eletricCarCount, here we give it the memory location
int ElectricCar::electricCarCount = 0;

//Constructor 1 calling the base class constructor
ElectricCar::ElectricCar(int licensePlate, int carId) 
    :BaseCar(licensePlate, carId){
        battery = 0;
}

//Constructor 2 calling the base class constructor
ElectricCar::ElectricCar(int licensePlate, int carId, int battery)
    :BaseCar(licensePlate, carId){
        this->battery = battery;
}

//Overriding base class pure virtual function
void ElectricCar::honk() { 
    std::cout << "Beep Boop" << std::endl;
}

//Overriding base class virtual function
void ElectricCar::drive() {
    std::cout << "Electric Car is driving! " << std::endl;
}

//Member function using const -> Cannot change class vars, but yes to local vars
int ElectricCar::getLicensePlate() const { 
    return licensePlate;
}

int ElectricCar::getEletricCarCount() const { 
    return electricCarCount;
}

//Copy constructor. Basically create a deep copy of the given 'other' object
ElectricCar::ElectricCar(const ElectricCar& other) : BaseCar(other.licensePlate, other.getCarId()) {
    battery = other.battery;
}

//Copy assignment operator. Change the values so they match eachother
ElectricCar& ElectricCar::operator=(const ElectricCar& other) {
    if (this != &other) {
        battery = other.battery;
        //Only change battery. We'd also change license plate and car id just missing setters
    }
    return *this;
}

//Overloaded operator for class
ElectricCar ElectricCar::operator+ (const ElectricCar & rhs){ //Overloaded operators: +, -, ==, >, <, =
    return ElectricCar((this->licensePlate + rhs.getLicensePlate()), (this->getCarId() + rhs.getCarId()));
}

//Default desctructor. Nothing in .cpp just the .h.


//Basic constructor just calling base and setting gas level to 0
GasCar::GasCar(int licensePlate, int carId) : BaseCar(licensePlate, carId){
    this->gasLevel = 0;
}

//Constructor 2 setting the base and also gas level
GasCar::GasCar(int licensePlate, int carId, int gasLevel) : BaseCar(licensePlate, carId){
    this->gasLevel = gasLevel;
}

//Overriding base class pure virtual function
void GasCar::honk() { 
    std::cout << "BAAM BAAM" << std::endl;
}

//A function that uses the fact that GasCar is a friend of EletricCar
//Being a friend it can access its private members
void GasCar::inspectCar(const ElectricCar& car) {
    std::cout << "Inspecting battery: " << car.battery << std::endl;
}

//Overloaded function for when a gas car is passed.
//A class can access private members of other vars of the same class no declaration of friend needed
void GasCar::inspectCar(const GasCar& car) {
    std::cout << "Inspecting gas level: " << car.gasLevel << std::endl;
}

//Not part of the class. Function outside of class.
//Overloaded ostream output stream overload. (EX: cout << classVar)
std::ostream& operator<<(std::ostream& os, const ElectricCar money) { //Output stream overload
    os << "Electric Car";
    return os;
}

//Function prototype defined inside the class so now it can access private members
void showBattery(const ElectricCar& car) {
    std::cout << "Friend function: Battery: " << car.battery << std::endl;  
}

void sampleClass(){
    std::cout << std::endl;
    std::cout << "Running Class Sample" << std::endl << std::endl;

    std::cout << "Running inherited class constructors" << std::endl;
    ElectricCar electricCar1 = ElectricCar(1001, 2);
    ElectricCar electricCar2 = ElectricCar(1002, 4);

    std::cout << "Calling base, inherited, and override methods" << std::endl;
    electricCar1.accelerationPerSecond();
    electricCar1.getCarId();
    electricCar1.getLicensePlate();
    electricCar1.honk();
    electricCar1.drive();

    std::cout << "Using overloaded operator and overloaded ostream operator" << std::endl;
    //Overloaded + operator making a combined version
    ElectricCar electricCar3 = electricCar1 + electricCar2;
    
    std::cout << "Using keyword friend to access private members outside of the class" << std::endl;
    
    //Calling friend function for the class
    showBattery(electricCar1);

    GasCar gasCar1 = GasCar(10001, 10);
    GasCar gasCar2 = GasCar(10001, 10, 30);
    gasCar1.inspectCar(electricCar1);
    gasCar1.inspectCar(gasCar2);


    //Overloaded ostream output stream so that it becomes a key work instead of returning a string
    std::cout << electricCar1 << electricCar2 << electricCar3;
}