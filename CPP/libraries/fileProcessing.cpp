#include <iostream>
#include <fstream>

void fileProcessingSummary() {
    //Writing to file
    std::ofstream outFile("output.txt"); //Creates file
    if (outFile.is_open()) {
        outFile << 50 << std::endl;
        outFile << "Hello World" << std::endl;
        outFile << 42 << " " << 3.14 << std::endl;
        outFile.close();
    }
    
    //Reading from file
    std::ifstream inFile("output.txt");
    std::string line;
    int number;
    
    if (inFile.is_open()) {
        //Read line by line
        while (std::getline(inFile, line)) {
            std::cout << line << std::endl;
        }
        
        //Read word by word or number by number
        inFile.clear(); //Clear EOF flag
        inFile.seekg(0); //Go back to start
        while (inFile >> number) {
            std::cout << number << std::endl;
        }
        
        inFile.close();
    }
    
    //Read and write (append mode)
    std::fstream file("data.txt", std::ios::app);
    file << "Appended text" << std::endl;
    file.close();
    
    //Check if file exists/opened
    if (!inFile) {
        std::cerr << "File failed to open" << std::endl;
    }
}