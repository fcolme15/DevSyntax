func typeCastingOverview() {
    typeChecking()
    upcasting()
    downcasting()
    castingWithAny()
}
/*Summary:
//is for checking, as for safe upcasts, 
//as? for conditional downcasts that might fail, 
//as! for forced downcasts you're certain about. 
//as? returns an optional, as! force unwraps it.
//Lastly covering usings a switch case to find type of ANY */

func typeChecking() {
    class Animal { }
    class Dog: Animal { }
    class Cat: Animal { }

    let animals: [Animal] = [Dog(), Cat(), Dog()]

    //is - checks if an instance is of a certain type, returns Bool
    let firstIsDog = animals[0] is Dog //true
    let firstIsCat = animals[0] is Cat //false
}


func upcasting() {
    class Animal { var name = "Animal" }
    class Dog: Animal { var breed = "Labrador" }

    //Upcasting - treating a subclass as its parent type
    //Always safe, never fails - use as (not as? or as!)
    let dog = Dog()
    let animal: Animal = dog as Animal //Explicit upcast, usually unnecessary
    let implicitUpcast: Animal = Dog() //Implicit - no cast needed, always works
}


func downcasting() {
    class Animal { }
    class Dog: Animal { func bark() { print("Woof!") } }
    class Cat: Animal { func meow() { print("Meow!") } }

    let animals: [Animal] = [Dog(), Cat(), Dog()]

    //as? - conditional downcast, returns optional - preferred for safety
    for animal in animals {
        if let dog = animal as? Dog {
            dog.bark() //Only runs for Dog instances
        } else if let cat = animal as? Cat {
            cat.meow()
        }
    }

    //as! - forced downcast, crashes at runtime if wrong type
    //Only use when certain of the type
    let firstDog = animals[0] as! Dog //OK - first element is a Dog
    //let forcedCat = animals[0] as! Cat //Runtime crash - first element is not a Cat
}


func castingWithAny() {
    //Any - can hold any type including value types and functions
    //AnyObject - can hold any class instance only
    var things: [Any] = [1, "hello", 3.14, true, Dog()]

    class Dog { func bark() { print("Woof!") } }

    //Must use switch with pattern matching to work with Any values
    //let int declares a new constant called int. as Int attempts the downcast. 
    //"if thing can be cast to Int, bind that casted value to int and enter this block."
    for thing in things {
        switch thing {
        case let int as Int:
            print("Int: \(int)")
        case let str as String:
            print("String: \(str)")
        case let double as Double:
            print("Double: \(double)")
        case let bool as Bool:
            print("Bool: \(bool)")
        case let dog as Dog:
            dog.bark()
        default:
            print("Unknown type")
        }
    }

    //Any is a last resort - prefer generics or protocols for type-safe flexibility
    //Covered in Declarations/Generics.swift and Declarations/Protocols.swift
}