func variablesOverview() {
    varVsLet()
    typeAnnotationAndInference()
    typeSafety()
    multipleAssignment()
    printingAndInterpolation()
    scope()
    lazyVariables()
}


func varVsLet() {
    //Can be reassigned
    var mutableValue = 42 
    var name = "Francisco"
    name = "Frank" //OK

    //Cannot be reassigned (compile error if attempted)
    let immutableValue = 42 
    let maxScore = 100
    //maxScore = 200 //Compile error
}


func typeAnnotationAndInference() {
    //Swift infference
    var inferredInt = 10 //Swift infers Int
    var inferredDouble = 3.14 //Swift infers Double. Default for decimals
    var inferredString = "hello" //Swift infers String
    var inferredBool = true //Swift infers Bool

    //Explicit annotation
    var explicitInt: Int = 10 
    var explicitDouble: Double = 3.14 
    let explicitString: String = "hello"
    let explicitBool: Bool = true

    //Must annotate Float, inferred decimal default is Double
    var explicitFloat: Float = 3.14 
    
    //Single character, must use explicit annotation
    var letter: Character = "A" 
    //var inferredChar = "A" //Inferred as String, not Character

    //Must declare type since no initial value
    var laterAssigned: Int 
    laterAssigned = 5
}


func typeSafety() {
    let myInt = 5
    let myDouble = 2.5

    //let sum = myInt + myDouble //Compile error - cannot mix Int and Double
    let sum = Double(myInt) + myDouble //Must explicitly convert
    let sumInt = myInt + Int(myDouble) //Int(Double) truncates, does not round
}


func multipleAssignment() {
    //Multiple vars, same type inferred
    var x = 0, y = 0, z = 0 
    var a: Int, b: Int, c: Int
    a = 1; b = 2; c = 3 //Semicolons allowed but uncommon in Swift
    
    let (firstName, age) = ("Francisco", 23) //Tuple-based multiple assignment
}


func printingAndInterpolation() {
    let name = "Francisco"
    let age = 23
    let myInt = 5

    print(name)
    print("Name: \(name), Age: \(age)") //String interpolation with \()
    print("Sum: \(myInt + 10)") //Expressions inside \()
    print("Pi is approximately \(Double.pi)") //Access type properties
}


func scope() {
    var outerVar = "Accessible in enclosing scope"

    if true {
        var blockVar = "Only inside this block"
        print(outerVar) //Can access enclosing scope
    }
    //print(blockVar) //Compile error - out of scope
}


//lazy is a property modifier for class/struct properties only, not usable inside a plain function
class DataProcessor {
    lazy var processedData: [Int] = {
        print("Computing only on first access...")
        return Array(1...1000)
    }()
}

func lazyVariables() {
    let processor = DataProcessor()
    //processedData not yet initialized at this point
    print(processor.processedData.count) //Initialized here on first access
}