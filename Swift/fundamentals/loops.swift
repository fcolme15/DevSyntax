func loopsOverview() {
    rangeOperators()
    forInLoop()
    whileLoop()
    loopingOverCollections()
}


func rangeOperators() {
    //Closed range - includes both endpoints
    let closed = 1...5 //1, 2, 3, 4, 5

    //Half-open range - excludes upper bound, most common for indexing
    let halfOpen = 1..<5 //1, 2, 3, 4

    //One-sided ranges - Swift infers the missing bound
    let arr = [10, 20, 30, 40, 50]
    //Not numbers but indexes from arr above
    let fromIndex2 = arr[2...] //[30, 40, 50]
    let upToIndex2 = arr[..<2] //[10, 20]
    let throughIndex2 = arr[...2] //[10, 20, 30]

    //Ranges also work in switch cases - covered in ControlFlow.swift
}


func forInLoop() {
    //Basic range loop. Inclusive on both ends
    for i in 1...5 {
        print(i) //1, 2, 3, 4, 5
    }

    //Discard loop variable when value not needed
    for _ in 1...3 {
        print("hello") //Prints 3 times
    }

    //Stride - loop with custom step, replaces traditional for(i=0; i<10; i+=2)
    //Swift has no C-style for loop (removed in Swift 3)
    //To -> excludes upper bound
    for i in stride(from: 0, to: 10, by: 2) { //0, 2, 4, 6, 8 - excludes upper bound
        print(i)
    }

    //through -> Includes upper bound
    for i in stride(from: 0, through: 10, by: 2) { //0, 2, 4, 6, 8, 10 - includes upper bound
        print(i)
    }

    //Reverse iteration
    for i in (1...5).reversed() { //5, 4, 3, 2, 1
        print(i)
    }
}


func whileLoop() {
    var count = 0
    while count < 5 {
        print(count)
        count += 1
    }
    
    //Repeat while == do while loop
    //Condition checked after each iteration - body always runs at least once
    //Equivalent to do-while in Java/C
    var count = 0
    repeat {
        print(count)
        count += 1
    } while count < 5
}


func loopingOverCollections() {
    let fruits = ["apple", "banana", "cherry"]
    let scores = ["Alice": 95, "Bob": 87, "Carol": 92]

    //Loop over array
    for fruit in fruits {
        print(fruit)
    }

    //Loop with index using enumerated()
    for (index, fruit) in fruits.enumerated() {
        print("\(index): \(fruit)") //0: apple, 1: banana, 2: cherry
    }

    //Loop over dictionary - order not guaranteed
    for (name, score) in scores {
        print("\(name): \(score)")
    }

    //Loop over string characters
    for char in "Swift" {
        print(char) //S, w, i, f, t
    }

    //where clause - filter during iteration
    for i in 1...20 where i % 3 == 0 {
        print(i) //3, 6, 9, 12, 15, 18
    }
}