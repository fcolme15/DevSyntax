func errorHandlingOverview() {
    builtInErrors()
    definingCustomErrors()
    throwingAndCatching()
    propagatingErrors()
    resultType()
    deferStatement()
}


func builtInErrors() {
    //URLError. - network failures
    //  .timedOut, .badURL, .cannotFindHost, .notConnectedToInternet,
    //  .networkConnectionLost, .cancelled

    //DecodingError. - JSON/data decoding failures, very common with APIs
    //  .keyNotFound   - expected key missing from JSON
    //  .typeMismatch  - value in JSON is wrong type
    //  .valueNotFound - non-optional value was null in JSON
    //  .dataCorrupted - data is not valid format
    do {
        let data = Data("invalid json".utf8)
        let _ = try JSONDecoder().decode(String.self, from: data)
    } catch DecodingError.dataCorrupted(let context) {
        print("Corrupted: \(context.debugDescription)")
    } catch DecodingError.keyNotFound(let key, _) {
        print("Missing key: \(key)")
    } catch DecodingError.typeMismatch(let type, _) {
        print("Type mismatch: \(type)")
    } catch { }

    //EncodingError - encoding to JSON/data failures
    //  .invalidValue - value cannot be encoded (e.g. NaN, infinity in JSON)

    //CocoaError - file system and Foundation errors
    //  .fileNoSuchFile, .fileReadNoPermission, .fileWriteOutOfSpace etc.

    //CancellationError - thrown when a Task is cancelled
    //  Checked via try Task.checkCancellation() inside async tasks

    //Swift does not throw for out-of-bounds array access - it crashes
    //Use optional subscript (safe:) pattern from DataStructures/Arrays.swift instead
}


func definingCustomErrors() {
    //Errors conform to the Error protocol - typically implemented as enums
    enum NetworkError: Error {
        case notFound
        case unauthorized
        case serverError(code: Int) //Associated values carry extra context
        case invalidURL(String)
    }

    enum ValidationError: Error, LocalizedError {
        case emptyField(name: String)
        case tooShort(minimum: Int)

        //LocalizedError provides human-readable descriptions
        var errorDescription: String? {
            switch self {
            case .emptyField(let name): return "\(name) cannot be empty"
            case .tooShort(let min): return "Must be at least \(min) characters"
            }
        }
    }
}


func throwingAndCatching() {
    enum ParseError: Error {
        case invalidFormat
        case outOfRange(value: Int)
    }

    //throws in signature means function may throw an error
    func parseAge(_ string: String) throws -> Int {
        guard let age = Int(string) else {
            throw ParseError.invalidFormat //throw exits the function immediately
        }
        guard age >= 0 && age <= 150 else {
            throw ParseError.outOfRange(value: age)
        }
        return age
    }

    //do-try-catch - must use try before any throwing call
    do {
        let age = try parseAge("25") //try marks the throwing call
        print("Age: \(age)")

        let bad = try parseAge("abc") //Throws, jumps to catch
        print("Never reached")
    } catch ParseError.invalidFormat {
        print("Not a valid number")
    } catch ParseError.outOfRange(let value) {
        print("\(value) is out of range")
    } catch {
        //Generic catch - error is implicitly available as 'error'
        print("Unexpected error: \(error)")
    }

    //try? - converts throw to nil, returns optional
    let age = try? parseAge("25") //Int? - 25
    let failed = try? parseAge("abc") //nil - error silently discarded

    //try! - force try, crashes if throws - use only when certain it won't throw
    let certain = try! parseAge("30") //Int - crashes at runtime if throws
}


func propagatingErrors() {
    enum FileError: Error { case notFound, unreadable }

    func readFile(_ name: String) throws -> String {
        throw FileError.notFound //Simplified
    }

    //A throwing function can propagate errors from functions it calls
    //Mark caller as throws and use try - error bubbles up to the caller's caller
    func processFile(_ name: String) throws -> String {
        let contents = try readFile(name) //Propagates if readFile throws
        return contents.uppercased()
    }

    //rethrows - only throws if a closure argument throws
    //Used in standard library functions like map, filter etc.
    func transform(_ values: [Int], using block: (Int) throws -> Int) rethrows -> [Int] {
        return try values.map(block)
    }

    //Can call with non-throwing closure - rethrows means it won't throw in that case
    let doubled = try? transform([1, 2, 3]) { $0 * 2 }
}


func resultType() {
    //Result<Success, Failure> - represents either a value or an error
    //Apple defined enum type
    //Useful for async callbacks and storing success/failure without try-catch
    enum NetworkError: Error { case notFound, timeout }

    func fetchUser(id: Int) -> Result<String, NetworkError> {
        if id > 0 {
            return .success("Francisco")
        } else {
            return .failure(.notFound)
        }
    }

    //Handling Result
    let result = fetchUser(id: 1)

    switch result {
    case .success(let user):
        print("Got user: \(user)")
    case .failure(let error):
        print("Error: \(error)")
    }

    //Convenience methods
    let user = try? result.get() //Converts Result to throwing, returns optional
    let mapped = result.map { $0.uppercased() } //Transform success value
    let value = result.mapError { _ in NetworkError.timeout } //Transform error

    //Result vs throws:
    //throws - synchronous, immediate, propagates automatically
    //Result - can be stored, passed around, returned from async callbacks
}


func deferStatement() {
    //defer runs its block when the current scope exits, regardless of how
    //Useful for cleanup that must always happen - closing files, releasing locks
    func processData() throws {
        print("Starting")

        defer {
            print("Cleanup always runs") //Runs on return, throw, or normal exit
        }

        defer {
            print("Second defer") //Multiple defers run in reverse order (LIFO)
        }

        print("Processing")
        //Both defers run here before function exits
        //Output order: "Processing", "Second defer", "Cleanup always runs"
    }
}