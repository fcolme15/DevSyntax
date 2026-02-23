func extensionsOverview() {
    extendingTypes()
    extendingWithProtocols()
    extendingStandardLibrary()
    extensionConstraints()
}


func extendingTypes() {
    //Extensions add functionality to existing types without subclassing or modifying source
    //Works on structs, classes, enums, and protocols
    struct Circle {
        var radius: Double
    }

    extension Circle {
        //Computed properties - stored properties not allowed in extensions
        var area: Double { Double.pi * radius * radius }
        var circumference: Double { 2 * Double.pi * radius }

        //Methods
        func scaled(by factor: Double) -> Circle {
            return Circle(radius: radius * factor)
        }

        //Mutating method
        mutating func scale(by factor: Double) {
            radius *= factor
        }

        //Initializer - adding to struct via extension preserves memberwise init
        init(diameter: Double) {
            self.radius = diameter / 2
        }
    }

    var c = Circle(radius: 5) //Memberwise still works
    let c2 = Circle(diameter: 10) //New init from extension
    print(c.area) //78.53...
    c.scale(by: 2)
    print(c.radius) //10.0
}


func extendingWithProtocols() {
    //Extensions are the primary way to add protocol conformance to existing types
    protocol Describable {
        func describe() -> String
    }

    struct Point {
        var x: Double
        var y: Double
    }

    //Retroactive conformance - add protocol to a type you don't own
    extension Point: Describable {
        func describe() -> String { "Point(\(x), \(y))" }
    }

    //Add conformance to types from other libraries or Swift standard library
    extension Int: Describable {
        func describe() -> String { "The number \(self)" }
    }

    print(42.describe()) //"The number 42"
    print(Point(x: 3, y: 4).describe()) //"Point(3.0, 4.0)"
}


func extendingStandardLibrary() {
    //Common pattern - extend standard types with domain-specific helpers
    extension String {
        var isPalindrome: Bool {
            let cleaned = lowercased().filter { $0.isLetter }
            return cleaned == String(cleaned.reversed())
        }

        func repeated(_ times: Int) -> String {
            return String(repeating: self, count: times)
        }
    }

    print("racecar".isPalindrome) //true
    print("hello".isPalindrome) //false
    print("ha".repeated(3)) //"hahaha"

    extension Int {
        var isEven: Bool { self % 2 == 0 }
        var squared: Int { self * self }

        //Repeat a closure n times
        func times(_ action: () -> Void) {
            for _ in 0..<self { action() }
        }
    }

    3.times { print("hello") } //Prints 3 times
    print(5.squared) //25
    print(4.isEven) //true

    extension Array {
        //safe subscript - returns optional instead of crashing on out of bounds
        subscript(safe index: Int) -> Element? {
            guard index >= 0 && index < count else { return nil }
            return self[index]
        }
    }

    let arr = [1, 2, 3]
    print(arr[safe: 5]) //nil instead of crash
}


func extensionConstraints() {
    //Extend only specific specializations of a generic type using where
    extension Array where Element: Numeric {
        var sum: Element { reduce(0, +) }
        var average: Double {
            guard !isEmpty else { return 0 }
            return Double(reduce(0, +) as! Double) / Double(count)
        }
    }

    extension Array where Element: Comparable {
        var isSorted: Bool {
            guard count > 1 else { return true }
            return zip(self, dropFirst()).allSatisfy { $0 <= $1 }
        }
    }

    [1, 2, 3, 4, 5].sum //15 - only available on numeric arrays
    [1, 2, 3].isSorted //true - only available on comparable arrays
    ["a", "c", "b"].isSorted //false
}