import SwiftUI


//============================================================
//NAVIGATIONSTACK
//============================================================
//NavigationStack manages a stack of views - push to go deeper, pop to go back
//Modern replacement for NavigationView (deprecated iOS 16+)
struct NavigationExample: View {
    var body: some View {
        NavigationStack {
            List {
                //NavigationLink pushes destination onto the stack
                NavigationLink("Go to Detail") {
                    DetailView(title: "Pushed View")
                }

                NavigationLink("Another Screen") {
                    Text("Another destination")
                }
            }
            .navigationTitle("Home") //Sets title in navigation bar
            .navigationBarTitleDisplayMode(.large) //.large or .inline
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") { }
                }
            }
        }
    }
}

struct DetailView: View {
    let title: String

    var body: some View {
        Text(title)
            .navigationTitle(title) //Each view sets its own title
            .navigationBarBackButtonHidden(false)
    }
}


//============================================================
//PROGRAMMATIC NAVIGATION (iOS 16+)
//============================================================
//Drive navigation with data - push views by appending to a path
struct ProgrammaticNavigation: View {
    @State private var path = NavigationPath() //Stack state lives here

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Push Detail") {
                    path.append("detail") //Push by appending a value
                }
                Button("Push Profile") {
                    path.append(42) //Different types supported
                }
                Button("Go to root") {
                    path.removeLast(path.count) //Pop everything
                }
            }
            .navigationDestination(for: String.self) { value in
                Text("String destination: \(value)")
            }
            .navigationDestination(for: Int.self) { id in
                Text("Int destination: \(id)")
            }
        }
    }
}


//============================================================
//SHEETS AND FULLSCREEN COVERS
//============================================================
struct SheetExamples: View {
    @State private var showSheet = false
    @State private var showFullScreen = false
    @State private var showDetents = false

    var body: some View {
        VStack {
            Button("Show Sheet") { showSheet = true }
            Button("Full Screen") { showFullScreen = true }
            Button("Detents") { showDetents = true }
        }
        //Sheet - slides up from bottom, dismissible by dragging
        .sheet(isPresented: $showSheet) {
            SheetContent()
        }
        //Full screen cover - covers entire screen
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenContent()
        }
        //Sheet with custom height using detents (iOS 16+)
        .sheet(isPresented: $showDetents) {
            Text("Partial sheet")
                .presentationDetents([.medium, .large]) //Snap points
                .presentationDragIndicator(.visible)
        }
    }
}

struct SheetContent: View {
    @Environment(\.dismiss) var dismiss //Dismiss from within sheet

    var body: some View {
        Button("Dismiss") { dismiss() }
    }
}

struct FullScreenContent: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Close") { dismiss() }
    }
}


//============================================================
//TAB VIEW
//============================================================
struct TabViewExample: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTab()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0) //Value that selectedTab is set to when this tab is tapped

            SearchTab()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)

            ProfileTab()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
}

struct HomeTab: View { var body: some View { Text("Home") } }
struct SearchTab: View { var body: some View { Text("Search") } }
struct ProfileTab: View { var body: some View { Text("Profile") } }


//============================================================
//ALERTS AND CONFIRMATION DIALOGS
//============================================================
struct AlertExamples: View {
    @State private var showAlert = false
    @State private var showDialog = false

    var body: some View {
        VStack {
            Button("Alert") { showAlert = true }
            Button("Dialog") { showDialog = true }
        }
        .alert("Delete Item?", isPresented: $showAlert) {
            Button("Delete", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This cannot be undone")
        }
        .confirmationDialog("Choose action", isPresented: $showDialog) {
            Button("Option 1") { }
            Button("Option 2") { }
            Button("Cancel", role: .cancel) { }
        }
    }
}