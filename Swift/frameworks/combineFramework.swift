import Combine
import Foundation

//Combine is Apple's reactive framework - processing values over time
//Three core concepts: Publishers, Subscribers, Operators
//In modern SwiftUI, async/await handles most cases Combine used to own
//Combine still relevant for complex event streams, timers, and older codebases

var cancellables = Set<AnyCancellable>() //Store subscriptions to keep them alive


func combineOverview() {
    publishers()
    subscribers()
    operators()
    commonPatterns()
}


func publishers() {
    //Publisher - emits a sequence of values over time, then completes or fails
    //Type: Publisher<Output, Failure>

    //Just - emits a single value then completes
    let just = Just(42) //Publisher<Int, Never> - Never means cannot fail

    //Array publisher
    let arrayPub = [1, 2, 3, 4, 5].publisher //Emits each element then completes

    //Future - wraps a single async operation
    let future = Future<String, Error> { promise in
        //Async work here
        promise(.success("Done")) //Or promise(.failure(someError))
    }

    //PassthroughSubject - manually send values, like an event emitter
    let subject = PassthroughSubject<String, Never>()
    subject.send("hello") //Push a value to all subscribers
    subject.send("world")
    subject.send(completion: .finished)

    //CurrentValueSubject - like PassthroughSubject but stores current value
    let currentSubject = CurrentValueSubject<Int, Never>(0)
    currentSubject.send(1)
    print(currentSubject.value) //1 - can read current value directly

    //Timer publisher
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    /*In real code your publisher is something like URLSession.dataTaskPublisher 
    which emits once when a network response arrives, or NotificationCenter.publisher 
    which emits every time a system notification fires, or @Published properties on a view model.*/
}


func subscribers() {
    let publisher = [1, 2, 3, 4, 5].publisher

    //sink - most common subscriber, closure-based
    publisher
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished: print("Done")
                case .failure(let error): print("Error: \(error)")
                }
            },
            receiveValue: { value in
                print("Got: \(value)")
            }
        )
        .store(in: &cancellables) //Must store or subscription immediately cancelled
        //Every subsciption has a cancellable obj that is stored to keep the subscription as existing
        //One subscription is over the cacellable object is removed

    //Shorthand sink when publisher cannot fail (Failure == Never)
    [1, 2, 3].publisher
        .sink { print($0) }
        .store(in: &cancellables)

    //assign - bind publisher output directly to a property
    class ViewModel {
        var count: Int = 0
    }
    let vm = ViewModel()
    Just(42)
        .assign(to: \.count, on: vm) //Directly sets vm.count = 42
        .store(in: &cancellables)
}


func operators() {
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].publisher

    //Transforming
    numbers
        .map { $0 * 2 } //Transform each value
        .filter { $0 > 6 } //Keep values matching condition
        .sink { print($0) } //8, 10, 12, 14, 16, 18, 20
        .store(in: &cancellables)

    //compactMap - transform and drop nils
    ["1", "two", "3"].publisher
        .compactMap { Int($0) }
        .sink { print($0) } //1, 3
        .store(in: &cancellables)

    //flatMap - transform each value into a new publisher
    [1, 2, 3].publisher
        .flatMap { Just($0 * 10) }
        .sink { print($0) } //10, 20, 30
        .store(in: &cancellables)

    //Combining
    let pub1 = Just("Hello")
    let pub2 = Just("World")

    //merge - combine two publishers of same type into one stream
    pub1.merge(with: pub2)
        .sink { print($0) }
        .store(in: &cancellables)

    //combineLatest - emit tuple when either publisher emits, using latest from both
    let subject1 = CurrentValueSubject<Int, Never>(0)
    let subject2 = CurrentValueSubject<String, Never>("")
    subject1.combineLatest(subject2)
        .sink { num, str in print("\(num): \(str)") }
        .store(in: &cancellables)

    //Timing
    let subject = PassthroughSubject<String, Never>()
    subject
        .debounce(for: 0.3, scheduler: RunLoop.main) //Wait 0.3s of silence before emitting
        .removeDuplicates() //Skip if value same as previous
        .sink { print($0) }
        .store(in: &cancellables)
}


func commonPatterns() {
    //@Published + sink - observe property changes
    class UserSettings: ObservableObject {
        @Published var username: String = ""
        @Published var isDarkMode: Bool = false
    }

    let settings = UserSettings()
    settings.$username //$ gives access to the Publisher for the property
        .sink { print("Username changed to: \($0)") }
        .store(in: &cancellables)

    settings.username = "Francisco" //Triggers sink

    //Search with debounce - classic pattern for search fields
    let searchSubject = PassthroughSubject<String, Never>()
    searchSubject
        .debounce(for: 0.5, scheduler: RunLoop.main) //Wait for typing to stop
        .removeDuplicates() //Don't search if same as last query
        .filter { !$0.isEmpty } //Skip empty strings
        .sink { query in
            print("Searching for: \(query)")
        }
        .store(in: &cancellables)

    //Networking with Combine
    func fetchUser(id: Int) -> AnyPublisher<String, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://api.example.com/users/\(id)")!)
            .map { $0.data }
            .decode(type: String.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) //Switch to main thread for UI updates
            .eraseToAnyPublisher() //Hide concrete type, expose as AnyPublisher
    }
}