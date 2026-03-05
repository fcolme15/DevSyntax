import SwiftData
import SwiftUI


//============================================================
//SWIFTDATA MENTAL MODEL
//============================================================
//SwiftData is Apple's modern persistence framework (iOS 17+)
//Replaces CoreData with a Swift-native, macro-based API
//Data is persisted to disk automatically - survives app restarts
//Integrates directly with SwiftUI views via @Query


//============================================================
//DEFINING MODELS
//============================================================
//@Model macro makes a class persistable - adds all required conformances
@Model
class TodoItem {
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var priority: Int

    init(title: String, priority: Int = 0) {
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
        self.priority = priority
    }
}

//Relationships between models
@Model
class User {
    var name: String
    var email: String

    //One-to-many - one User has many Posts
    @Relationship(deleteRule: .cascade) //Delete posts when user is deleted
    var posts: [Post] = []

    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

@Model
class Post {
    var title: String
    var content: String
    var user: User? //Back-reference, optional because post might not have user

    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}


//============================================================
//SETTING UP THE CONTAINER
//============================================================
//ModelContainer manages the persistent store - set up once at app root
@main
struct MyDataApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView()
        }
        //Register all models the app uses
        .modelContainer(for: [TodoItem.self, User.self, Post.self])

        //In-memory container for previews and testing
        //.modelContainer(for: TodoItem.self, inMemory: true)
    }
}


//============================================================
//QUERYING DATA
//============================================================
//@Query fetches data from the store and updates the view when data changes
struct TodoListView: View {
    //Basic query - all items
    @Query var todos: [TodoItem]

    //Query with sort
    @Query(sort: \TodoItem.createdAt, order: .reverse) var sortedTodos: [TodoItem]

    //Query with filter (predicate)
    @Query(filter: #Predicate<TodoItem> { $0.isCompleted == false })
    var incompleteTodos: [TodoItem]

    //Query with sort and filter combined
    @Query(
        filter: #Predicate<TodoItem> { $0.priority > 0 },
        sort: \TodoItem.priority,
        order: .reverse
    ) var highPriorityTodos: [TodoItem]

    @Environment(\.modelContext) var context //Access to the model context for writes

    var body: some View {
        List {
            ForEach(todos) { todo in
                TodoRow(todo: todo)
            }
            .onDelete { indexSet in
                indexSet.forEach { context.delete(todos[$0]) }
            }
        }
        .toolbar {
            Button("Add") { addTodo() }
        }
    }

    func addTodo() {
        let newTodo = TodoItem(title: "New task")
        context.insert(newTodo) //Add to store
    }
}


//============================================================
//CREATING, UPDATING, DELETING
//============================================================
struct TodoRow: View {
    let todo: TodoItem
    @Environment(\.modelContext) var context

    var body: some View {
        HStack {
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .onTapGesture { todo.isCompleted.toggle() } //Mutations auto-saved

            Text(todo.title)
        }
        .swipeActions {
            Button("Delete", role: .destructive) {
                context.delete(todo) //Removes from store
            }
        }
    }
}

struct CreateTodoView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State private var title = ""

    var body: some View {
        Form {
            TextField("Title", text: $title)
            Button("Save") {
                let todo = TodoItem(title: title) //Create model
                context.insert(todo) //Persist it
                dismiss()
            }
        }
    }
}


//============================================================
//MODELCONTEXT OPERATIONS
//============================================================
func modelContextOperations(context: ModelContext) throws {
    //Insert
    let todo = TodoItem(title: "Buy groceries")
    context.insert(todo)

    //Mutations on @Model objects are tracked and saved automatically
    todo.isCompleted = true //Auto-saved on next save cycle

    //Delete
    context.delete(todo)

    //Manual save - SwiftData auto-saves but you can force it
    try context.save()

    //Fetch manually outside of a view (in a view model or service)
    let descriptor = FetchDescriptor<TodoItem>(
        predicate: #Predicate { $0.isCompleted == false },
        sortBy: [SortDescriptor(\TodoItem.createdAt)]
    )
    let results = try context.fetch(descriptor)

    //Batch delete
    try context.delete(model: TodoItem.self, where: #Predicate { $0.isCompleted })
}


//============================================================
//USING SWIFTDATA IN PREVIEWS
//============================================================
#Preview {
    TodoListView()
        .modelContainer(for: TodoItem.self, inMemory: true) //Preview doesn't persist
}