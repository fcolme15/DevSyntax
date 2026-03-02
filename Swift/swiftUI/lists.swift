import SwiftUI


//============================================================
//LIST BASICS
//============================================================
struct BasicList: View {
    let fruits = ["Apple", "Banana", "Cherry", "Date"]

    var body: some View {
        //List - scrollable column of rows, platform styled automatically
        List(fruits, id: \.self) { fruit in //id: \.self uses value itself as identifier
            Text(fruit)
        }
    }
}


//============================================================
//IDENTIFIABLE DATA
//============================================================
//Identifiable protocol - type provides a stable unique id
//Preferred over id: \.self which can cause issues with duplicate values
struct Person: Identifiable {
    let id = UUID() //UUID generates a unique identifier
    var name: String
    var age: Int
}

struct PeopleList: View {
    let people = [
        Person(name: "Alice", age: 30),
        Person(name: "Bob", age: 25),
        Person(name: "Carol", age: 35)
    ]

    var body: some View {
        List(people) { person in //No id needed - Person conforms to Identifiable
            VStack(alignment: .leading) {
                Text(person.name).font(.headline)
                Text("Age: \(person.age)").font(.subheadline)
            }
        }
    }
}


//============================================================
//FOREACH
//============================================================
//ForEach generates views from a collection - not a scroll container like List
//Use inside ScrollView, VStack, or List when you need more layout control
struct ForEachExamples: View {
    let items = ["A", "B", "C", "D"]
    @State private var numbers = [1, 2, 3, 4, 5]

    var body: some View {
        VStack {
            //ForEach inside VStack - no automatic scroll
            ForEach(items, id: \.self) { item in
                Text(item)
            }

            //ForEach with range
            ForEach(0..<5) { index in
                Text("Item \(index)")
            }

            //ForEach inside List - gives list row styling
            List {
                ForEach(numbers, id: \.self) { num in
                    Text("\(num)")
                }
                //Delete support requires ForEach inside List
                .onDelete { indexSet in
                    numbers.remove(atOffsets: indexSet)
                }
                //Move support
                .onMove { from, to in
                    numbers.move(fromOffsets: from, toOffset: to)
                }
            }
            .toolbar { EditButton() } //Enables edit mode for delete/move
        }
    }
}


//============================================================
//LIST SECTIONS
//============================================================
struct SectionedList: View {
    var body: some View {
        List {
            Section("Fruits") {
                Text("Apple")
                Text("Banana")
            }

            Section("Vegetables") {
                Text("Carrot")
                Text("Broccoli")
            }

            Section {
                Text("Item")
            } header: {
                Text("Custom Header")
                    .font(.headline)
            } footer: {
                Text("Footer text")
                    .font(.caption)
            }
        }
    }
}


//============================================================
//LIST STYLES AND CUSTOMIZATION
//============================================================
struct ListStyleExamples: View {
    let items = ["One", "Two", "Three"]

    var body: some View {
        VStack {
            List(items, id: \.self) { Text($0) }
                .listStyle(.plain) //No section headers, minimal styling

            List(items, id: \.self) { Text($0) }
                .listStyle(.insetGrouped) //Rounded grouped style (default on iOS)

            List(items, id: \.self) { Text($0) }
                .listStyle(.sidebar) //Sidebar style for iPadOS

            //Custom row styling
            List(items, id: \.self) { item in
                Text(item)
                    .listRowBackground(Color.blue.opacity(0.1))
                    .listRowSeparator(.hidden)
            }
        }
    }
}


//============================================================
//DYNAMIC LISTS WITH STATE
//============================================================
struct DynamicList: View {
    @State private var items = ["First", "Second", "Third"]
    @State private var newItem = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
                .onDelete { items.remove(atOffsets: $0) }
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .safeAreaInset(edge: .bottom) {
                //Pinned input at bottom, above keyboard
                HStack {
                    TextField("New item", text: $newItem)
                        .textFieldStyle(.roundedBorder)
                    Button("Add") {
                        guard !newItem.isEmpty else { return }
                        items.append(newItem)
                        newItem = ""
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
}