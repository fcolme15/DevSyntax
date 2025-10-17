#include <iostream>
#include <algorithm>
#include <numeric> //For accumulate


void algorithmsSummary() {
    std::vector<int> vec = {5, 2, 8, 1, 9, 3};
    
    //Sorting
    std::sort(vec.begin(), vec.end()); //Ascending
    std::sort(vec.begin(), vec.end(), std::greater<int>()); //Descending
    
    //Searching
    auto it = std::find(vec.begin(), vec.end(), 8);
    if (it != vec.end()) {
        std::cout << "Found: " << *it << std::endl;
    }
    
    //Binary search (requires sorted)
    bool found = std::binary_search(vec.begin(), vec.end(), 5);
    
    //Min/Max
    auto minIt = std::min_element(vec.begin(), vec.end());
    auto maxIt = std::max_element(vec.begin(), vec.end());
    
    //Count occurrences
    int count = std::count(vec.begin(), vec.end(), 5);
    
    //Reverse
    std::reverse(vec.begin(), vec.end());
    
    //Transform (apply function to each element)
    std::transform(vec.begin(), vec.end(), vec.begin(), 
                   [](int x) { return x * 2; });
    
    //Remove (doesn't actually delete, use with erase)
    auto newEnd = std::remove(vec.begin(), vec.end(), 5);
    vec.erase(newEnd, vec.end());
    
    //For_each (apply function to each)
    std::for_each(vec.begin(), vec.end(), [](int x) {
        std::cout << x << " ";
    });
    
    //Accumulate (sum/reduce)
    int sum = std::accumulate(vec.begin(), vec.end(), 0);
}