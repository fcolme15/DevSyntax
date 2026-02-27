func tuplesOverview() {
    tupleBasics()
}


func tupleBasics() {
    //Tuple groups multiple values into a single compound value
    //Values can be different types - not a collection, more like a lightweight struct
    let point = (3.0, 4.0) //Type is (Double, Double)
    let person = ("Francisco", 23, true) //Type is (String, Int, Bool)

    //Access by index position
    print(point.0) //3.0
    print(person.1) //23

    //Tuples are value types - copies on assignment
    var p1 = (1, 2)
    var p2 = p1
    p2.0 = 99
    print(p1.0) //1 - unchanged

    //Naming tuples 
    let point = (x: 3.0, y: 4.0)
    let person = (name: "Francisco", age: 23)

    //Access by name or index - both work
    print(point.x) //3.0
    print(point.0) //3.0 - same thing
    
    //Tuple decomposition
    //Decompose into separate constants
    let (x, y) = point
    print(x) //3.0

    //Ignore values with _
    let (name, _) = person
    print(name) //"Francisco"
    
    //Optional tuple - the whole tuple is optional, not individual elements
    func divide(_ a: Int, _ b: Int) -> (quotient: Int, remainder: Int)? {
        guard b != 0 else { return nil }
        return (a / b, a % b)
    }

}