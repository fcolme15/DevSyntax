func closuresOverview() {
    closureBasics()
    trailingClosureSyntax()
    shorthandSyntax()
    captureLists()
    escapingClosures()
    commonHigherOrderFunctions()
}


func closureBasics() {
    //Closure - a self-contained block of code that can be stored and passed around
    //Same as a function but anonymous, defined inline with { }
    //Full syntax: { (parameters) -> ReturnType in body }
    let greet = { (name: String) -> String in
        return "Hello, \(name)!"
    }
    greet("Francisco") //"Hello, Francisco!"

    //Closures are the same as function types
    var operation: (Int, Int) -> Int = { (a: Int, b: Int) -> Int in
        return a + b
    }
    operation(3, 4) //7

    //Passing a closure as a function argument
    func compute(_ a: Int, _ b: Int, using op: (Int, Int) -> Int) -> Int {
        return op(a, b)
    }
    compute(3, 4, using: { (a: Int, b: Int) -> Int in return a + b }) //7
}


func shorthandSyntax() {
    //Swift can infer types from context - drop type annotations
    var operation: (Int, Int) -> Int = { a, b in a + b }

    //Shorthand argument names - $0, $1, $2... replace parameter names
    //Implicit return - single expression closures omit return
    operation = { $0 + $1 }

    //Operator as closure - when the operator matches the required signature
    let numbers = [3, 1, 4, 1, 5, 9]
    let sorted = numbers.sorted(by: <) //[1, 1, 3, 4, 5, 9] - < is (Int, Int) -> Bool
}


func trailingClosureSyntax() {
    func compute(_ a: Int, _ b: Int, using op: (Int, Int) -> Int) -> Int {
        return op(a, b)
    }
    //When closure is the last argument it can move outside the parentheses
    let result = compute(3, 4) { $0 + $1 }

    //When closure is the only argument, parentheses can be omitted entirely
    let numbers = [3, 1, 4, 1, 5]
    let doubled = numbers.map { $0 * 2 } //[6, 2, 8, 2, 10]

    //Multiple trailing closures - first unlabeled, rest labeled
    func load(url: String, onSuccess: (String) -> Void, onFailure: (String) -> Void) { }
    load(url: "https://example.com") { data in
        print("Success: \(data)")
    } onFailure: { error in
        print("Error: \(error)")
    }
}


func captureLists() {
    //Closures capture references to variables from their surrounding scope
    var count = 0
    let increment = {
        count += 1 //Captures count by reference - modifies the original
    }
    increment()
    increment()
    print(count) //2 - original was modified

    //Capture list - control how values are captured
    //[value] captures by value at the time the closure is created
    var x = 10
    let captureByValue = { [x] in //x is copied at closure creation
        print(x)
    }
    x = 99
    captureByValue() //10 - captured the value of x when closure was created, not 99

    //Weak capture - used to avoid retain cycles with reference types
    //Covered fully in Declarations/MemoryManagement.swift
    class MyClass {
        var value = 42
        func makeClosureWeak() -> () -> Void {
            return { [weak self] in //self is captured weakly, becomes optional
                print(self?.value ?? 0)
            }
        }
    }
}


func escapingClosures() {
    //@escaping means the closure outlives the function call - stored or called asynchronously
    //Non-escaping is default - closure is called within the function and discarded
    var stored: (() -> Void)? = nil

    func store(closure: @escaping () -> Void) {
        stored = closure //Closure escapes - lives beyond the function call
    }

    store { print("I escaped!") }
    stored?() //"I escaped!" - called later
}


func commonHigherOrderFunctions() {
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let words = ["banana", "apple", "cherry", "date"]

    //map - transform each element, returns new array of same size
    let doubled = numbers.map { $0 * 2 } //[2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
    let upperWords = words.map { $0.uppercased() } //["BANANA", "APPLE", ...]

    //filter - keep elements where condition is true
    let evens = numbers.filter { $0 % 2 == 0 } //[2, 4, 6, 8, 10]
    let shortWords = words.filter { $0.count <= 4 } //["date"]

    //reduce - combine all elements into a single value
    let sum = numbers.reduce(0) { $0 + $1 } //55 - 0 is initial value
    let sumShorthand = numbers.reduce(0, +) //55 - operator shorthand
    let sentence = words.reduce("") { $0 + " " + $1 } //" banana apple cherry date"

    //sorted - returns sorted copy, original unchanged
    let sortedNums = numbers.sorted { $0 > $1 } //[10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    let sortedWords = words.sorted { $0 < $1 } //alphabetical

    //compactMap - map + unwrap optionals, drops nil results
    let strings = ["1", "two", "3", "four", "5"]
    let parsed = strings.compactMap { Int($0) } //[1, 3, 5] - nils from failed conversions dropped

    //flatMap - map then flatten one level of nesting
    let nested = [[1, 2], [3, 4], [5, 6]]
    let flat = nested.flatMap { $0 } //[1, 2, 3, 4, 5, 6]

    //Chaining - combine operations
    let result = numbers
        .filter { $0 % 2 == 0 } //[2, 4, 6, 8, 10]
        .map { $0 * $0 } //[4, 16, 36, 64, 100]
        .reduce(0, +) //220
}