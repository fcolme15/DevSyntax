func dictionariesOverview() {
    dictionaryCreation()
    accessingValues()
    modifyingDictionaries()
    iterating()
    dictionaryOperations()
}


func dictionaryCreation() {
    //Type inferred from contents
    var scores = ["Alice": 95, "Bob": 87, "Carol": 92]

    //Explicit type annotation
    var explicit: [String: Int] = ["a": 1, "b": 2]
    var empty: [String: Int] = [:]
    var emptyAlt = [String: Int]()

    //From arrays using zip - pair keys and values together
    let keys = ["a", "b", "c"]
    let values = [1, 2, 3]
    let fromZip = Dictionary(uniqueKeysWithValues: zip(keys, values)) //["a": 1, "b": 2, "c": 3]

    //Grouping array elements by a key
    let words = ["apple", "ant", "banana", "bat", "cherry"]
    let grouped = Dictionary(grouping: words) { $0.first! }
    //["a": ["apple", "ant"], "b": ["banana", "bat"], "c": ["cherry"]]
}


func accessingValues() {
    let scores = ["Alice": 95, "Bob": 87, "Carol": 92]

    //Subscript access - always returns optional since key may not exist
    let alice = scores["Alice"] //95 as Int?
    let missing = scores["Dave"] //nil

    //Default value - returns non-optional
    let dave = scores["Dave", default: 0] //0

    //Safely unwrap
    if let score = scores["Alice"] {
        print("Alice: \(score)")
    }

    //Get size and check emptyness
    let count = scores.count //3
    let isEmpty = scores.isEmpty //false

    //All keys and values as collections
    let keys = scores.keys //["Alice", "Bob", "Carol"] - order not guaranteed
    let vals = scores.values
    let keysArray = Array(scores.keys) //Convert to Array if needed
}


func modifyingDictionaries() {
    var scores = ["Alice": 95, "Bob": 87]

    //Add or update - same syntax
    scores["Carol"] = 92 //Add new key
    scores["Alice"] = 99 //Update existing key

    //updateValue - returns old value as optional (nil if key was new)
    let old = scores.updateValue(100, forKey: "Bob") //87 as Int?

    //Remove
    scores["Bob"] = nil //Remove by setting to nil
    let removed = scores.removeValue(forKey: "Carol") //92 as Int? - returns removed value

    //Merge another dictionary
    var extra = ["Dave": 88, "Eve": 91]
    scores.merge(extra) { current, _ in current } //Keep current on conflict
    let merged = scores.merging(extra) { _, new in new } //Returns new dict, keep new on conflict

    //Default value for modifying in place
    var wordCount = [String: Int]()
    let words = ["apple", "banana", "apple", "cherry", "banana", "apple"]
    for word in words {
        wordCount[word, default: 0] += 1 //Increment count, starting at 0 if not present
    }
    //["apple": 3, "banana": 2, "cherry": 1]
}


func iterating() {
    let scores = ["Alice": 95, "Bob": 87, "Carol": 92]

    //Order is not guaranteed in dictionaries
    for (name, score) in scores {
        print("\(name): \(score)")
    }

    //Iterate only keys or values
    for name in scores.keys { print(name) }
    for score in scores.values { print(score) }

    //forEach
    scores.forEach { name, score in print("\(name): \(score)") }

    //Map over values - returns array not dictionary
    let doubled = scores.mapValues { $0 * 2 } //["Alice": 190, "Bob": 174, "Carol": 184]

    //Filter - returns dictionary
    let highScores = scores.filter { $0.value >= 90 } //["Alice": 95, "Carol": 92]
}


func dictionaryOperations() {
    let scores = ["Alice": 95, "Bob": 87, "Carol": 92]

    //Check key existence
    let hasAlice = scores.keys.contains("Alice") //true

    //Convert to sorted array of tuples for deterministic ordering
    let sorted = scores.sorted { $0.value > $1.value }
    //[(key: "Alice", value: 95), (key: "Carol", value: 92), (key: "Bob", value: 87)]
}