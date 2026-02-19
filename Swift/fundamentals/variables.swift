func variablesOverview() {
    varVsLet()
    typeAnnotationAndInference()
    numericTypes()
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


func numericTypes() {
    var integer: Int = 42 //Platform-sized: 64-bit on 64-bit systems
    var int8Val: Int8 = 127 //Range: -128 to 127
    var int16Val: Int16 = 32767
    var int32Val: Int32 = 2_147_483_647 //Underscores for readability (ignored by compiler)
    var int64Val: Int64 = 9_223_372_036_854_775_807

    var unsignedInt: UInt = 42 //Unsigned: 0 to max
    var unsignedInt8: UInt8 = 255 //Range: 0 to 255

    var floatVal: Float = 3.14 //32-bit, ~6 decimal places
    var doubleVal: Double = 3.141592653589793 //64-bit, ~15 decimal places (default for decimals)

    let decimal = 17
    let binary = 0b10001 //17 in binary
    let octal = 0o21 //17 in octal
    let hex = 0x11 //17 in hex
    let bigNumber = 1_000_000 //Underscores ignored by compiler, readability only
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