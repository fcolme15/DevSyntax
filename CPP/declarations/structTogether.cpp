#include <iostream>

//Base struct
struct point2D{ 
    float y;
    float x;

    //Constructor 1
    point2D(){
        this->y = 0;
        this->x = 0;
    }
     
    //Constructor 2
    point2D(float y, float x){
        this->y = y;
        this->x = x;
    }

    //Virtual function
    void virtual printValues(){
        std::cout << "X: " << this->x << "Y: " << this->y << std::endl;
    }
};

//Inheritance Struct
struct point3D : point2D{ 
    float z;

    //Constructor 1 calling base class constructor
    point3D()
        :point2D() {
            this->z = 0;
    }

    //Constructor 2 calling base class constructor
    point3D(float y, float x, float z)
        :point2D(y, x) {
            this->z = z;
    }

    //Overriding base struct virtual function
    void printValues() override {
        std::cout << "X: " << this->x << "Y: " << this->y << "Z: " << this->z << std::endl;
    }
};

void sampleStruct(){
    std::cout << "Running Struct Sample" << std::endl << std::endl ;

    //Constructor 1, no parameters
    point2D A = point2D();

    //Constructor 2, parameters
    point2D B = point2D(10, 5);

    //Print the values of 2d points
    A.printValues();
    B.printValues();

    //Constructor 1, no parameters
    point3D C = point3D();

    //Constructor 2, parameters
    point3D D = point3D(10, 5, 15);

    //Print the values of 3d points
    C.printValues();
    D.printValues();
}