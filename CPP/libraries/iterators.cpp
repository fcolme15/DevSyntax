#include <iostream>
#include <iterator>

void iteratorSummary() {
    /*Sequence containers iterator works with:
    
    std::vector<int> vec;           // vec.begin(), vec.end()
    std::deque<int> deq;            // deq.begin(), deq.end()
    std::list<int> lst;             // lst.begin(), lst.end()
    std::array<int, 5> arr;         // arr.begin(), arr.end()
    std::forward_list<int> flist;   // flist.begin(), flist.end()

    //Associative containers
    std::set<int> s;                // s.begin(), s.end()
    std::map<int, string> m;        // m.begin(), m.end()
    std::multiset<int> ms;          // ms.begin(), ms.end()
    std::multimap<int, string> mm;  // mm.begin(), mm.end()

    //Unordered containers
    std::unordered_set<int> us;     // us.begin(), us.end()
    std::unordered_map<int, string> um;  // um.begin(), um.end() */

    std::vector<int> vec = {1, 2, 3, 4, 5};

    auto it = vec.begin(); //Points to first element
    auto endIt = vec.end(); //Points past last element
    
    //Forward iteration
    for (auto it = vec.begin(); it != vec.end(); ++it) {
        std::cout << *it << " "; //Dereference to get value
    }
    
    //Reverse iteration
    for (auto rit = vec.rbegin(); rit != vec.rend(); ++rit) {
        std::cout << *rit << " ";
    }
    
    //Iterator arithmetic (random access iterators)
    auto mid = vec.begin() + vec.size() / 2;
    auto third = vec.begin() + 2;
    
    //Advance iterator
    std::advance(it, 3); //Move forward 3 positions
    
    //Distance between iterators
    int dist = std::distance(vec.begin(), vec.end());
    
    //Modify through iterator
    *it = 100; //Change value at iterator position
    
    //Insert/erase with iterators
    vec.insert(vec.begin() + 2, 99); //Insert at position
    vec.erase(vec.begin() + 1); //Remove at position
    
    //Const iterator (read-only)
    for (auto cit = vec.cbegin(); cit != vec.cend(); ++cit) {
        //*cit = 5;  //ERROR: can't modify
        std::cout << *cit << " ";
    }
}