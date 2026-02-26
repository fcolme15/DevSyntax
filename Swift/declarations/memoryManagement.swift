func memoryManagementOverview() {
    arcBasics()
    strongReferences()
    weakReferences()
    unownedReferences()
}


func arcBasics() {
    //ARC (Automatic Reference Counting) manages memory for class instances automatically
    //Every class instance has a reference count - number of things pointing to it
    //When reference count hits 0, ARC deallocates the instance and calls deinit
    //Structs and enums are value types - ARC does not apply to them

    class Person {
        let name: String
        init(name: String) {
            self.name = name
            print("\(name) initialized")
        }
        deinit { print("\(name) deallocated") }
    }

    var ref1: Person? = Person(name: "Francisco") //Reference count: 1
    var ref2 = ref1 //Reference count: 2
    var ref3 = ref1 //Reference count: 3

    ref1 = nil //Reference count: 2
    ref2 = nil //Reference count: 1
    ref3 = nil //Reference count: 0 -> deinit called -> "Francisco deallocated"
}


func strongReferences() {
    //Strong reference is the default - increases reference count
    //Retain cycle - two instances hold strong references to each other
    //Neither can reach count 0, neither is ever deallocated - memory leak

    class Apartment {
        var tenant: Person? //Strong reference to Person
    }

    class Person {
        var apartment: Apartment? //Strong reference to Apartment
        let name: String
        init(name: String) { self.name = name }
        deinit { print("\(name) deallocated") }
    }

    var person: Person? = Person(name: "Francisco") //Person count: 1
    var apt: Apartment? = Apartment() //Apartment count: 1

    person?.apartment = apt //Apartment count: 2 (apt variable + person.apartment)
    apt?.tenant = person //Person count: 2 (person variable + apt.tenant)

    person = nil //Person count: 1 - NOT deallocated, apt.tenant still holds it
    apt = nil //Apartment count: 1 - NOT deallocated, person.apartment still holds it
    //Both leak - neither deinit is called
}


func weakReferences() {
    //weak reference does not increase reference count
    //Automatically set to nil when the instance is deallocated
    //Must be var and optional - because it can become nil at any time

    class Apartment {
        weak var tenant: Person? //Weak - does not increase Person's count
    }

    class Person {
        var apartment: Apartment? //Strong
        let name: String
        init(name: String) { self.name = name }
        deinit { print("\(name) deallocated") }
    }

    var person: Person? = Person(name: "Francisco") //Person count: 1
    var apt: Apartment? = Apartment() //Apartment count: 1

    person?.apartment = apt //Apartment count: 2
    apt?.tenant = person //Person count still 1 - weak doesn't increment

    person = nil //Person count: 0 -> deallocated -> apt.tenant automatically becomes nil
    apt = nil //Apartment count: 0 -> deallocated
    //No leak - cycle broken by weak
}


func unownedReferences() {
    //unowned - like weak but assumed to always have a value when accessed
    //Does not increase reference count
    //Does NOT become nil automatically - crashes if accessed after deallocation
    //Use when the referenced instance will always outlive the referencing one

    class Customer {
        let name: String
        var card: CreditCard?
        init(name: String) { self.name = name }
        deinit { print("\(name) deallocated") }
    }

    class CreditCard {
        let number: Int
        unowned let owner: Customer //Card cannot exist without a customer, owner always valid
        init(number: Int, owner: Customer) {
            self.number = number
            self.owner = owner
        }
        deinit { print("Card \(number) deallocated") }
    }

    var customer: Customer? = Customer(name: "Francisco")
    customer?.card = CreditCard(number: 1234, owner: customer!)

    customer = nil //Customer count: 0 -> deallocated -> card deallocated too
    //Safe because card is gone before we could access its unowned owner

    //weak vs unowned:
    //weak   - referenced instance might become nil during your lifetime, must be optional var
    //unowned - referenced instance will always outlive you, can be let, non-optional
}