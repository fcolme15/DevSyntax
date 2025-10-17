#include <cstdint>
#include <iostream>

void sampleDatatypes(){
    // ========================================
    // INTEGER TYPES (Signed)
    // ========================================
    
    char c;                    //1 byte  | -128 to 127
    short s;                   //2 bytes | -32,768 to 32,767
    int i;                     //4 bytes | -2,147,483,648 to 2,147,483,647
    long l;                    //4 bytes (Windows) or 8 bytes (Linux/Mac) | -2,147,483,648 to 2,147,483,647 (or larger)
    long long ll;              //8 bytes | -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
    
    // ========================================
    // INTEGER TYPES (Unsigned)
    // ========================================
    
    unsigned char uc;          //1 byte  | 0 to 255
    unsigned short us;         //2 bytes | 0 to 65,535
    unsigned int ui;           //4 bytes | 0 to 4,294,967,295
    unsigned long ul;          //4 bytes (Windows) or 8 bytes (Linux/Mac) | 0 to 4,294,967,295 (or larger)
    unsigned long long ull;    //8 bytes | 0 to 18,446,744,073,709,551,615
    
    // ========================================
    // FLOATING POINT TYPES
    // ========================================
    
    float f;                   //4 bytes | ±3.4E+38 (7 decimal digits precision)
    double d;                  //8 bytes | ±1.7E+308 (15 decimal digits precision)
    long double ld;            //8, 12, or 16 bytes (compiler dependent) | Extended precision
    
    // ========================================
    // BOOLEAN TYPE
    // ========================================
    
    bool b;                    //1 byte  | true or false (0 or 1)
    
    // ========================================
    // CHARACTER TYPES
    // ========================================
    
    char ch;                   //1 byte  | -128 to 127 (or 0 to 255 if unsigned)
    wchar_t wc;                //2 or 4 bytes | Wide character (Unicode)
    char16_t c16;              //2 bytes | UTF-16 character
    char32_t c32;              //4 bytes | UTF-32 character
    
    // ========================================
    // FIXED-WIDTH INTEGER TYPES (Embedded Systems)
    // Requires: #include <cstdint>
    // ========================================
    
    int8_t i8;                 //1 byte  | -128 to 127
    int16_t i16;               //2 bytes | -32,768 to 32,767
    int32_t i32;               //4 bytes | -2,147,483,648 to 2,147,483,647
    int64_t i64;               //8 bytes | -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
    
    uint8_t ui8;               //1 byte  | 0 to 255
    uint16_t ui16;             //2 bytes | 0 to 65,535
    uint32_t ui32;             //4 bytes | 0 to 4,294,967,295
    uint64_t ui64;             //8 bytes | 0 to 18,446,744,073,709,551,615
    
    // ========================================
    // FAST/LEAST INTEGER TYPES (Platform Optimized)
    // Requires: #include <cstdint>
    // ========================================
    
    int_fast8_t if8;           //At least 1 byte  | Fastest type with at least 8 bits
    int_fast16_t if16;         //At least 2 bytes | Fastest type with at least 16 bits
    int_fast32_t if32;         //At least 4 bytes | Fastest type with at least 32 bits
    int_fast64_t if64;         //At least 8 bytes | Fastest type with at least 64 bits
    
    int_least8_t il8;          //At least 1 byte  | Smallest type with at least 8 bits
    int_least16_t il16;        //At least 2 bytes | Smallest type with at least 16 bits
    int_least32_t il32;        //At least 4 bytes | Smallest type with at least 32 bits
    int_least64_t il64;        //At least 8 bytes | Smallest type with at least 64 bits
    
    // ========================================
    // POINTER-SIZED INTEGER TYPES
    // Requires: #include <cstdint>
    // ========================================
    
    intptr_t iptr;             //Same size as pointer (4 or 8 bytes) | Can hold pointer address
    uintptr_t uiptr;           //Same size as pointer (4 or 8 bytes) | Unsigned pointer-sized int
    size_t sz;                 //Unsigned, pointer-sized | Used for sizes/counts (0 to max addressable)
    ptrdiff_t pd;              //Signed, pointer-sized | Used for pointer differences
    
    // ========================================
    // MAXIMUM WIDTH INTEGER TYPES
    // Requires: #include <cstdint>
    // ========================================
    
    intmax_t imax;             //Largest signed integer type available
    uintmax_t uimax;           //Largest unsigned integer type available
    
    // ========================================
    // VOID TYPE
    // ========================================
    
    void* vptr;                //Pointer to any type | Size is platform-dependent (4 or 8 bytes)
    
    // ========================================
    // AUTO TYPE (C++11) - Compiler deduces type
    // ========================================
    
    auto autoVar = 42;         //Type deduced as int
    auto autoFloat = 3.14f;    //Type deduced as float

    // ========================================
    // Hex, Octal, Decimal
    // ========================================

    int decimal = 255;
    int hex = 0xFF;
    int octal = 0377;
    int binary = 0b11111111;
}