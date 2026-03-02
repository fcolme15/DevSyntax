//SwiftUI/DataFlow.swift
import SwiftUI
import Observation


//============================================================
//DATA FLOW MENTAL MODEL
//============================================================
//Data flows down, actions flow up
//Parent owns state, passes read-only values or Bindings to children
//Children never own shared state - they receive it
//Single source of truth: one place stores each piece of data


//============================================================
//THE FULL PICTURE - WHICH WRAPPER TO USE
//============================================================
//
//  Is this local UI state only this view needs?
//      YES -> @State
//
//  Does a child need to read AND write parent's state?
//      YES -> @Binding (pass with $)
//
//  Is this a class with business logic shared across views?
//      iOS 17+ -> @Observable class, owned with @State
//      iOS 16-  -> ObservableObject class, owned with @StateObject
//
//  Does a child just need to observe (not own) that class?
//      iOS 17+ -> pass directly, no wrapper needed
//      iOS 16-  -> @ObservedObject
//
//  Does a deeply nested view need access without passing through every level?
//      -> @EnvironmentObject (legacy) or @Environment with custom key (modern)
//
//  Does the view need a system value (colorScheme, dismiss, locale)?
//      -> @Environment(\.keyPath)


//============================================================
//SINGLE SOURCE OF TRUTH PATTERN
//============================================================
@Observable
class CartViewModel {
    var items: [String] = []
    var total: Double = 0

    func addItem(_ item: String, price: Double) {
        items.append(item)
        total += price
    }

    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

//Root owns the state
struct StoreView: View {
    @State private var cart = CartViewModel() //Single source of truth

    var body: some View {
        TabView {
            ProductListView(cart: cart) //Pass down
                .tabItem { Label("Shop", systemImage: "bag") }

            CartView(cart: cart) //Same object, same data
                .tabItem { Label("Cart", systemImage: "cart") }
        }
    }
}

struct ProductListView: View {
    var cart: CartViewModel //Receives reference, changes reflect everywhere

    var body: some View {
        List {
            Button("Add Apple") { cart.addItem("Apple", price: 1.99) }
            Button("Add Banana") { cart.addItem("Banana", price: 0.99) }
        }
    }
}

struct CartView: View {
    var cart: CartViewModel

    var body: some View {
        List {
            ForEach(cart.items, id: \.self) { Text($0) }
        }
        Text("Total: $\(cart.total, specifier: "%.2f")")
    }
}


//============================================================
//PASSING STATE DOWN VS PASSING BINDING
//============================================================
struct BindingVsValue: View {
    @State private var name = ""
    @State private var isEnabled = true

    var body: some View {
        VStack {
            //Pass value - child can read but not write
            DisplayView(name: name)

            //Pass binding - child can read and write
            EditView(name: $name)

            //Pass binding to toggle
            ToggleRow(isEnabled: $isEnabled)
        }
    }
}

struct DisplayView: View {
    let name: String //Value - read only
    var body: some View { Text(name) }
}

struct EditView: View {
    @Binding var name: String //Binding - two way
    var body: some View { TextField("Name", text: $name) }
}

struct ToggleRow: View {
    @Binding var isEnabled: Bool
    var body: some View { Toggle("Enabled", isOn: $isEnabled) }
}


//============================================================
//CUSTOM ENVIRONMENT VALUES (iOS 17+)
//============================================================
//Inject custom values into environment without ObservableObject
struct ThemeKey: EnvironmentKey {
    static let defaultValue = "light" //Required default
}

extension EnvironmentValues {
    var theme: String {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

struct ThemedApp: View {
    var body: some View {
        ThemedContent()
            .environment(\.theme, "dark") //Inject custom value
    }
}

struct ThemedContent: View {
    @Environment(\.theme) var theme //Read custom value

    var body: some View {
        Text("Theme: \(theme)")
    }
}

