func optionalsOverview() {
    optionalBasics()
    forcedUnwrapping()
    optionalBinding()
    guardUnwrapping()
    optionalChaining()
    nilCoalescing()
    implicitlyUnwrappedOptionals()
}


func optionalBasics() {
    //Optional means a variable can hold a value OR nil (absence of value)
    //Declared with ? after the type
    var age: Int? = 25 //Holds an Int
    var name: String? = nil //Holds nothing

    age = nil //Can be set to nil at any time
    age = 30 //Can be set back to a value

    //Cannot use an optional directly as its underlying type
    var score: Int? = 85
    //let doubled = score * 2 //Compile error - score is Int? not Int, must unwrap first
}


func forcedUnwrapping() {
    var score: Int? = 85

    //Force unwrap with ! - extracts value, crashes at runtime if nil
    let value = score! //85
    print(score!) //85

    //Only force unwrap when absolutely certain the value is not nil
    var empty: Int? = nil
    //print(empty!) //Runtime crash - fatal error: unexpectedly found nil
}


func optionalBinding() {
    var score: Int? = 85
    var name: String? = nil

    //if let - safely unwraps into a new constant, only executes if value exists
    if let unwrapped = score {
        print("Score is \(unwrapped)") //unwrapped is Int, not Int?
    }

    //Shadowing - reuse same name for the unwrapped value (common Swift style)
    if let score = score {
        print("Score is \(score)") //score here is Int
    }

    //Shorthand shadowing (Swift 5.7+) - omit right side when names match
    if let score {
        print("Score is \(score)")
    }

    //else branch handles nil case
    if let score {
        print("Score: \(score)")
    } else {
        print("No score")
    }

    //Unwrap multiple optionals in one if let - all must have values to enter block
    if let score, let name {
        print("\(name): \(score)")
    }
}


func guardUnwrapping() {
    //guard let - unwraps and makes value available for the rest of the scope
    //else block must exit: return, throw, break, or continue
    func printScore(_ score: Int?) {
        guard let score else {
            print("No score provided")
            return
        }
        //score is Int here, available for the rest of the function
        print("Score: \(score)")
    }

    //guard preferred over if let when invalid state should exit early
    //keeps the happy path unindented
    func process(_ value: Int?) {
        guard let value else { return }
        guard value > 0 else { return }
        print("Valid value: \(value)")
    }

    printScore(85)
    printScore(nil)
}


func optionalChaining() {
    //Access properties/methods on an optional without unwrapping
    //Returns nil if any link in the chain is nil, otherwise returns optional of the result
    struct Address {
        var city: String
    }
    struct Person {
        var name: String
        var address: Address?
    }

    var person: Person? = Person(name: "Francisco", address: Address(city: "Chicago"))

    //Without chaining would need to unwrap each level manually
    let city = person?.address?.city //String? - "Chicago" if all links exist, nil otherwise

    var noPerson: Person? = nil
    let noCity = noPerson?.address?.city //nil - chain short-circuits at first nil

    //Calling methods through optional chaining
    var optionalString: String? = "hello"
    let upper = optionalString?.uppercased() //String? - "HELLO"

    var nilString: String? = nil
    let nilUpper = nilString?.uppercased() //nil
}


func nilCoalescing() {
    //Provides a default value when optional is nil
    //Equivalent to: optional != nil ? optional! : defaultValue
    let score: Int? = nil
    let display = score ?? 0 //0

    let name: String? = "Francisco"
    let displayName = name ?? "Unknown" //"Francisco"

    //Chaining nil coalescing
    let a: Int? = nil
    let b: Int? = nil
    let c: Int? = 42
    let result = a ?? b ?? c ?? 0 //42 - uses first non-nil value
}


func implicitlyUnwrappedOptionals() {
    //Declared with ! instead of ? - treated as optional but auto-unwrapped on access
    //Crashes if nil when accessed, same as forced unwrap
    var assumed: Int! = 42
    let value = assumed //No need to unwrap, used as Int directly

    //Used when a value starts nil but is guaranteed to have a value before use
    //Most common in UIKit where IBOutlets are set after initialization
    //Avoid in general Swift code, prefer regular optionals
}