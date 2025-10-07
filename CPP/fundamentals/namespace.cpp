#include "namespace.h"
#include <iostream>

//1.) Define a namespace -> Organize related code
namespace Francisco {
    void cout() { std::cout << "Francisco cout" << std::endl; }
}

//2.) Nested namespace -> To further separate code by name
namespace Francisco::Brain{
    void brain() { std::cout << "Francisco::Brain -> Brain Cooked" << std::endl; }
}

/*3.) Import the entire namespace setting it as the default for all of its keywords.
      - Specifying a namespace::keyword always works even if a using namespace has been defined. */
using namespace std;

/*4.) Sets the namespace a specific item
      - Now every use is assumed to used the std:: use case unless otherwise stated. */
using std::cout;
using std::endl;
using std::cin;
using std::string;

//5.) Namespace alias for longer names
namespace Frank = Francisco;

/*6.) Anonymous namespace private to only this .cpp file
      Using just the word secretHelper() always calls the anonymous unless another namespace is specified*/
namespace {
    int secretHelper(){ return 1; }
}

void sampleNamespace(){
    cout << "Using the namespace for simplicity" << endl;

    //Using the Francisco and its alias namespace
    Francisco::cout();
    Frank::cout();

    //Using the nested namespace
    Francisco::Brain::brain();

    //Using the anonymous namespace
    cout << "secret: " << secretHelper() << endl;
}