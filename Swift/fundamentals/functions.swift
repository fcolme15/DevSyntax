func functionsOverview() {
    basicFunctions()
    argumentLabels()
    returnValues()
    specialParameters()
    functionTypes()
}


func basicFunctions() {
    //Basic function - no parameters, no return
    func greet() {
        print("Hello!")
    }
    greet()

    //Function with parameters - type annotation required, no inference for parameters
    func greetName(name: String) {
        print("Hello, \(name)!")
    }
    greetName(name: "Francisco") //Caller must use parameter name by default
    
    //Parameters can have default values - must be at end by convention
    func greet(name: String, greeting: String = "Hello") {
        print("\(greeting), \(name)!")
    }
    greet(name: "Francisco") //Uses default: "Hello, Francisco!"
    greet(name: "Francisco", greeting: "Hey") //"Hey, Francisco!"

    //Functions can be defined inside other functions
    //Nested functions are scoped to their enclosing function
}


func argumentLabels() {
    //Swift functions have two names per parameter: external label and internal name
    //external is what the caller uses, internal is what the function body uses
    func drive(from origin: String, to destination: String) {
        print("Driving from \(origin) to \(destination)") //Uses internal names
    }
    drive(from: "Chicago", to: "New York") //Uses external labels - reads like English

    //Underscore suppresses external label - caller uses no label
    func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b //Uses internal names
    }
    multiply(3, 4) //No labels at call site

    //Mix of labeled and unlabeled
    func greet(_ name: String, with greeting: String) {
        print("\(greeting), \(name)!")
    }
    greet("Francisco", with: "Hello")
}


func returnValues() {
    //Single return value
    func square(_ n: Int) -> Int {
        return n * n
    }

    //Implicit return - single expression functions can omit return keyword
    func cube(_ n: Int) -> Int { n * n * n }

    //Return multiple values using a tuple
    func minMax(of array: [Int]) -> (min: Int, max: Int) {
        return (array.min()!, array.max()!)
    }
    let result = minMax(of: [3, 1, 4, 1, 5])
    print(result.min) //1
    print(result.max) //5

    //Optional return - function may return nil
    func findFirst(_ value: Int, in array: [Int]) -> Int? {
        return array.firstIndex(of: value)
    }

    //Void return - explicitly returns nothing, same as omitting return type
    func logMessage(_ msg: String) -> Void {
        print(msg)
    }
}


func specialParameters() {
    //inout allows a function to modify the caller's variable directly
    //Pass with & at call site, similar to pass-by-reference
    func doubleValue(_ value: inout Int) {
        value *= 2
    }

    var number = 5
    doubleValue(&number) //& required at call site
    print(number) //10 - original variable was modified

    //Cannot pass constants or literals as inout
    //doubleValue(&42) //Compile error


    //Accepts zero or more values of a type, received as an array inside the function
    func sum(_ numbers: Int...) -> Int {
        return numbers.reduce(0, +)
    }
    sum(1, 2, 3) //6
    sum(1, 2, 3, 4, 5) //15
    sum() //0

    //Only one variadic parameter per function
    //Must be last parameter if mixed with others
    func log(prefix: String, _ messages: String...) {
        messages.forEach { print("\(prefix): \($0)") }
    }
    log(prefix: "INFO", "Started", "Running", "Done")
}


func functionTypes() {
    //Functions are first-class types in Swift
    //Type is expressed as (ParameterTypes) -> ReturnType
    func add(_ a: Int, _ b: Int) -> Int { a + b }
    func subtract(_ a: Int, _ b: Int) -> Int { a - b }

    //Storing a function in a variable
    var operation: (Int, Int) -> Int = add
    operation(3, 4) //7
    operation = subtract
    operation(3, 4) //-1

    //Passing a function as a parameter
    func compute(_ a: Int, _ b: Int, using op: (Int, Int) -> Int) -> Int {
        return op(a, b)
    }
    compute(3, 4, using: add) //7
    compute(3, 4, using: subtract) //-1

    //Returning a function from a function
    func makeMultiplier(by factor: Int) -> (Int) -> Int {
        func multiply(_ n: Int) -> Int { n * factor }
        return multiply
    }
    let triple = makeMultiplier(by: 3)
    triple(5) //15

    //Closures covered in Closures.swift
}