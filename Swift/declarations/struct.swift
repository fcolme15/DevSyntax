func structsOverview() {
    structBasics()
    customInitializers()
    methods()
    computedProperties()
    propertyObservers()
    staticMembers()
}


func structBasics() {
    //Struct - value type, copies on assignment
    struct Point {
        var x: Double
        var y: Double
    }

    var p1 = Point(x: 3.0, y: 4.0)
    var p2 = p1 //p2 is a full independent copy
    p2.x = 99.0
    print(p1.x) //3.0 - p1 unchanged, value type behavior

    //Structs are the preferred default type in Swift
    //Use struct unless you specifically need reference semantics
    
    //Member initializer
    struct Person {
        var name: String
        var age: Int
    }

    //Swift auto-generates a memberwise initializer for structs - no need to write init()
    let person = Person(name: "Francisco", age: 23)

    //Memberwise initializer is lost if you define any custom init inside the struct
    //Define custom inits in an extension to keep both
}


func customInitializers() {
    struct Temperature {
        var celsius: Double

        //Custom initializer
        init(fahrenheit: Double) {
            celsius = (fahrenheit - 32) * 5 / 9
        }

        init(celsius: Double) {
            self.celsius = celsius //self disambiguates when parameter name matches property
        }
    }

    let boiling = Temperature(fahrenheit: 212)
    print(boiling.celsius) //100.0

    //Defining custom init in an extension preserves the auto-generated memberwise init
    struct Point {
        var x: Double
        var y: Double
    }

    extension Point {
        init(sameValue value: Double) {
            self.x = value
            self.y = value
        }
    }

    let p1 = Point(x: 1.0, y: 2.0) //Memberwise still available
    let p2 = Point(sameValue: 5.0) //Custom also available
}


func methods() {
    struct Circle {
        var radius: Double

        func area() -> Double {
            return Double.pi * radius * radius //Can read properties freely
        }

        func describe() {
            print("Circle with radius \(radius)")
        }
    }

    let c = Circle(radius: 5.0)
    c.area() //78.53...

    //Mutating methods
    struct Counter {
        var count = 0

        //Must mark as mutating to modify any property inside a struct method
        //Structs are value types - Swift needs to know upfront which methods modify state
        mutating func increment() {
            count += 1
        }

        mutating func reset() {
            count = 0
        }
    }

    var counter = Counter()
    counter.increment()
    counter.increment()
    print(counter.count) //2

    //Cannot call mutating methods on a let constant
    let fixed = Counter()
    //fixed.increment() //Compile error - fixed is immutable
}


func computedProperties() {
    struct Rectangle {
        var width: Double
        var height: Double

        //Computed property - calculated on access, not stored
        var area: Double {
            return width * height
        }

        //Computed property with explicit getter and setter
        var perimeter: Double {
            get {
                return 2 * (width + height)
            }
            set {
                //newValue is the implicit name for the incoming value
                width = newValue / 4
                height = newValue / 4
            }
        }

        //Read-only computed property shorthand - omit get { } when no setter
        var isSquare: Bool { width == height }
    }

    var rect = Rectangle(width: 4.0, height: 3.0)
    print(rect.area) //12.0
    print(rect.isSquare) //false
    rect.perimeter = 40 //Triggers setter
}


func propertyObservers() {
    struct StepTracker {
        //willSet - called just before value changes, newValue holds incoming value
        //didSet - called just after value changes, oldValue holds previous value
        var steps: Int = 0 {
            willSet {
                print("About to change steps to \(newValue)")
            }
            didSet {
                print("Steps changed from \(oldValue) to \(steps)")
            }
        }
    }
}


func staticMembers() {
    struct MathHelper {
        //static - belongs to the type itself, not any instance
        static let pi = 3.14159265
        static var instanceCount = 0

        static func circleArea(radius: Double) -> Double {
            return pi * radius * radius
        }
    }

    MathHelper.circleArea(radius: 5.0) //Called on type, not instance
    print(MathHelper.pi)
}