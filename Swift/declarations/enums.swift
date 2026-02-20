func enumsOverview() {
    enumBasics()
    rawValues()
    associatedValues()
    enumMethods()
    enumPatternMatching()
}


func enumBasics() {
    //Enum defines a type with a fixed set of named cases
    enum Direction { //Not initialized type so just named cases
        case north
        case south
        case east
        case west
    }

    //Cases can be on one line
    enum Season { case spring, summer, fall, winter }

    var heading = Direction.north
    heading = .south //Type already known, shorthand dot syntax works

    //Enums are value types like structs
}


func rawValues() {
    //Raw values assign a backing value to each case
    //All cases must have the same raw value type
    //Int type makes it count and be represented by numbers
    enum Planet: Int {
        case mercury = 1, venus, earth, mars //Auto-increments from 1
    }

    let earth = Planet.earth
    print(earth.rawValue) //3

    //Initialize from raw value - returns optional since value may not match any case
    let planet = Planet(rawValue: 2) //Planet? - venus
    let invalid = Planet(rawValue: 99) //nil

    //String raw values - case name used if not specified explicitly
    enum Direction: String {
        case north, south, east, west //Raw values are "north", "south", etc.
        case northEast = "NE" //Explicit override
    }

    print(Direction.north.rawValue) //"north"
    print(Direction.northEast.rawValue) //"NE"
}


func associatedValues() {
    //Associated values attach additional data to a specific case
    //Each case can have different types - this is far beyond what Java enums can do
    enum Barcode {
        case upc(Int, Int, Int, Int)
        case qrCode(String)
    }

    var productCode = Barcode.upc(8, 85909, 51226, 3)
    productCode = .qrCode("ABCDEFGH") //Changes from upc to qrCode

    //Extract associated values with pattern matching
    switch productCode {
    case .upc(let numberSystem, let manufacturer, let product, let check):
        print("UPC: \(numberSystem)-\(manufacturer)-\(product)-\(check)")
    case .qrCode(let code):
        print("QR: \(code)")
    }

    //Shorthand - let before case name applies to all associated values
    switch productCode {
    case let .upc(ns, man, prod, check):
        print("UPC: \(ns)-\(man)-\(prod)-\(check)")
    case let .qrCode(code):
        print("QR: \(code)")
    }
}


func enumMethods() {
    enum Season {
        case spring, summer, fall, winter

        //Enums can have methods and computed properties
        var isWarm: Bool {
            switch self {
            case .spring, .summer: return true
            case .fall, .winter: return false
            }
        }

        func next() -> Season {
            switch self {
            case .spring: return .summer
            case .summer: return .fall
            case .fall: return .winter
            case .winter: return .spring
            }
        }

        //mutating required to change self in a value type
        mutating func advance() {
            self = self.next()
        }
    }

    var current = Season.summer
    print(current.isWarm) //true
    current.advance()
    print(current) //fall
}


func enumPatternMatching() {
    enum Shape {
        case circle(radius: Double)
        case rectangle(width: Double, height: Double)
        case triangle(base: Double, height: Double)
    }

    let shape = Shape.circle(radius: 5.0)

    //if case - match a single case without full switch
    if case .circle(let radius) = shape { //Shape.circle also valid syntax
        print("Circle with radius \(radius)")
    }

    //for case - filter loop to only matching cases
    let shapes: [Shape] = [.circle(radius: 3), .rectangle(width: 4, height: 5), .circle(radius: 7)]
    for case .circle(let radius) in shapes {
        print("Found circle: \(radius)") //Only circles, rectangle skipped
    }

    //Switch with where clause for additional conditions
    switch shape {
    case .circle(let r) where r > 10:
        print("Large circle")
    case .circle(let r):
        print("Circle: \(r)")
    case .rectangle(let w, let h) where w == h:
        print("Square")
    case .rectangle(let w, let h):
        print("Rectangle: \(w)x\(h)")
    case .triangle(let b, let h):
        print("Triangle")
    }
}