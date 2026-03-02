func asyncAwaitOverview() {
    asyncFunctions()
    taskCreation()
    asyncLet()
    actorsBasics()
    taskGroups()
}


func asyncFunctions() {
    //async marks a function as asynchronous - it can suspend and resume
    //await marks a suspension point - thread is freed while waiting, not blocked
    func fetchUsername(id: Int) async -> String {
        //Simulate network delay - in real code this would be a URLSession call
        try? await Task.sleep(nanoseconds: 1_000_000_000) //1 second, non-blocking
        return "Francisco"
    }

    //async throws - can both suspend and throw errors
    func fetchData(from url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url) //await suspends here
        return data
    }

    //Calling async functions requires await
    //await can only be used inside an async context
    func loadUser() async {
        let name = await fetchUsername(id: 1) //Suspends here until fetchUsername returns
        print("User: \(name)")

        do {
            let data = try await fetchData(from: "https://api.example.com/users")
        } catch {
            print("Failed: \(error)")
        }
    }
}


func taskCreation() {
    //Task - unit of async work, creates an async context from sync code
    //Inherits actor context and priority from the surrounding scope
    Task {
        let result = await someAsyncFunction()
        print(result)
    }

    //Task with priority
    Task(priority: .high) {
        await someAsyncFunction()
    }

    //Task.detached - does not inherit context or priority from surrounding scope
    Task.detached {
        await someAsyncFunction()
    }

    //Storing a task to cancel later
    let task = Task {
        try await Task.sleep(nanoseconds: 5_000_000_000)
        return "Done"
    }
    task.cancel() //Cooperative cancellation - task must check for cancellation

    //Check for cancellation inside a task
    Task {
        try Task.checkCancellation() //Throws CancellationError if cancelled
        //Or check without throwing
        if Task.isCancelled { return }
    }
}


func asyncLet() {
    //async let starts a child task immediately without waiting
    //Use when you have multiple independent async operations to run concurrently
    func fetchUserAndPosts() async throws {
        //Both start at the same time - not sequential
        async let user = fetchUser() //Starts immediately
        async let posts = fetchPosts() //Starts immediately, doesn't wait for user

        //await both when you need the values - waits for whichever isn't done yet
        let (resolvedUser, resolvedPosts) = try await (user, posts)
        print("\(resolvedUser): \(resolvedPosts.count) posts")
    }

    //Compare to sequential - user finishes, then posts starts
    func sequential() async throws {
        let user = try await fetchUser() //Wait for user
        let posts = try await fetchPosts() //Then wait for posts - total time = user + posts
    }
    //async let total time = max(user, posts) - they overlap
}


func actorsBasics() {
    //Actor - reference type like class, but protects its state from concurrent access
    //Only one task can access actor's mutable state at a time - no data races
    actor BankAccount {
        private var balance: Double = 0

        func deposit(_ amount: Double) {
            balance += amount //Safe - only one task accesses at a time
        }

        func withdraw(_ amount: Double) throws {
            guard balance >= amount else { throw BankError.insufficientFunds }
            balance -= amount
        }

        var currentBalance: Double { balance }
    }

    enum BankError: Error { case insufficientFunds }

    //Accessing actor from outside requires await - may need to wait for actor to be free
    Task {
        let account = BankAccount()
        await account.deposit(100)
        print(await account.currentBalance) //100.0
    }

    //MainActor - special actor that runs on the main thread
    //UI updates must happen on the main thread
    @MainActor
    func updateUI(text: String) {
        //This function is guaranteed to run on the main thread
        //label.text = text
    }

    //Switch to main actor from async context
    Task {
        let data = try? await fetchData()
        await MainActor.run {
            //Update UI here
        }
    }
}


func taskGroups() {
    //TaskGroup - run a dynamic number of concurrent tasks and collect results
    func fetchAllUsers(ids: [Int]) async throws -> [String] {
        try await withThrowingTaskGroup(of: String.self) { group in
            for id in ids {
                group.addTask { //Each iteration adds a concurrent task
                    try await fetchUserById(id)
                }
            }

            var users: [String] = []
            for try await user in group { //Collect results as they complete
                users.append(user)
            }
            return users //Order not guaranteed - tasks finish at different times
        }
    }

    //Non-throwing version
    func fetchAllScores(ids: [Int]) async -> [Int] {
        await withTaskGroup(of: Int.self) { group in
            for id in ids { group.addTask { await fetchScore(id) } }
            var scores: [Int] = []
            for await score in group { scores.append(score) }
            return scores
        }
    }
}


//Placeholder functions used above
func someAsyncFunction() async -> String { "result" }
func fetchUser() async throws -> String { "Francisco" }
func fetchPosts() async throws -> [String] { ["post1", "post2"] }
func fetchUserById(_ id: Int) async throws -> String { "User\(id)" }
func fetchScore(_ id: Int) async -> Int { id * 10 }
func fetchData() async throws -> Data { Data() }