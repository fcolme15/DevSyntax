func subscriptsOverview() {
    subscriptBasics()
    typeSubscripts()
}

//Adding get and set for index access only

func subscriptBasics() {
    //Subscripts let you access elements of a type using [] bracket syntax
    //Same syntax as array[0] or dict["key"] but defined on your own types
    struct Matrix {
        private var grid: [[Double]]
        let rows: Int
        let columns: Int

        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(repeating: Array(repeating: 0.0, count: columns), count: rows)
        }

        //subscript keyword, parameters in [], return type after ->
        subscript(row: Int, column: Int) -> Double {
            get {
                return grid[row][column]
            }
            set {
                grid[row][column] = newValue //newValue is implicit like in computed property setters
            }
        }
    }

    var matrix = Matrix(rows: 3, columns: 3)
    matrix[0, 0] = 1.0 //Calls setter
    matrix[1, 2] = 5.0
    print(matrix[0, 0]) //1.0 - calls getter
    print(matrix[1, 2]) //5.0

    //Read-only subscript - omit get/set, just provide the body directly
    struct NumberList {
        private var numbers = [1, 2, 3, 4, 5]

        subscript(index: Int) -> Int {
            return numbers[index] //Read-only, no setter
        }
    }

    let list = NumberList()
    print(list[2]) //3
    
    //Subscripts can take any number and type of parameters
    struct GradeBook {
        private var grades: [String: [String: Int]] = [:]

        //Two parameters - student name and subject
        subscript(student: String, subject: String) -> Int? {
            get { grades[student]?[subject] }
            set { grades[student, default: [:]][subject] = newValue }
        }
    }

    var book = GradeBook()
    book["Francisco", "Math"] = 95
    book["Francisco", "Science"] = 88
    print(book["Francisco", "Math"] ?? 0) //95

    //Subscripts support default parameter values and external labels
    struct Config {
        private var settings: [String: String] = [:]

        subscript(key: String, default defaultValue: String = "N/A") -> String {
            return settings[key] ?? defaultValue
        }
    }
}


func typeSubscripts() {
    //static subscript - called on the type itself, not an instance
    enum DayOfWeek: Int {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

        static subscript(number: Int) -> DayOfWeek? {
            return DayOfWeek(rawValue: number)
        }
    }

    let day = DayOfWeek[2] //monday - called on the type
    print(day ?? DayOfWeek.sunday) //monday
}