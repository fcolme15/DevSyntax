import Foundation


func foundationOverview() {
    datesAndTime()
    urlAndRequests()
    jsonCoding()
    fileManager()
    userDefaults()
    notificationCenter()
}


func datesAndTime() {
    //Date represents a point in time - stored as seconds since Jan 1 2001
    let now = Date() //Current date and time
    let tomorrow = Date(timeIntervalSinceNow: 86400) //86400 seconds = 1 day
    let past = Date(timeIntervalSince1970: 0) //Unix epoch Jan 1 1970

    //Calendar - performs calendar arithmetic
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: now)
    let year = components.year //Current year as Int?

    //Adding time intervals
    var twoWeeksFromNow = calendar.date(byAdding: .day, value: 14, to: now)
    let nextMonth = calendar.date(byAdding: .month, value: 1, to: now)

    //Comparing dates
    let isAfter = tomorrow > now //true
    let isSameDay = calendar.isDate(now, inSameDayAs: tomorrow) //false

    //DateFormatter - converting Date to/from String (legacy, still common)
    let formatter = DateFormatter()
    formatter.dateStyle = .medium //"Jan 1, 2025"
    formatter.timeStyle = .short //"3:30 PM"
    let dateString = formatter.string(from: now) //"Jan 1, 2025 at 3:30 PM"
    let parsedDate = formatter.date(from: "Jan 1, 2025 at 3:30 PM") //Date?

    //ISO8601 - standard format for API communication
    let isoFormatter = ISO8601DateFormatter()
    let isoString = isoFormatter.string(from: now) //"2025-01-01T15:30:00Z"

    //Modern formatting (iOS 15+) - preferred
    let formatted = now.formatted() //"1/1/2025, 3:30 PM"
    let dateOnly = now.formatted(date: .long, time: .omitted) //"January 1, 2025"
    let timeOnly = now.formatted(date: .omitted, time: .standard) //"3:30:00 PM"
    let relative = now.formatted(.relative(presentation: .named)) //"now", "yesterday"
}


func urlAndRequests() {
    //URL - represents a resource location, local or remote
    let remoteURL = URL(string: "https://api.example.com/users") //URL? - may fail if invalid
    let localURL = URL(fileURLWithPath: "/Users/francisco/Documents/file.txt")

    //Building URLs with components - safer than string concatenation
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.example.com"
    components.path = "/users"
    components.queryItems = [
        URLQueryItem(name: "page", value: "1"),
        URLQueryItem(name: "limit", value: "20")
    ]
    let builtURL = components.url //https://api.example.com/users?page=1&limit=20

    //URLRequest - wraps URL with method, headers, body
    guard let url = remoteURL else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer mytoken", forHTTPHeaderField: "Authorization")
    request.timeoutInterval = 30
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["name": "Francisco"])

    //URLSession - performs network requests, covered fully in Frameworks/Networking.swift
}


func jsonCoding() {
    struct User: Codable { //Codable = Encodable + Decodable
        let id: Int
        let name: String
        let email: String
        var age: Int?

        //Custom key mapping if JSON keys differ from Swift property names
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case email
            case age = "user_age" //JSON uses "user_age", Swift uses "age"
        }
    }

    //Decoding - JSON Data to Swift struct
    let jsonString = """
    {"id": 1, "name": "Francisco", "email": "f@example.com", "user_age": 23}
    """
    let jsonData = Data(jsonString.utf8)

    do {
        let user = try JSONDecoder().decode(User.self, from: jsonData)
        print(user.name) //"Francisco"
    } catch DecodingError.keyNotFound(let key, _) {
        print("Missing key: \(key)")
    } catch {
        print("Decode error: \(error)")
    }

    //Decoding arrays
    let arrayJSON = Data("""[{"id":1,"name":"Alice","email":"a@b.com"},{"id":2,"name":"Bob","email":"b@b.com"}]""".utf8)
    let users = try? JSONDecoder().decode([User].self, from: arrayJSON)

    //Encoding - Swift struct to JSON Data
    let user = User(id: 1, name: "Francisco", email: "f@example.com", age: 23)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted //Human readable output
    encoder.keyEncodingStrategy = .convertToSnakeCase //Auto converts camelCase to snake_case
    let encoded = try? encoder.encode(user)
    let encodedString = encoded.flatMap { String(data: $0, encoding: .utf8) }

    //Date strategies - how dates are encoded/decoded
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601 //Expects "2025-01-01T00:00:00Z"
    //decoder.dateDecodingStrategy = .secondsSince1970
    //decoder.dateDecodingStrategy = .millisecondsSince1970
}


func fileManager() {
    let fm = FileManager.default

    //Common directories
    let documents = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
    let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first!
    let temp = FileManager.default.temporaryDirectory

    //Building file paths
    let fileURL = documents.appendingPathComponent("data.json")

    //Reading and writing
    let content = "Hello, world!"
    try? content.write(to: fileURL, atomically: true, encoding: .utf8)
    let read = try? String(contentsOf: fileURL, encoding: .utf8)

    //Data read/write
    let data = Data("bytes".utf8)
    try? data.write(to: fileURL)
    let readData = try? Data(contentsOf: fileURL)

    //File operations
    let exists = fm.fileExists(atPath: fileURL.path)
    try? fm.removeItem(at: fileURL)
    try? fm.copyItem(at: fileURL, to: caches.appendingPathComponent("data.json"))
    try? fm.moveItem(at: fileURL, to: caches.appendingPathComponent("moved.json"))

    //Directory contents
    let contents = try? fm.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil)
    contents?.forEach { print($0.lastPathComponent) }
}


func userDefaults() {
    //UserDefaults - simple key-value persistent storage
    //Use for small preferences: settings, flags, simple values
    //Not for sensitive data (use Keychain) or large data (use file system or SwiftData)
    let defaults = UserDefaults.standard

    //Writing
    defaults.set("Francisco", forKey: "username")
    defaults.set(23, forKey: "age")
    defaults.set(true, forKey: "isDarkMode")
    defaults.set(Date(), forKey: "lastLogin")

    //Reading - typed methods, returns default if key doesn't exist
    let username = defaults.string(forKey: "username") //String? - nil if not set
    let age = defaults.integer(forKey: "age") //Int - 0 if not set
    let isDarkMode = defaults.bool(forKey: "isDarkMode") //Bool - false if not set
    let lastLogin = defaults.object(forKey: "lastLogin") as? Date

    //Removing
    defaults.removeObject(forKey: "username")

    //@AppStorage in SwiftUI - wraps UserDefaults as a property wrapper
    //@AppStorage("isDarkMode") var isDarkMode = false
}


func notificationCenter() {
    //NotificationCenter - broadcast/receive events across unrelated parts of the app
    //Use sparingly - prefer direct state management or Combine in modern code

    //Posting a notification
    NotificationCenter.default.post(
        name: Notification.Name("UserDidLogin"),
        object: nil,
        userInfo: ["username": "Francisco"]
    )

    //Observing a notification
    let observer = NotificationCenter.default.addObserver(
        forName: Notification.Name("UserDidLogin"),
        object: nil,
        queue: .main //Which queue the handler runs on
    ) { notification in
        let username = notification.userInfo?["username"] as? String
        print("Logged in: \(username ?? "")")
    }

    //Must remove observer to avoid memory leak
    NotificationCenter.default.removeObserver(observer)

    //Common system notifications
    //UIApplication.willResignActiveNotification - app going to background
    //UIApplication.didBecomeActiveNotification - app coming to foreground
    //UIResponder.keyboardWillShowNotification - keyboard appearing
}