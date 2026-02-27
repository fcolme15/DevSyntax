func arraysOverview() {
    arrayCreation()
    accessingElements()
    modifyingArrays()
    iterating()
    functionalMethods()
    searching()
    sorting()
}


func arrayCreation() {
    //Type inferred from contents
    var numbers = [1, 2, 3, 4, 5]
    var words = ["apple", "banana", "cherry"]

    //Explicit type annotation
    var explicit: [Int] = [1, 2, 3]
    var empty: [String] = []
    var emptyAlt = [String]() //Same thing, different syntax

    //Array with repeated value
    var zeros = Array(repeating: 0, count: 5) //[0, 0, 0, 0, 0]
    var grids = Array(repeating: [0, 0, 0], count: 3) //[[0,0,0],[0,0,0],[0,0,0]]

    //From a range
    var range = Array(1...5) //[1, 2, 3, 4, 5]

    //Combining arrays
    var combined = [1, 2, 3] + [4, 5, 6] //[1, 2, 3, 4, 5, 6]
}


func accessingElements() {
    let fruits = ["apple", "banana", "cherry", "date"]

    let first = fruits[0] //"apple"
    let last = fruits[fruits.count - 1] //"date"

    //Safe access via optional - avoids crash on out of bounds
    let safe = fruits.indices.contains(10) ? fruits[10] : nil //nil

    //First and last as optionals - safe, returns nil if empty
    let firstSafe = fruits.first //"apple" as String?
    let lastSafe = fruits.last //"date" as String?

    //Get the array size and check if empty
    let count = fruits.count //4
    let isEmpty = fruits.isEmpty //false

    //Slicing - returns ArraySlice, not Array
    let slice = fruits[1...2] //["banana", "cherry"] as ArraySlice
    let asArray = Array(fruits[1...2]) //Convert to Array when needed
}


func modifyingArrays() {
    var fruits = ["apple", "banana"]

    //Adding
    fruits.append("cherry") //Add to end
    fruits.append(contentsOf: ["date", "elderberry"]) //Add multiple to end
    fruits.insert("avocado", at: 0) //Insert at index, shifts others right

    //Removing
    fruits.remove(at: 0) //Remove at index, returns removed element
    fruits.removeFirst() //Remove first element
    fruits.removeLast() //Remove last element
    fruits.removeAll() //Empty the array

    //Replacing
    var numbers = [1, 2, 3, 4, 5]
    numbers[0] = 99 //Replace single element
    numbers[1...3] = [20, 30, 40] //Replace range with new values

    //Swapping
    numbers.swapAt(0, 4) //Swap elements at two indices
}


func iterating() {
    let numbers = [10, 20, 30, 40, 50]

    //for-in
    for number in numbers { print(number) }

    //With index
    for (index, number) in numbers.enumerated() {
        print("\(index): \(number)")
    }

    //forEach - closure based, cannot use break or continue
    numbers.forEach { print($0) }
}


func functionalMethods() {
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    //map - transform each element, returns new array of same size
    let doubled = numbers.map { $0 * 2 } //[2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

    //filter - keep elements where condition is true
    let evens = numbers.filter { $0 % 2 == 0 } //[2, 4, 6, 8, 10]

    //reduce - combine all elements into one value
    let sum = numbers.reduce(0, +) //55
    let product = numbers.reduce(1, *) //3628800

    //compactMap - map then drop nils, useful when transform returns optional
    let strings = ["1", "two", "3", "four"]
    let parsed = strings.compactMap { Int($0) } //[1, 3]

    //flatMap - map then flatten one level of nesting
    let nested = [[1, 2], [3, 4], [5, 6]]
    let flat = nested.flatMap { $0 } //[1, 2, 3, 4, 5, 6]

    //Chaining
    let result = numbers
        .filter { $0 % 2 == 0 }
        .map { $0 * $0 }
        .reduce(0, +) //220

    //lazy - defers computation until result is needed, efficient for large arrays
    let lazyResult = numbers.lazy.filter { $0 % 2 == 0 }.map { $0 * 2 }
}


func searching() {
    let numbers = [3, 1, 4, 1, 5, 9, 2, 6]

    let contains = numbers.contains(5) //true
    let firstIndex = numbers.firstIndex(of: 1) //1 - index of first occurrence
    let lastIndex = numbers.lastIndex(of: 1) //3

    //Search with condition
    let firstEven = numbers.first { $0 % 2 == 0 } //4 - first match as optional
    let allPositive = numbers.allSatisfy { $0 > 0 } //true
    let anyOver8 = numbers.contains { $0 > 8 } //true
    let evenCount = numbers.filter { $0 % 2 == 0 }.count //3

    //Min and max
    let min = numbers.min() //1
    let max = numbers.max() //9
    let minBy = numbers.min(by: { $0 < $1 }) //1 - custom comparator
}


func sorting() {
    var numbers = [3, 1, 4, 1, 5, 9, 2, 6]

    //sorted - returns new sorted array, original unchanged
    let ascending = numbers.sorted() //[1, 1, 2, 3, 4, 5, 6, 9]
    let descending = numbers.sorted(by: >) //[9, 6, 5, 4, 3, 2, 1, 1]

    //sort - sorts in place, modifies original
    numbers.sort()
    numbers.sort(by: >)

    //Custom sort
    var words = ["banana", "apple", "cherry", "date"]
    let byLength = words.sorted { $0.count < $1.count } //["date", "apple", "banana", "cherry"]

    //Shuffle
    numbers.shuffle() //In place
    let shuffled = numbers.shuffled() //Returns new array
}