func operatorsOverview() {
    arithmeticOperators()
    comparisonOperators()
    logicalOperators()
    assignmentOperators()
    nilCoalescingOperator()
    ternaryOperator()
    bitwiseOperators()
}


func arithmeticOperators() {
    let a = 10
    let b = 3

    let sum = a + b //13
    let diff = a - b //7
    let product = a * b //30
    let quotient = a / b //3 - integer division truncates
    let remainder = a % b //1

    //Floating point division
    let x: Double = 10
    let y: Double = 3
    let precise = x / y //3.333...

    //Unary operators
    var c = 5
    c = -c //-5
    c = +c //5 (rarely used, no effect)

    //No ++ or -- in Swift (removed in Swift 3)
    c += 1 //Use += instead
    c -= 1
}


func comparisonOperators() {
    let a = 5
    let b = 10

    let eq = a == b //false
    let notEq = a != b //true
    let gt = a > b //false
    let lt = a < b //true
    let gte = a >= b //false
    let lte = a <= b //true

    //All comparisons return Bool
    //Identity operators === and !== covered in Declarations/Classes.swift
}


func logicalOperators() {
    let t = true
    let f = false

    let and = t && f //false - short-circuits, right side not evaluated if left is false
    let or = t || f //true - short-circuits, right side not evaluated if left is true
    let not = !t //false

    //Combine with parentheses for clarity
    let complex = (t && !f) || (f && t) //true
}


func assignmentOperators() {
    var a = 10

    a += 5 //a = 15
    a -= 3 //a = 12
    a *= 2 //a = 24
    a /= 4 //a = 6
    a %= 4 //a = 2

    //Unlike C/Java, assignment does not return a value in Swift
    var b = 0
    //if (b = 5) { } //Compile error - prevents accidental assignment in conditions
}


func nilCoalescingOperator() {
    //Unwraps optional if it has a value, otherwise uses default - covered fully in Optionals.swift
    let optional: Int? = nil
    let value = optional ?? 0 //0 - default used since optional is nil

    let name: String? = "Francisco"
    let display = name ?? "Unknown" //"Francisco" - optional had a value
}


func ternaryOperator() {
    let score = 85
    let grade = score >= 60 ? "Pass" : "Fail" //"Pass"

    //Equivalent to:
    //if score >= 60 { grade = "Pass" } else { grade = "Fail" }
}


func bitwiseOperators() {
    let a: UInt8 = 0b11001100
    let b: UInt8 = 0b10101010

    let bitwiseAnd = a & b //0b10001000
    let bitwiseOr = a | b //0b11101110
    let bitwiseXor = a ^ b //0b01100110
    let bitwiseNot = ~a //0b00110011

    //Bit shifting
    let leftShift = a << 1 //Shifts bits left, equivalent to multiplying by 2
    let rightShift = a >> 1 //Shifts bits right, equivalent to dividing by 2
}