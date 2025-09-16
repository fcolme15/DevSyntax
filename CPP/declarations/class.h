#ifndef CLASS_H
#define CLASS_H

#include <iostream>
#include <string>

//Base class - Cannot be created as it contians a pure virtual function (Only for inheritance)
class BaseCar{ 
    public:
        //Constructor 
        BaseCar(int licensePlate, int carId);

        //Pure virtual function
        void virtual honk() = 0; 

        //Virtual function
        void virtual drive();

        //Member functions
        int accelerationPerSecond() const ;

        int getCarId() const ;

        //Virtual destructor set as defalt
        virtual ~BaseCar() = default;
    
    //Inheritance classes gets this as if it was part of its private members
    protected: 
        int licensePlate;

    //Inheritance classes do not get access to these. Only through getters and setters.
    private:
        int carId;
};

//Inheritance class
class ElectricCar : public BaseCar{ 
    public:
        //Constructor 1 calling the base class constructor
        ElectricCar(int licensePlate, int carId);

        //Constructor 2 calling the base class constructor
        ElectricCar(int licensePlate, int carId, int battery);
        
        //Overriding base class pure virtual function
        void honk() override;

        //Overriding base class virtual function
        void drive() override;

        //Member function using const -> Cannot change class vars, but yes to local vars
        int getLicensePlate() const;

        int getEletricCarCount() const;

        //Copy constructor. Basically create a deep copy of the given 'other' object
        ElectricCar(const ElectricCar& other);

        //Copy assignment operator. Change the values so they match eachother
        ElectricCar& operator=(const ElectricCar& other);

        //Overloaded operator for class
        ElectricCar operator+ (const ElectricCar & rhs);

        friend void showBattery(const ElectricCar& car);

        friend class GasCar;

        //Default desctructor
        ~ElectricCar() override = default;

    protected:
        //Static variable in a class. Every instance of eletric car will share this variable
        static int electricCarCount;

    private:
        int battery;
};

class GasCar : public BaseCar {
    public:
        //Basic constructor just calling base and setting gas level to 0
        GasCar(int licensePlate, int carId);

        //Constructor 2 setting the base and also gas level
        GasCar(int licensePlate, int carId, int gasLevel);

        //Overriding base class pure virtual function
        void honk() override;

        //A function that uses the fact that GasCar is a friend of EletricCar
        //Being a friend it can access its private members
        void inspectCar(const ElectricCar& car);

        //Overloaded function for when a gas car is passed.
        //A class can access private members of other vars of the same class no declaration of friend needed
        void inspectCar(const GasCar& car);

    private:
        int gasLevel;
};

//Overloaded ostream output stream overload. (EX: cout << classVar)
std::ostream& operator<<(std::ostream& os, const ElectricCar money);

//Function prototype defined inside the class so now it can access private members
void showBattery(const ElectricCar& car);

void sampleClass();
#endif



