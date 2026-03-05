import XCTest
import SwiftUI
@testable import MyApp //Replace with your module name - gives access to internal types

//============================================================
//COMMON ASSERTIONS
//============================================================
func assertionReference() {
    //XCTAssertEqual(a, b) - a == b
    //XCTAssertNotEqual(a, b) - a != b
    //XCTAssertTrue(condition)
    //XCTAssertFalse(condition)
    //XCTAssertNil(value)
    //XCTAssertNotNil(value)
    //XCTAssertGreaterThan(a, b)
    //XCTAssertLessThan(a, b)
    //XCTAssertThrowsError(try expression) - verifies a throw occurs
    //XCTAssertNoThrow(try expression) - verifies no throw occurs
    //XCTFail("message") - force fail a test
}

//============================================================
//TESTING MENTAL MODEL
//============================================================
//Unit tests verify individual functions and types in isolation
//UI tests simulate user interaction with the running app
//Tests live in a separate target in Xcode - MyAppTests and MyAppUITests
//Run with Cmd+U, individual tests with the diamond button next to the function


//============================================================
//UNIT TESTS WITH XCTEST
//============================================================
class MathHelperTests: XCTestCase {
    //setUp runs before EACH test - reset state here
    override func setUp() {
        super.setUp()
    }

    //tearDown runs after EACH test - cleanup here
    override func tearDown() {
        super.tearDown()
    }

    //Test functions must start with "test" and have no parameters
    func testAddition() {
        let result = 2 + 2
        XCTAssertEqual(result, 4) //Fails test if not equal
    }

    func testDivisionByZero() {
        //XCTAssertNil, XCTAssertNotNil, XCTAssertTrue, XCTAssertFalse
        let result = divide(10, by: 0)
        XCTAssertNil(result, "Division by zero should return nil")
    }

    func testStringParsing() {
        let input = "42"
        let result = Int(input)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 42)
    }

    func divide(_ a: Int, by b: Int) -> Int? {
        guard b != 0 else { return nil }
        return a / b
    }
}


//============================================================
//TESTING A VIEWMODEL
//============================================================
@Observable
class CounterViewModel {
    var count = 0
    var isAtMax: Bool { count >= 10 }

    func increment() { if count < 10 { count += 1 } }
    func decrement() { if count > 0 { count -= 1 } }
    func reset() { count = 0 }
}

class CounterViewModelTests: XCTestCase {
    var viewModel: CounterViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CounterViewModel() //Fresh instance for each test
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.count, 0)
        XCTAssertFalse(viewModel.isAtMax)
    }

    func testIncrement() {
        viewModel.increment()
        XCTAssertEqual(viewModel.count, 1)
    }

    func testMaxBoundary() {
        for _ in 0..<15 { viewModel.increment() } //Try to go past max
        XCTAssertEqual(viewModel.count, 10) //Should cap at 10
        XCTAssertTrue(viewModel.isAtMax)
    }

    func testReset() {
        viewModel.increment()
        viewModel.increment()
        viewModel.reset()
        XCTAssertEqual(viewModel.count, 0)
    }
}


//============================================================
//TESTING ASYNC CODE
//============================================================
class NetworkTests: XCTestCase {
    //async test functions - XCTest supports async/await natively
    func testFetchUser() async throws {
        let result = try await fetchUser(id: 1)
        XCTAssertFalse(result.isEmpty)
    }

    //Testing with expectations - for callback-based code
    func testCallbackBased() {
        let expectation = expectation(description: "Data loaded")

        someCallbackFunction { result in
            XCTAssertNotNil(result)
            expectation.fulfill() //Signal that async work completed
        }

        waitForExpectations(timeout: 5) //Fail if not fulfilled within 5 seconds
    }

    func fetchUser(id: Int) async throws -> String { "Francisco" }
    func someCallbackFunction(completion: (String?) -> Void) { completion("result") }
}


//============================================================
//TESTING WITH MOCKS
//============================================================
//Protocol-based dependency injection enables mocking
protocol UserServiceProtocol {
    func fetchUser(id: Int) async throws -> String
}

class RealUserService: UserServiceProtocol {
    func fetchUser(id: Int) async throws -> String {
        //Real network call
        return "Real Francisco"
    }
}

class MockUserService: UserServiceProtocol {
    var shouldFail = false
    var returnedUser = "Mock Francisco"

    func fetchUser(id: Int) async throws -> String {
        if shouldFail { throw URLError(.notConnectedToInternet) }
        return returnedUser
    }
}

@Observable
class UserViewModel {
    var service: UserServiceProtocol
    var userName = ""
    var errorMessage = ""

    init(service: UserServiceProtocol = RealUserService()) {
        self.service = service
    }

    func loadUser(id: Int) async {
        do {
            userName = try await service.fetchUser(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

class UserViewModelTests: XCTestCase {
    func testSuccessfulLoad() async {
        let mock = MockUserService()
        let viewModel = UserViewModel(service: mock)

        await viewModel.loadUser(id: 1)

        XCTAssertEqual(viewModel.userName, "Mock Francisco")
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }

    func testFailedLoad() async {
        let mock = MockUserService()
        mock.shouldFail = true
        let viewModel = UserViewModel(service: mock)

        await viewModel.loadUser(id: 1)

        XCTAssertTrue(viewModel.userName.isEmpty)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
}