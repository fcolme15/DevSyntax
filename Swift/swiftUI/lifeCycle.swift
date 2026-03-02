import SwiftUI


//============================================================
//VIEW LIFECYCLE
//============================================================
//SwiftUI views are structs - they are created and destroyed constantly as state changes
//Lifecycle modifiers let you hook into appearance, disappearance, and state changes
//Unlike UIKit where viewDidLoad fires once, SwiftUI body can be called many times


//============================================================
//ONAPPEAR AND ONDISAPPEAR
//============================================================
struct LifecycleBasics: View {
    @State private var data: [String] = []

    var body: some View {
        List(data, id: \.self) { Text($0) }
            //Called every time view appears on screen - including coming back from another screen
            .onAppear {
                loadData()
            }
            //Called when view leaves the screen
            .onDisappear {
                cleanup()
            }
    }

    func loadData() { data = ["Item 1", "Item 2", "Item 3"] }
    func cleanup() { print("View disappeared") }
}


//============================================================
//.TASK
//============================================================
//.task - preferred for async work on appear, cancelled automatically when view disappears
//Cleaner than onAppear + Task { } because cancellation is handled for you
struct TaskLifecycle: View {
    @State private var users: [String] = []
    @State private var isLoading = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                List(users, id: \.self) { Text($0) }
            }
        }
        //Runs on appear, cancels on disappear - no retain cycle risk
        .task {
            isLoading = true
            users = await fetchUsers()
            isLoading = false
        }

        //.task with id - reruns whenever id value changes
        .task(id: someId) {
            await reload()
        }
    }

    var someId = 1
    func fetchUsers() async -> [String] { ["Alice", "Bob"] }
    func reload() async { }
}


//============================================================
//ONCHANGE
//============================================================
struct OnChangeExample: View {
    @State private var searchText = ""
    @State private var results: [String] = []

    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
            List(results, id: \.self) { Text($0) }
        }
        //Called whenever searchText changes
        .onChange(of: searchText) { oldValue, newValue in //iOS 17+ syntax
            search(query: newValue)
        }

        //iOS 16 and below - only new value
        //.onChange(of: searchText) { newValue in
        //    search(query: newValue)
        //}
    }

    func search(query: String) {
        results = query.isEmpty ? [] : ["Result for \(query)"]
    }
}


//============================================================
//ONRECEIVE
//============================================================
//Listen to a Combine publisher from within a view
struct OnReceiveExample: View {
    @State private var timeString = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(timeString)
            .onReceive(timer) { date in //Called every time publisher emits
                timeString = date.formatted(date: .omitted, time: .standard)
            }
    }
}


//============================================================
//APP AND SCENE LIFECYCLE
//============================================================
//Entry point of a SwiftUI app
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentRootView()
        }
    }
}

struct ContentRootView: View {
    var body: some View { Text("Root") }
}

//Scene phases - respond to app moving between foreground/background
struct ScenePhaseExample: View {
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Text("App")
            .onChange(of: scenePhase) { _, newPhase in
                switch newPhase {
                case .active: print("App is active")
                case .inactive: print("App is inactive")
                case .background: print("App in background - save data here")
                @unknown default: break
                }
            }
    }
}


//============================================================
//INITIALIZATION AND DEINITIALIZATION
//============================================================
//Views are structs - init is called frequently, do not put heavy work in init
//For one-time setup use .task or .onAppear
//For cleanup use a class with deinit passed via @StateObject
class ResourceManager {
    init() { print("Resources acquired") }
    deinit { print("Resources released") } //Called when view is fully removed
}

struct ManagedView: View {
    @StateObject private var manager = ResourceManager() //Lifetime tied to view

    var body: some View {
        Text("Managed view")
    }
}