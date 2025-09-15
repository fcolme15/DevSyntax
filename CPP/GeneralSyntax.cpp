#include "declarations/enum.h"
#include "declarations/struct.h"
#include <iostream>
#include <string>
#include <unordered_map>
#include <map>
#include <set>
#include <deque>
#include <vector>
#include <stdexcept>
#include <chrono>
#include <mutex>
#include <shared_mutex>
#include <condition_variable>
#include <thread>

//Set the namespace 
using std::cout;
using std::endl;
using std::cin;
using std::string;

/*==========START CLASS==========*/
//Base class - Cannot be created as it contians a pure virtual function (Only for inheritance)
class BaseCar{ 
    public:
        //Constructor 
        BaseCar(int licensePlate, int carId){
            this->licensePlate = licensePlate;
            this->carId = carId;
        }

        //Pure virtual function
        void virtual honk() = 0; 

        //Virtual function
        void virtual drive(){ 
            cout << "Car is driving! " << std::endl;
        }

        //Member functions
        int accelerationPerSecond(){
            return 5;
        }

        int getCarId(){
            return carId;
        }

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
        ElectricCar(int licensePlate, int carId) 
            :BaseCar(licensePlate, carId){
                battery = 0;
        }

        //Constructor 2 calling the base class constructor
        ElectricCar(int licensePlate, int carId, int battery)
            :BaseCar(licensePlate, carId){
                this->battery = battery;
        }
        
        //Overriding base class pure virtual function
        void honk() override { 
            cout << "Beep Boop" << std::endl;
        }

        //Overriding base class virtual function
        void drive() override {
            cout << "Electric Car is driving! " << std::endl;
        }

        //Member function using const -> Cannot change class vars, but yes to local vars
        int getLicensePlate() const { 
            return licensePlate;
        }

        //Overloaded operator for class
        bool operator+ (const ElectricCar & rhs){ //Overloaded operators: +, -, ==, >, <, =
            return true;
        }

        //Overloaded ostream output stream overload. (EX: cout << classVar)
        friend std::ostream& operator<<(std::ostream& os, const ElectricCar money) { //Output stream overload
            os << "Electric Car";
            return os;
        }

        //Default desctructor
        ~ElectricCar() override = default;

    protected:

    private:
        int battery;
};
/*==========END CLASS==========*/

/*==========START TEMPLATE==========*/
//Function is a runtime time deduction of the type T and U, but U has a default.
template <typename T, typename U = int>
void templateFunction(T value, U size){
    cout << "Template value: " << value << " and " << size << endl;
}

//Specialized function that is chosen over templateFunction only when the type is a string
//With many parameters this still works but each combination is a unique specialization
template <>
void templateFunction<std::string, int>(std::string value, int size){
    cout << "Specialized: Template value: " << value << " and " << size << endl;
}

//Function uses compile time deduction so it need to be specified in <> of the function call
/*The use of constexpr and copile time deduction means that this function is deduced on compilation
in a way that it will delete any other if else or more branches and only leave the if.
This compile time deduction works every time its called even with the same types -> Speed vs size */
template <Weather w, typename T>
void templateFunctionEnums(T num){
    if constexpr (w == Weather::sunny){
        cout << "Template value: " << num << endl;
    }
}
//Calculates the factorial all inside compile time not runtime
template<int N>
constexpr int templateFunctionFactorial() {
    if constexpr (N <= 1) {
        return 1;
    } else {
        return N * templateFunctionFactorial<N-1>();
    }
}

template <int size>
void templateFunctionFixedArraySize(){
    int arr[size];
}

//Template c style arrays size deduction
template <typename T, std::size_t N>
void templateFunctionSizeDeduction(T(&arr)[N]){
    cout << "Array size: " << N << " Contents:" << endl;
    for (int i = 0; i < N; i++){
        cout << arr[i] << " ";
    }
    cout << endl;
}

template<typename... Args>
void templateFunctionVariadic(Args... args){
    //Get the number of arguments
    int numberArgs = sizeof...(args);

    //Calculate the sum
    int sum = 0;
    ((sum += args), ...);
    cout << "Sum: " << sum << endl;
}

//SFINAE(Substitution Failure Is Not An Error)
//Filters so that it only runs with integral types and otherwise doesn't run the function
template<typename T>
typename std::enable_if<std::is_integral<T>::value, void>::type
templateFunctionIntegralOnly(T value){
    cout << "This only works with integral types: " << value << endl;
}
/*==========END TEMPLATE==========*/

void sampleTemplateFunctions();

void sampleLoops();

void sampleConst(const int& y);

void sampleCast();

void sampleString();

void sampleArray();

void sampleVectorStack();

void sampleMap();

void sampleSet();

void sampleDeque();

void sampleStack();

void sampleSmartPointers();

int main (){
    std::cout << "C++ Standard: " << __cplusplus << std::endl;

    #if __cplusplus >= 202302L
        std::cout << "C++23 supported!" << std::endl;
    #elif __cplusplus >= 202002L
        std::cout << "C++20 supported!" << std::endl;
    #endif

    //Implemented in components:
    sampleEnum();

    sampleStruct();
    //Not implemented in components:

    sampleLoops();
    
    
    
    int y = 10;
    sampleConst(y);

    sampleCast();

    sampleString();

    sampleArray();

    sampleVectorStack();

    sampleMap();

    sampleSet();

    sampleDeque();

    sampleStack();

    sampleSmartPointers();
     
    sampleTemplateFunctions();

    return 0;
}

void sampleLoops(){ 
    int* arr = new int[10];
    std::vector<int> v;
    //For
    for (int i = 0; i < 10; i++){
        cout << i; 
        arr[i] = i;
        v.push_back(i);
    }
    cout << std::endl;

    //Auto
    for (auto & val : v){ //Reference
        cout << val * 10;
    }
    cout << std::endl;

    for (auto val : v){ //Makes copy for value
        cout << val * 10;
    }
    cout << std::endl;

    //While
    int i = 0;
    while (i != v.size()){
        i++;
    }

    //Do While
    std::string input;
    int count = 0;
    do{
        cout << "input 'q': " << std::endl;
        count += 1;
        if (count == 5){
            input = 'q';
        }
    }
    while(input != "q");
}

void sampleTemplateFunctions(){
    //Calls the regular template function
    templateFunction(10, "string");
    templateFunction(10, 10);
    templateFunction<double, int>(10.5, 10);

    //Calls the specialized version of the function
    templateFunction<std::string, int>("String", 10);

    //Compile time deduction using enums
    templateFunctionEnums<Weather::sunny>(10);

    //Compile time deductions for factorial
    //Template mainly works to specify the value at compile time
    templateFunctionFactorial<5>();

    //Specifying values so that they're known at compile time not  runtime 
    templateFunctionFixedArraySize<10>();

    //Deduct the size of c style arrays using template
    int arr[5] = {0,1,2,3,4};
    templateFunctionSizeDeduction(arr);

    //Variadic - Unknown/specified number of parameters
    templateFunctionVariadic(1,2,3,4,5);
    templateFunctionVariadic(1,2,3);
    templateFunctionVariadic();

    //Filter out unacceptable types. SFINAE(Substitution Failure Is Not An Error)
    templateFunctionIntegralOnly(10);
    //Give an error because the function does not exist for a string only integral types
    //templateFunctionIntegralOnly("String");
}

void sampleConst(const int& y){ //Const parameter so can't be chaged
    int a = 5, b = 6;

    const int x = 10; //Cant change value
    const int* p = &a; //Pointer to const int
    int* const q = &a; //Const pointer to int
    const int* const r = &a; //Const pointer to const int
}

void sampleCast(){
    float x = 2.2;

    //Static cast conversion
    int y = static_cast<int>(x); 

    //Dynamic cast conversion. If cast fails returns nullptr
    BaseCar* carPtr1 = new ElectricCar(5, 10); 
    ElectricCar* electricCarPtr1 = dynamic_cast<ElectricCar*>(carPtr1);

    // BaseCar* carPtr2 = new BaseCar(5, 10); 
    // ElectricCar* electricCarPtr2 = dynamic_cast<ElectricCar*>(carPtr2); //Nullptr

    //const cast removes the const qualifier from the ptr
    const int* yptr = &y;
    int* ptry = const_cast<int*>(yptr);

    //reinterpret cast does bit reinterpretation
    int n = 50;
    char* charPtr = reinterpret_cast<char*>(&n); //First byte of int as a char
}

void sampleString(){
    string val1 = "Hello ", val2 = "World", val3 = "1", val4;

    //Concatenation
    val4 = val1 + val2 + "!!!";
    cout << "String concat " << val4 << std::endl;

    //String to int
    int x = std::stoi(val3);
    cout << "Str to int " << x << std::endl;

    //Int to string
    string val5 = std::to_string(x);
    cout << "int to str " << val5 << std::endl;

    //Find string index
    int val6 = val4.find("World"); //Find string from start, idx
    val6 = val4.rfind("World"); //Find string from end, idx
    if (val6 == string::npos){
        cout << "Substring not found" << std::endl;
    }

    //Find substring
    string sub = val4.substr(6,11);

    //Find first or last char of given chars
    string s = "hello world";
    cout << s.find_first_of("aeiou") << std::endl; // 1 ('e')
    cout << s.find_last_of("aeiou") << std::endl;  // 7 ('o')    
}

void sampleArray(){
    int arr1[] = {1,2,3,4,5,6,7,8,9};
    int* arr2 = new int[10];

    for(int i = 0; i < 10; i++){
        arr2[i] = i;
    }

    for (auto & val : arr1){ //Auto only valid for reg arrays not from 'new' as those are pointers
        cout << val << std::endl;
    }

    int* ptr = arr2;
    for (;ptr < arr2+10; ptr++){
        cout << *ptr << std::endl;
    }
    delete[] arr2;
}

void sampleVectorStack(){
    //Vector usage
    std::vector<std::vector<int>> grid;
    std::vector<int> row1;
    std::vector<int> row2;
    std::vector<int> row3;
    std::vector<int> extra;

    for (int i = 0; i < 10; i++){
        row1.push_back(i);
        row2.push_back(i+10);
        row3.push_back(i+100);
        extra.push_back(i);
    }
    grid.push_back(row1);
    grid.push_back(row2);
    grid.push_back(row3);

    //Get size of vector
    int gridSize = 0, rowSize = 0;
    gridSize = grid.size();
    rowSize = row1.size();
    cout << "Grid size: " << gridSize << " Row size: " << rowSize << std::endl;
    cout << "Grid at (0,0): " << grid[0][0] << std::endl;

    //Auto loop
    for (auto val : row1){
        cout << val << std::endl;
    }

    //Insert & Erase
    extra.insert(extra.begin()+1, 99); //Insert value 99 at index 1
    extra.erase(extra.begin() + 2); //Remove value at index 2

    //Stack usage
    std::vector<int> stack;
    stack.push_back(0);
    stack.push_back(1);
    stack.push_back(2);
    stack.push_back(3);
    stack.push_back(4);
    stack.push_back(5);

    //Get value and pop off stack
    int top = stack.back();
    stack.pop_back();
}

void sampleMap(){
    std::map<string, int> m;
    std::unordered_map<string, int> um;
    int val = 0;
    //Insert elements
    m["apple"] = 5;
    m.insert({"orange", 8});

    //Access 
    val = m.at("apple");

    //Iteration
    for (auto& [key, val] : m){
        cout << key << " -> " << val << std::endl;
    }

    //Find
    if (m.find("banana") == m.end()){
        cout << "No banana found" << std::endl;
    }

    //Erase
    m.erase("orange");

    //Size
    val = m.size();
}

void sampleSet(){
    std::set<int> s;
    s.insert(5);
    s.insert(6);
    s.insert(7);
    s.insert(8);
    s.insert(9);

    //Loop through set
    for (auto & val : s){
        cout << " " << val << " ";
    }
    cout << std::endl;

    //Check existance
    if (s.count(7)){
        cout << "7 is in the set" << std::endl;
    }

    //Remove value
    s.erase(8);
     
    //Get size
    int sz = s.size();
}

void sampleDeque(){
    //Declaration
    std::deque<int> dq;

    //Insert
    dq.push_back(1);
    dq.push_back(2);
    dq.push_back(3);
    dq.push_back(4);
    dq.push_back(5);
    dq.push_back(6);

    //Loop through dq values
    for (auto & val : dq){
        cout << val << " ";
    }
    cout << std::endl;

    //Get value at front or end
    int front = dq.front();
    int back = dq.back();

    //Removing values from front and end
    dq.pop_back();
    dq.pop_front();

    //Loop through elements
    for (auto val : dq){
        cout << val << " ";
    }
    cout << std::endl;

    //Get the size
    int sz = dq.size();
}   

void sampleStack(){
    std::stack<int> stack;

    //Insert
    stack.push(10);
    stack.push(15);

    //Get value at top of stack
    cout << stack.top() << std::endl;

    //Pop value from stack
    stack.pop(); 
}

void sampleSmartPointers(){
    //unique_ptr -> Desctructor called when owner ptr is out of scope
    std::unique_ptr<ElectricCar> u1 = std::make_unique<ElectricCar>(5, 10);
    int plate = u1->getLicensePlate();

    std::unique_ptr<ElectricCar> u2;
    //u2 = u1; //This gives an error as it cannot transfer ownership due to uniqueness
    u2 = std::move(u1); //Transfer ownership using move

    if (!u1){
        cout << "unique ptr 1 is now empty" << std::endl;
    }

    //shared_ptr -> Descturctor called when all owner ptrs are out of scope
    std::shared_ptr<ElectricCar> s1 = std::make_shared<ElectricCar>(10, 15);
    
    std::shared_ptr<ElectricCar> s2 = s1;

    //Num of pointers that share reference to same address
    cout << "Ref count = " << s1.use_count() << std::endl;

    //Completely depricated in c++11, 2011 & removed in c++ 17, 2017
    //auto_ptr -> Destructor is called when owner is out of scope
    // std::auto_ptr<ElectricCar> a1(new ElectricCar(20,25));
    
    // std::auto_ptr<ElectricCar> a2 = a1; //Ownership was transfered silently


    // //Check ownership
    // if (!a1.get()){
    //     cout << "a1 lost ownership" << std::endl;
    // }

    // plate = a2->getLicensePlate;
}

void sampleExtras(){
    //Get timestamp - uint64
    // auto timestamp = std::chrono::duration_cast<std::chrono::milliseconds>(
    //     now.time_since_epoch()
    // ).count();
    
    std::mutex mtx;
    std::shared_mutex shared_mtx;
    std::condition_variable cv;
    {
        std::unique_lock<std::mutex> lock(mtx);
        lock.unlock();
        lock.lock();
    } //Auto unlocks out of scope

    {
        std::shared_lock<std::shared_mutex> read_lock(shared_mtx);
    } //Auto unlocks out of scope

    std::thread worker_thread(sampleLoops);
    worker_thread.join();
}

void practice(){
    std::shared_ptr<ElectricCar> ptr = std::make_shared<ElectricCar>(10,15);
    std::shared_ptr<ElectricCar> ptr2 = ptr;

    std::unique_ptr<ElectricCar> uptr = std::make_unique<ElectricCar>(10,20);
    std::unique_ptr<ElectricCar> uptr2 = std::move(uptr);

    

    //vector
    std::vector<int> vector;
    vector.push_back(9);
    vector.push_back(15);
    vector.push_back(10);

    int val = vector.size();
    val = vector.back();
    vector.pop_back();
    vector.insert(vector.begin()+1, 100);
    vector.erase(vector.begin()+1);
}