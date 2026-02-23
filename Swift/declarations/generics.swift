func genericsOverview() {
    genericFunctions()
    genericTypes()
    typeConstraints()
    associatedTypes()
    whereClause()
}


func genericFunctions() {
    //Generic function - works with any type, T is a placeholder resolved at call time
    func swap<T>(_ a: inout T, _ b: inout T) {
        let temp = a
        a = b
        b = temp
    }

    var x = 5, y = 10
    swap(&x, &y) //T resolved as Int
    print(x, y) //10, 5

    var s1 = "hello", s2 = "world"
    swap(&s1, &s2) //T resolved as String

    //Multiple type parameters
    func pair<T, U>(_ first: T, _ second: U) -> (T, U) {
        return (first, second)
    }

    let result = pair("age", 23) //(String, Int)
}


func genericTypes() {
    //Generic struct - type parameter applies to the whole type
    //Generic class works the same way
    struct Stack<Element> {
        private var items: [Element] = []

        mutating func push(_ item: Element) {
            items.append(item)
        }

        mutating func pop() -> Element? {
            return items.isEmpty ? nil : items.removeLast()
        }

        var top: Element? { items.last }
        var isEmpty: Bool { items.isEmpty }
    }

    var intStack = Stack<Int>()
    intStack.push(1)
    intStack.push(2)
    intStack.pop() //2

    var stringStack = Stack<String>()
    stringStack.push("hello")   
}


func typeConstraints() {
    //Constrain T to types that conform to a protocol
    //T: Comparable means T must implement Comparable (has < > == etc.)
    func findMax<T: Comparable>(_ array: [T]) -> T? {
        guard !array.isEmpty else { return nil }
        return array.max()
    }

    findMax([3, 1, 4, 1, 5]) //5
    findMax(["banana", "apple", "cherry"]) //"cherry"
    //findMax([SomeType()]) //Compile error if SomeType doesn't conform to Comparable

    //Multiple constraints with &
    func process<T: Comparable & Hashable>(_ value: T) { }
}


func associatedTypes() {
    //Associated types let protocols define placeholder types
    //Similar to generics but for protocols
    protocol Container {
        associatedtype Item //Placeholder, resolved when protocol is adopted
        mutating func add(_ item: Item)
        func get(_ index: Int) -> Item?
        var count: Int { get }
    }

    struct NumberBox: Container {
        private var items: [Int] = []
        typealias Item = Int //Explicit, usually inferred

        mutating func add(_ item: Int) { items.append(item) }
        func get(_ index: Int) -> Int? {
            guard index < items.count else { return nil }
            return items[index]
        }
        var count: Int { items.count }
    }

    struct StringBox: Container {
        private var items: [String] = []
        //Item inferred as String from method signatures
        mutating func add(_ item: String) { items.append(item) }
        func get(_ index: Int) -> String? {
            guard index < items.count else { return nil }
            return items[index]
        }
        var count: Int { items.count }
    }
}


func whereClause() {
    //where adds additional constraints beyond the type parameter
    //Two containers must hold the same Element type and that type must be Equatable
    func allMatch<C1: Collection, C2: Collection>(_ c1: C1, _ c2: C2) -> Bool
        where C1.Element == C2.Element, C1.Element: Equatable {
        guard c1.count == c2.count else { return false }
        return zip(c1, c2).allSatisfy { $0 == $1 }
    }

    allMatch([1, 2, 3], [1, 2, 3]) //true
    allMatch([1, 2, 3], [1, 2, 4]) //false

    //where on extensions - extend only specific specializations
    struct Stack<Element> {
        var items: [Element] = []
    }

    //This extension only applies when Element is Equatable
    extension Stack where Element: Equatable {
        func contains(_ item: Element) -> Bool {
            return items.contains(item)
        }
    }

    var intStack = Stack(items: [1, 2, 3])
    intStack.contains(2) //true - Int is Equatable so extension applies
}