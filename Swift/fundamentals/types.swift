func typesOverview() {
    intTypes()
    floatingPointTypes()
    boolType()
    stringType()
    characterType()
    typeAliases()
}


func intTypes() {
    //Default integer type, platform-sized (64-bit on modern Apple hardware)
    var integer: Int = 42
    
    var int8Val: Int8 = 127 //Range: -128 to 127
    var int16Val: Int16 = 32767 //Range: -32768 to 32767
    var int32Val: Int32 = 2_147_483_647
    var int64Val: Int64 = 9_223_372_036_854_775_807

    //Unsigned integers - no negative values, doubles positive range
    var uInt: UInt = 42 //Platform-sized unsigned
    var uInt8: UInt8 = 255 //Range: 0 to 255

    //Numeric literal formats - all represent the same value
    let decimal = 17
    let binary = 0b10001 //0b prefix for binary
    let octal = 0o21 //0o prefix for octal
    let hex = 0x11 //0x prefix for hex
    let readable = 1_000_000 //Underscores ignored by compiler, readability only

    //Useful type properties
    let maxInt = Int.max //9223372036854775807 on 64-bit
    let minInt = Int.min //-9223372036854775808 on 64-bit
    let maxUInt8 = UInt8.max //255
}


func floatingPointTypes() {
    //Double is the default inferred type for decimal literals
    var doubleVal: Double = 3.141592653589793 //64-bit, ~15 decimal digits of precision
    var floatVal: Float = 3.14 //32-bit, ~6 decimal digits of precision

    //Must annotate explicitly, otherwise inferred as Double
    var inferredDouble = 3.14 //Double
    var explicitFloat: Float = 3.14 //Float

    //Scientific notation
    let exponent = 1.25e2 //125.0 (1.25 x 10^2)
    let smallNum = 1.25e-2 //0.0125

    //Hex floating point (rare, used in low-level/graphics code)
    let hexFloat = 0xFp2 //60.0 (15 x 2^2)

    //Special values
    let infinity = Double.infinity
    let notANumber = Double.nan
    let isNaN = notANumber.isNaN //true - cannot use == to check for NaN
}


func boolType() {
    var isActive: Bool = true
    var isComplete = false //Inferred as Bool

    //Swift does not allow non-Bool in conditions unlike C/Java
    let x = 1
    //if x { } //Compile error - must be explicit Bool expression
    if x == 1 { } //Correct
}


func stringType() {
    var greeting = "Hello" //Inferred as String
    let name: String = "Francisco"

    //Multi-line string literal - opening/closing """ must be on their own lines
    let multiLine = """
        Line one
        Line two
        Line three
        """

    //String interpolation
    let age = 23
    let message = "Name: \(name), Age: \(age)" //Any expression valid inside \()
    let computed = "Next year: \(age + 1)"

    //String is a value type - copies on assignment
    var original = "hello"
    var copy = original
    copy = "world"
    //original is still "hello"

    //Concatenation
    var combined = greeting + ", " + name //Hello, Francisco
    combined += "!" //Hello, Francisco!
}


func characterType() {
    //Must annotate explicitly, "A" alone infers as String
    var letter: Character = "A"
    //var inferred = "A" //Inferred as String, not Character

    //Characters can be emoji or unicode
    let heart: Character = "❤️"
    let lambda: Character = "\u{03BB}" //Unicode scalar λ

    //Building a string from characters
    let chars: [Character] = ["S", "w", "i", "f", "t"]
    let word = String(chars) //Swift
}


func typeAliases() {
    //typealias creates an alternative name for an existing type
    typealias Score = Int
    typealias PlayerName = String

    var highScore: Score = 9999 //Same as Int, just more descriptive
    var player: PlayerName = "Francisco"

    //Common in networking/data contexts for clarity
    typealias Milliseconds = Double
    let timeout: Milliseconds = 3000.0
}