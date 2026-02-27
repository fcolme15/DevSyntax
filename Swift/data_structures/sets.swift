func setsOverview() {
    setCreation()
    accessingAndModifying()
    setOperations()
    setComparisons()
}


func setCreation() {
    //Must use explicit annotation - [1, 2, 3] alone infers as Array
    var numbers: Set<Int> = [1, 2, 3, 4, 5]
    var words: Set<String> = ["apple", "banana", "cherry"]

    var empty = Set<Int>()

    //Duplicates are silently ignored - sets only store unique values
    var withDups: Set<Int> = [1, 1, 2, 2, 3] //Stored as {1, 2, 3}

    //From array - useful for deduplication
    let array = [1, 2, 2, 3, 3, 3, 4]
    let unique = Set(array) //{1, 2, 3, 4}
    let backToArray = Array(unique) //Order not guaranteed

    //Element type must conform to Hashable - Int, String, Bool, Double all do by default
}


func accessingAndModifying() {
    var fruits: Set<String> = ["apple", "banana", "cherry"]

    //Checking size, emptyness, and if element exists
    let count = fruits.count //3
    let isEmpty = fruits.isEmpty //false
    let contains = fruits.contains("apple") //true

    //No index-based access - sets are unordered
    let first = fruits.first //Some element, not guaranteed to be any specific one

    //Adding and removing
    fruits.insert("date") //Returns (inserted: Bool, memberAfterInsert: String)
    fruits.remove("banana") //Returns removed element as optional, nil if not found
    fruits.removeAll()
}


func setOperations() {
    let a: Set<Int> = [1, 2, 3, 4, 5]
    let b: Set<Int> = [3, 4, 5, 6, 7]

    //Union - all elements from both sets
    let union = a.union(b) //{1, 2, 3, 4, 5, 6, 7}

    //Intersection - only elements in both sets
    let intersection = a.intersection(b) //{3, 4, 5}

    //Subtracting - elements in a but not in b
    let difference = a.subtracting(b) //{1, 2}

    //Symmetric difference - elements in either but not both
    let symmetric = a.symmetricDifference(b) //{1, 2, 6, 7}

    //In-place versions
    var mutable: Set<Int> = [1, 2, 3]
    mutable.formUnion([3, 4, 5]) //{1, 2, 3, 4, 5}
    mutable.formIntersection([3, 4]) //{3, 4}
    mutable.subtract([3]) //{4}
}


func setComparisons() {
    let a: Set<Int> = [1, 2, 3]
    let b: Set<Int> = [1, 2, 3, 4, 5]
    let c: Set<Int> = [1, 2, 3]
    let d: Set<Int> = [6, 7, 8]

    //Equality - same elements regardless of order
    let equal = a == c //true

    //Subset - all elements of a exist in b
    let isSubset = a.isSubset(of: b) //true
    let isStrictSubset = a.isStrictSubset(of: b) //true - strict means not equal

    //Superset - b contains all elements of a
    let isSuperset = b.isSuperset(of: a) //true

    //Disjoint - no elements in common
    let disjoint = a.isDisjoint(with: d) //true
}