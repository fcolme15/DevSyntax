func propertyWrappersOverview() {
    propertyWrapperBasics()
    wrappedAndProjectedValues()
    builtInWrappers()
}


func propertyWrapperBasics() {
    //@propertyWrapper lets you extract common property logic into a reusable wrapper
    //The wrapper manages storage and access, the using type just declares the property

    //Example - clamping a value to a range automatically
    @propertyWrapper
    struct Clamped {
        private var value: Int
        private let range: ClosedRange<Int>

        var wrappedValue: Int { //wrappedValue is required - what the property reads/writes
            get { value }
            set { value = min(max(newValue, range.lowerBound), range.upperBound) }
        }

        init(wrappedValue: Int, range: ClosedRange<Int>) {
            self.range = range
            self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
        }
    }

    struct Player {
        @Clamped(range: 0...100) var health: Int = 100
        @Clamped(range: 0...10) var level: Int = 1
    }

    var player = Player()
    player.health = 150 //Clamped to 100
    player.health = -10 //Clamped to 0
    print(player.health) //0
    player.level = 5
    print(player.level) //5
}


func wrappedAndProjectedValues() {
    @propertyWrapper
    struct Logged<T> {
        private var value: T
        var log: [T] = [] //History of all values set

        var wrappedValue: T {
            get { value }
            set {
                log.append(newValue)
                value = newValue
            }
        }

        //$propertyName gives access to the projected value
        //projectedValue can be any type - here we expose the wrapper itself
        var projectedValue: Logged<T> { self }

        init(wrappedValue: T) {
            self.value = wrappedValue
        }
    }

    struct Sensor {
        @Logged var temperature: Double = 0.0
    }

    var sensor = Sensor()
    sensor.temperature = 98.6
    sensor.temperature = 99.1
    sensor.temperature = 97.8

    print(sensor.temperature) //97.8 - wrappedValue, accessed normally
    print(sensor.$temperature.log) //[98.6, 99.1, 97.8] - projectedValue via $ prefix
}


func builtInWrappers() {
    //Swift and SwiftUI provide many built-in property wrappers
    //Full usage covered in SwiftUI/State.swift, here just the concepts

    //@State - owns and stores value in SwiftUI view, triggers re-render on change
    //@Binding - reference to state owned by another view, two-way connection
    //@StateObject - owns a reference type (ObservableObject) for the view's lifetime
    //@ObservedObject - reference to an ObservableObject owned elsewhere
    //@EnvironmentObject - shared object injected into the environment, accessible anywhere in view tree
    //@Published - marks a property in ObservableObject to broadcast changes to observers
    //@AppStorage - persists value in UserDefaults, syncs with SwiftUI view
    //@Environment - reads values from SwiftUI's environment (color scheme, locale, etc.)
}