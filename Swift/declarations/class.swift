func classesOverview() {
    classBasics()
    inheritance()
    identityOperators()
    deinitializer()
}


func classBasics() {
    //Class - reference type, shares on assignment
    class Point {
        var x: Double
        var y: Double

        init(x: Double, y: Double) {
            self.x = x
            self.y = y
        }
    }

    var p1 = Point(x: 3.0, y: 4.0)
    var p2 = p1 //p2 points to the same object, not a copy
    p2.x = 99.0
    print(p1.x) //99.0 - p1 changed because p1 and p2 reference the same object

    //Classes do not get a memberwise initializer - must write init() manually

    //Initializers
    class Vehicle {
        var brand: String
        var speed: Double

        //Designated initializer - primary init, must fully initialize all properties
        init(brand: String, speed: Double) {
            self.brand = brand
            self.speed = speed
        }

        //Convenience initializer - secondary, must call a designated init via self.init()
        convenience init(brand: String) {
            self.init(brand: brand, speed: 0.0) //Must delegate to designated
        }
    }

    let car = Vehicle(brand: "Toyota", speed: 120.0)
    let slowCar = Vehicle(brand: "Toyota") //Uses convenience init
}


func inheritance() {
    class Animal {
        var name: String

        init(name: String) {
            self.name = name
        }

        func speak() {
            print("\(name) makes a sound")
        }
    }

    class Dog: Animal {
        var breed: String

        //Subclass designated init must call super.init() after setting own properties
        init(name: String, breed: String) {
            self.breed = breed //Own properties first
            super.init(name: name) //Then super
        }

        //Final makes it so that it can no longer be overriden
        //override is needed to override the parent version of the function
        final override func speak() {
            print("\(name) barks")
        }
    }

    //Prevent subclassing entirely with final class
    final class GoldenRetriever: Dog {
        init(name: String) {
            super.init(name: name, breed: "Golden Retriever")
        }
    }

    let dog = Dog(name: "Rex", breed: "Labrador")
    dog.speak() //"Rex barks"

    //Polymorphism - parent reference holds child object
    let animal: Animal = Dog(name: "Buddy", breed: "Poodle")
    animal.speak() //"Buddy barks" - calls Dog's version
}


func identityOperators() {
    class Car { }

    let car1 = Car()
    let car2 = car1 //Same reference
    let car3 = Car() //Different object

    //=== checks if two variables point to the exact same object
    let sameObject = car1 === car2 //true
    let differentObject = car1 === car3 //false

    //!== opposite of ===
    let notSame = car1 !== car3 //true

    //== checks value equality - must conform to Equatable protocol to use
    //=== checks reference identity - built in for all classes
}


func deinitializer() {
    //deinit - called automatically just before object is deallocated
    //Only available on classes, not structs
    //Cannot be called manually, no parameters
    class FileHandler {
        let filename: String

        init(filename: String) {
            self.filename = filename
            print("Opened \(filename)")
        }

        deinit {
            print("Closed \(filename)") //Clean up resources here
        }
    }

    var handler: FileHandler? = FileHandler(filename: "data.txt")
    handler = nil //deinit called here - "Closed data.txt"
}