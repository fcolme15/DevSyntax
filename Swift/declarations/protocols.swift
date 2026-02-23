func protocolsOverview() {
    protocolBasics()
    protocolInheritance()
    protocolExtensions()
    protocolAsType()
}


func protocolBasics() {
    //Protocol defines a blueprint of methods and properties a type must implement
    //Similar to interfaces in other languages but more powerful
    protocol Greetable {
        var name: String { get } //get means readable, get set means readable and writable
        func greet() -> String
    }

    //Structs, classes, and enums can all conform to protocols
    struct Person: Greetable {
        var name: String //Satisfies the property requirement

        func greet() -> String { //Satisfies the method requirement
            return "Hello, I'm \(name)"
        }
    }

    class Robot: Greetable {
        var name: String
        init(name: String) { self.name = name }

        func greet() -> String { "Beep boop, I am \(name)" }
    }

    //Multiple protocols with comma separation
    protocol Farewell {
        func bye() -> String
    }

    struct FriendlyPerson: Greetable, Farewell {
        var name: String
        func greet() -> String { "Hi, I'm \(name)" }
        func bye() -> String { "Goodbye from \(name)" }
    }
    
    //Protocol properties
    protocol Vehicle {
        //{ get } - conforming type must provide a readable property (can be let or var)
        var brand: String { get }

        //{ get set } - conforming type must provide a readable and writable property (must be var)
        var speed: Double { get set }

        //Static property requirement
        static var vehicleType: String { get }
    }
}


func protocolInheritance() {
    protocol Shape {
        var area: Double { get }
    }

    //Protocol can inherit from one or more protocols
    protocol ColoredShape: Shape {
        var color: String { get }
    }

    //Conforming type must satisfy all requirements from entire chain
    struct ColoredCircle: ColoredShape {
        var radius: Double
        var color: String
        var area: Double { Double.pi * radius * radius } //From Shape
    }

    //Protocol composition - require multiple protocols inline without creating a new one
    protocol Named { var name: String { get } }
    protocol Aged { var age: Int { get } }

    func describe(_ subject: Named & Aged) { //Must conform to both
        print("\(subject.name) is \(subject.age)")
    }
}


func protocolExtensions() {
    //Protocol extensions provide default implementations
    //Conforming types get the default for free but can override it
    protocol Greetable {
        var name: String { get }
        func greet() -> String
    }

    extension Greetable {
        //Default implementation - conforming types don't need to implement this
        func greet() -> String {
            return "Hello, I'm \(name)"
        }

        //Can also add entirely new methods not in the protocol
        func shout() -> String {
            return greet().uppercased()
        }
    }

    struct Person: Greetable {
        var name: String
        //greet() not implemented - uses default from extension
    }

    struct Robot: Greetable {
        var name: String
        func greet() -> String { "Beep boop, I am \(name)" } //Overrides default
    }
}


func protocolAsType() {
    protocol Shape {
        var area: Double { get }
    }

    struct Circle: Shape {
        var radius: Double
        var area: Double { Double.pi * radius * radius }
    }

    struct Rectangle: Shape {
        var width, height: Double
        var area: Double { width * height }
    }

    //Protocol as a type - store different conforming types in same collection
    let shapes: [any Shape] = [Circle(radius: 5), Rectangle(width: 4, height: 3)]
    for shape in shapes {
        print(shape.area)
    }

    //some - opaque type, compiler knows the concrete type but caller doesn't
    //Used heavily in SwiftUI for view return types
    func makeShape() -> some Shape {
        return Circle(radius: 3) //Caller gets a Shape, doesn't know it's a Circle
    }

    //any vs some:
    //any Shape - dynamic, can hold different types at runtime, slight performance cost
    //some Shape - static, one specific type chosen at compile time, more efficient
}