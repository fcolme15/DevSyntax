func stringsOverview() {
    stringBasics()
    stringManipulation()
    stringSearchingAndChecking()
    stringIndexing()
    multilineAndSpecialCharacters()
    stringFormatting()
}


func stringBasics() {
    var greeting = "Hello"
    let name: String = "Francisco"

    //Concatenation
    let combined = greeting + ", " + name //Hello, Francisco
    greeting += "!" //Hello!

    //String interpolation - preferred over concatenation
    let age = 23
    let message = "Name: \(name), Age: \(age)"
    let expression = "Next year: \(age + 1)" //Any valid expression inside \()

    //String is a value type so copies on assignment. New var no reference issues
    var original = "hello"
    var copy = original
    copy = "world"
    //original is still "hello"

    //Equality checks value not reference
    let a = "hello"
    let b = "hello"
    let equal = a == b //true
}


func stringManipulation() {
    var str = "  Hello, Swift!  "

    let upper = str.uppercased() //"  HELLO, SWIFT!  "
    let lower = str.lowercased() //"  hello, swift!  "
    let trimmed = str.trimmingCharacters(in: .whitespaces) //"Hello, Swift!"

    //Replacing
    let replaced = str.replacingOccurrences(of: "Swift", with: "World") //"  Hello, World!  "

    //Splitting into array
    let csv = "a,b,c,d"
    let parts = csv.split(separator: ",") //["a", "b", "c", "d"] - returns [Substring]
    let partsAsStrings = csv.components(separatedBy: ",") //["a", "b", "c", "d"] - returns [String]

    //Joining array into string
    let words = ["Hello", "Swift", "World"]
    let joined = words.joined(separator: " ") //"Hello Swift World"

    //Appending
    var mutable = "Hello"
    mutable.append("!") //"Hello!"
    mutable.append(contentsOf: " World") //"Hello! World"

    //Removing
    var editable = "Hello, World!"
    editable.removeFirst() //"ello, World!"
    editable.removeLast() //"ello, World"
    editable.removeAll() //""
}


func stringSearchingAndChecking() {
    let str = "Hello, Swift!"

    let isEmpty = str.isEmpty //false
    let count = str.count //13

    let hasPrefix = str.hasPrefix("Hello") //true
    let hasSuffix = str.hasSuffix("!") //true
    let contains = str.contains("Swift") //true

    //Finding range of substring - returns optional Range
    if let range = str.range(of: "Swift") {
        print("Found Swift at: \(range)")
    }

    //First and last character
    let first = str.first //"H" - returns Character?
    let last = str.last //"!" - returns Character?
}


func stringIndexing() {
    let str = "Hello"

    //Swift strings cannot be indexed with integers like str[0]
    //This is because Swift strings are Unicode-aware and characters can be variable byte size

    //Must use String.Index type
    let startIndex = str.startIndex //Index of "H"
    let endIndex = str.endIndex //One past last character, not valid to read

    let firstChar = str[startIndex] //"H"

    //Offset from an index
    let secondIndex = str.index(startIndex, offsetBy: 1)
    let secondChar = str[secondIndex] //"e"

    //Safe indexing - check bounds before accessing
    if let safeIndex = str.index(startIndex, offsetBy: 3, limitedBy: str.endIndex) {
        print(str[safeIndex]) //"l"
    }

    //Substring slicing - returns Substring, not String
    let range = startIndex...secondIndex
    let slice = str[range] //"He" - type is Substring
    let asString = String(slice) //"He" - convert to String when needed
}


func multilineAndSpecialCharacters() {
    //Opening and closing """ must be on their own lines
    //Indentation of closing """ sets the baseline indentation stripped from all lines
    let multiline = """
        Line one
        Line two
        Line three
        """

    //Special characters / escape sequences
    let tab = "Hello\tWorld" //Tab
    let newline = "Hello\nWorld" //Newline
    let quote = "She said \"hello\"" //Escaped quote
    let backslash = "C:\\Users" //Escaped backslash
    let unicode = "\u{1F600}" //Unicode scalar - 😀

    //Extended string delimiters - treat special characters as literals
    let raw = #"No \n escape here"# //Backslash-n is literal, not a newline
    let rawInterp = #"Hello \#(42)"# //Use \#() for interpolation inside extended delimiter
}


func stringFormatting() {
    let pi = 3.14159265

    //String(format:) - printf style, requires Foundation
    let formatted = String(format: "Pi is %.2f", pi) //"Pi is 3.14"
    let padded = String(format: "%05d", 42) //"00042"

    //Interpolation with formatting
    let inlined = "\(pi)" //"3.14159265" - no rounding
    let rounded = String(format: "%.2f", pi) //"3.14"

    //Number to String
    let intStr = String(42) //"42"
    let doubleStr = String(3.14) //"3.14"

    //String to Number - returns optional, may fail
    let parsed = Int("42") //42
    let failed = Int("abc") //nil
}