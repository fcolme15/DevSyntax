func collectionsOverview() {
    sequenceAndCollection()
    lazyCollections()
    arraySlice()
}


func sequenceAndCollection() {
    //Sequence - anything you can iterate over with for-in
    //Collection - Sequence that also supports index-based access and count
    //Array, Dictionary, Set, String all conform to Collection

    //Collection gives you these for free on any conforming type:
    let numbers = [3, 1, 4, 1, 5, 9]

    numbers.count //6
    numbers.isEmpty //false
    numbers.first //3 as Int?
    numbers.last //9 as Int?
    numbers.min() //1
    numbers.max() //9
    numbers.contains(4) //true
    numbers.prefix(3) //[3, 1, 4] - first n elements
    numbers.suffix(2) //[5, 9] - last n elements
    numbers.dropFirst(2) //[4, 1, 5, 9]
    numbers.dropLast(2) //[3, 1, 4, 1]

    //zip - pair elements from two sequences
    let names = ["Alice", "Bob", "Carol"]
    let scores = [95, 87, 92]
    let paired = zip(names, scores) //Sequence of (String, Int) tuples
    for (name, score) in paired {
        print("\(name): \(score)")
    }

    //Stops at shortest sequence
    let zipped = Array(zip([1, 2, 3], ["a", "b"])) //[(1, "a"), (2, "b")]
}


func lazyCollections() {
    //lazy defers computation - elements processed only when accessed
    //Efficient for large collections when you don't need all results
    let numbers = Array(1...1_000_000)

    //Without lazy - filter and map process all 1,000,000 elements immediately
    let eager = numbers.filter { $0 % 2 == 0 }.map { $0 * 2 }.prefix(5)

    //With lazy - only processes elements until 5 results are found
    let lazy = numbers.lazy.filter { $0 % 2 == 0 }.map { $0 * 2 }.prefix(5)
    let result = Array(lazy) //[2, 4, 6, 8, 10] - only computed 10 elements

    //lazy is a view - doesn't create intermediate arrays
    //Convert to Array when you need to store or reuse the result
}


func arraySlice() {
    let numbers = [10, 20, 30, 40, 50]

    //Slicing returns ArraySlice - a view into the original array, shares memory
    let slice = numbers[1...3] //ArraySlice [20, 30, 40]

    //ArraySlice preserves original indices
    print(slice.startIndex) //1 - not 0
    print(slice[1]) //20 - uses original index

    //Convert to Array to get 0-based indexing
    let asArray = Array(slice) //[20, 30, 40]
    print(asArray[0]) //20

    //Don't store ArraySlice long-term - it holds a reference to the original array
    //preventing deallocation. Convert to Array if you need to keep it.
}