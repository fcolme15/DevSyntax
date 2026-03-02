import SwiftUI

//============================================================
//WRAPPER SUMMARY
//============================================================
//@State                - simple local value, owned by this view
//@Binding              - reference to parent's @State, two-way
//@Observable           - modern (iOS 17+), mark class, use @State to own
//@StateObject          - own an ObservableObject, legacy (iOS 16-)
//@ObservedObject       - reference to ObservableObject owned elsewhere, legacy
//@EnvironmentObject    - ObservableObject from environment, legacy
//@Environment          - read system values (colorScheme, dismiss, etc.)

//============================================================
//STATE MENTAL MODEL
//============================================================
//SwiftUI views are structs - they are recreated constantly
//Property wrappers tell SwiftUI which values should survive recreation and trigger redraws
//When marked state changes, SwiftUI calls body again with the new value
//Think of state as living outside the struct, owned by SwiftUI, injected back in


//============================================================
//@STATE
//============================================================
//@State - private value owned by this view
//Use for simple local UI state: toggles, text input, selected tab, sheet presentation
//Must be private - not meant to be shared
struct CounterView: View {
    @State private var count = 0
    @State private var showAlert = false
    @State private var name = ""

    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") { count += 1 } //Mutating @State triggers redraw
            Button("Show Alert") { showAlert = true }
            TextField("Name", text: $name) //$ creates Binding from @State
        }
        .alert("Hello", isPresented: $showAlert) {
            Button("OK") { }
        }
    }
}


//============================================================
//@BINDING
//============================================================
//@Binding - reference to state owned by a parent view
//Two-way connection - child reads and writes parent's state
//Passed with $ prefix from parent
struct ParentView: View {
    @State private var isOn = false

    var body: some View {
        ToggleView(isOn: $isOn) //Pass Binding with $
        Text(isOn ? "On" : "Off")
    }
}

struct ToggleView: View {
    @Binding var isOn: Bool //Receives Binding, not the value itself

    var body: some View {
        Toggle("Switch", isOn: $isOn) //Can pass Binding further down
    }
}


//============================================================
//OBSERVABLE (iOS 17+) / OBSERVABLEOBJECT (iOS 16 AND BELOW)
//============================================================

//============================================================
//MODERN: @Observable macro (iOS 17+)
//============================================================
//Mark class with @Observable - all stored properties automatically tracked
//No need for @Published, simpler syntax
import Observation

@Observable
class UserViewModel {
    var name = ""
    var age = 0
    var isLoggedIn = false

    func login() { isLoggedIn = true }
}

//@State for owning an Observable in a view
struct ModernView: View {
    @State private var viewModel = UserViewModel() //Owns the object

    var body: some View {
        VStack {
            Text(viewModel.name)
            Button("Login") { viewModel.login() }
        }
    }
}

//Pass Observable to child - no wrapper needed, just pass directly
struct ChildView: View {
    var viewModel: UserViewModel //No wrapper needed for Observable

    var body: some View {
        Text(viewModel.name)
    }
}


//============================================================
//LEGACY: ObservableObject (iOS 16 and below)
//============================================================
//@Published marks properties that trigger view updates when changed
class LegacyViewModel: ObservableObject {
    @Published var name = ""
    @Published var count = 0
    var internalValue = 0 //Not @Published - changes don't trigger updates
}

//@StateObject - owns the ObservableObject, creates and manages its lifetime
//Use in the view that creates the object
struct LegacyOwnerView: View {
    @StateObject private var viewModel = LegacyViewModel()

    var body: some View {
        Text(viewModel.name)
        ChildLegacyView(viewModel: viewModel)
    }
}

//@ObservedObject - reference to ObservableObject owned elsewhere
//Does not own it - object could be deallocated if owner is gone
struct ChildLegacyView: View {
    @ObservedObject var viewModel: LegacyViewModel

    var body: some View {
        Text(viewModel.name)
    }
}


//============================================================
//@ENVIRONMENTOBJECT
//============================================================
//Inject object into the environment - any descendant can access it
//Avoids passing object through every layer of the view hierarchy
class AppSettings: ObservableObject {
    @Published var isDarkMode = false
    @Published var language = "English"
}

struct RootView: View {
    @StateObject private var settings = AppSettings()

    var body: some View {
        ContentView()
            .environmentObject(settings) //Inject into environment
    }
}

struct ContentView: View {
    var body: some View {
        DeepNestedView() //No need to pass settings through here
    }
}

struct DeepNestedView: View {
    @EnvironmentObject var settings: AppSettings //Access from environment directly

    var body: some View {
        Toggle("Dark Mode", isOn: $settings.isDarkMode)
    }
}


//============================================================
//@ENVIRONMENT
//============================================================
//@Environment reads system-provided values from SwiftUI's environment
struct EnvironmentExamples: View {
    @Environment(\.colorScheme) var colorScheme //light or dark
    @Environment(\.locale) var locale
    @Environment(\.dismiss) var dismiss //Dismiss sheet or navigation
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack {
            Text(colorScheme == .dark ? "Dark mode" : "Light mode")
            Button("Dismiss") { dismiss() }
            Button("Open URL") { openURL(URL(string: "https://apple.com")!) }
        }
    }
}


