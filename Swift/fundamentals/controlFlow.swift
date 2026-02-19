func controlFlowOverview() {
    ifElse()
    guardStatement()
    switchStatement()
    breakContinueLabels()
}


func ifElse() {
    let score = 85

    //Standard if/else - no parentheses required around condition (but allowed)
    if score >= 90 {
        print("A")
    } else if score >= 80 {
        print("B")
    } else {
        print("C")
    }

    //if as an expression (Swift 5.9+) - can assign result directly
    let grade = if score >= 90 { "A" } else if score >= 80 { "B" } else { "C" }
}


func guardStatement() {
    //guard is an early exit pattern - condition must be true to continue
    //else block must exit the current scope (return, throw, break, continue)
    //The guard vairable is available for the rest of the function
    func processAge(_ age: Int?) {
        guard let age = age else {
            print("No age provided")
            return //Must exit
        }
        //age is unwrapped and available for the rest of the function
        print("Age is \(age)")
    }

    //guard vs if: use guard when invalid state should exit early
    //Keeps the happy path unindented and readable
    func processScore(_ score: Int) {
        guard score >= 0 && score <= 100 else {
            print("Invalid score")
            return
        }
        //All further code assumes score is valid
        print("Score: \(score)")
    }

    processAge(23)
    processAge(nil)
    processScore(85)
}


func switchStatement() {
    let value = 3

    //Switch in Swift is exhaustive - must cover all cases or have a default
    //No fallthrough by default unlike Java/C - each case breaks automatically
    switch value {
    case 1:
        print("One")
    case 2, 3: //Multiple values in one case
        print("Two or Three")
    case 4...10: //Range matching - covered in Loops.swift
        print("Four to Ten")
    default:
        print("Something else")
    }

    //Switch on strings
    let day = "Monday"
    switch day {
    case "Monday", "Tuesday", "Wednesday", "Thursday", "Friday":
        print("Weekday")
    case "Saturday", "Sunday":
        print("Weekend")
    default:
        print("Unknown")
    }

    //Value binding in cases
    let point = (2, 0)
    switch point {
    case (0, 0):
        print("Origin")
    case (let x, 0): //Binds x to the first value, matches any point on x-axis
        print("On x-axis at \(x)")
    case (0, let y):
        print("On y-axis at \(y)")
    case (let x, let y):
        print("At \(x), \(y)")
    }

    //Where clause - adds condition to a case
    let num = 7
    switch num {
    case let n where n % 2 == 0:
        print("\(n) is even")
    case let n where n % 2 != 0:
        print("\(n) is odd")
    default:
        break
    }

    //Explicit fallthrough - opt in when needed
    switch value {
    case 3:
        print("Three")
        fallthrough //Executes next case regardless of its condition
    case 4:
        print("Three or Four")
    default:
        break
    }
}


func breakContinueLabels() {
    //break - exits current loop or switch
    for i in 1...10 {
        if i == 5 { break }
        print(i) //Prints 1 through 4
    }

    //continue - skips to next iteration
    for i in 1...5 {
        if i == 3 { continue }
        print(i) //Prints 1, 2, 4, 5
    }

    //Labeled statements - break/continue to a specific outer loop
    outer: for i in 1...3 {
        for j in 1...3 {
            if j == 2 { continue outer } //Skip to next iteration of outer loop
            print("\(i), \(j)")
        }
    }

    //return - exits function, covered in Functions.swift
    //throw - exits with error, covered in Concurrency/ErrorHandling.swift
}