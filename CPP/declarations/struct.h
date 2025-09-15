#ifndef STRUCT_H
#define STRUCT_H

//Base struct
struct point2D{ 
    float y;
    float x;

    //Constructor 1
    point2D();
     
    //Constructor 2
    point2D(float y, float x);

    //Virtual function
    virtual void printValues();
};

//Inheritance Struct
struct point3D : point2D{ 
    float z;

    //Constructor 1 calling base class constructor
    point3D();

    //Constructor 2 calling base class constructor
    point3D(float y, float x, float z);

    //Overriding base struct virtual function
    void printValues() override; 
};

void sampleStruct();

#endif 