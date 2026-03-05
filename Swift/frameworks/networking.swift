import Foundation


//============================================================
//NETWORKING MENTAL MODEL
//============================================================
//URLSession is the built-in HTTP client - no third party needed for basic networking
//All network calls are async - use async/await (modern) or completion handlers (legacy)
//Always decode on background, update UI on main thread


func networkingOverview() {
    basicRequests()
    decodingResponses()
    buildingAnAPIClient()
    uploadingData()
    backgroundSessions()
}


func basicRequests() {
    //GET request - simplest form
    func fetchData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        //data(from:) suspends until response arrives, returns (Data, URLResponse)
        let (data, response) = try await URLSession.shared.data(from: url)

        //Always validate HTTP status code
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return data
    }

    //POST request with body
    func postData(to urlString: String, body: Data) async throws -> Data {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return data
    }

    //Other HTTP methods follow same pattern - just change httpMethod
    //"PUT", "PATCH", "DELETE"
}


func decodingResponses() {
    struct Post: Codable {
        let id: Int
        let title: String
        let body: String
        let userId: Int
    }

    //Fetch and decode in one function
    func fetchPost(id: Int) async throws -> Post {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Post.self, from: data) //Throws DecodingError on failure
    }

    //Fetch array
    func fetchAllPosts() async throws -> [Post] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }

    //Usage
    Task {
        do {
            let post = try await fetchPost(id: 1)
            print(post.title)
        } catch let error as DecodingError {
            print("Decode failed: \(error)")
        } catch let error as URLError {
            print("Network failed: \(error.localizedDescription)")
        } catch {
            print("Unknown error: \(error)")
        }
    }
}


func buildingAnAPIClient() {
    //Real apps use a structured API client rather than scattered URLSession calls

    enum APIError: Error {
        case invalidURL
        case badResponse(statusCode: Int)
        case decodingFailed
    }

    struct APIClient {
        let baseURL: String
        let session: URLSession
        private let decoder: JSONDecoder

        init(baseURL: String, session: URLSession = .shared) {
            self.baseURL = baseURL
            self.session = session
            self.decoder = JSONDecoder()
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase //Auto converts snake_case to camelCase
        }

        //Generic request - works with any Codable response type
        func fetch<T: Codable>(_ endpoint: String) async throws -> T {
            guard let url = URL(string: baseURL + endpoint) else {
                throw APIError.invalidURL
            }

            let (data, response) = try await session.data(from: url)

            guard let http = response as? HTTPURLResponse else {
                throw APIError.badResponse(statusCode: -1)
            }

            guard (200...299).contains(http.statusCode) else {
                throw APIError.badResponse(statusCode: http.statusCode)
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        }

        func post<Body: Encodable, Response: Codable>(
            _ endpoint: String,
            body: Body
        ) async throws -> Response {
            guard let url = URL(string: baseURL + endpoint) else {
                throw APIError.invalidURL
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)

            let (data, _) = try await session.data(for: request)
            return try decoder.decode(Response.self, from: data)
        }
    }

    //Usage
    struct User: Codable { let id: Int; let name: String }

    let client = APIClient(baseURL: "https://api.example.com")

    Task {
        let user: User = try await client.fetch("/users/1") //Type inferred from return annotation
        print(user.name)
    }
}


func uploadingData() {
    //Upload file data
    func uploadImage(_ imageData: Data, to urlString: String) async throws {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.upload(for: request, from: imageData)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    //Multipart form upload
    func uploadMultipart(imageData: Data, name: String, to urlString: String) async throws {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        let (_, _) = try await URLSession.shared.upload(for: request, from: body)
    }
}


func backgroundSessions() {
    //Background URLSession - continues downloads/uploads even when app is suspended
    let config = URLSessionConfiguration.background(withIdentifier: "com.app.background")
    config.isDiscretionary = true //System chooses optimal time
    config.sessionSendsLaunchEvents = true //Wake app when complete

    let backgroundSession = URLSession(configuration: config)

    //Download file to disk - preferred for large files
    func downloadFile(from urlString: String) async throws -> URL {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (localURL, _) = try await backgroundSession.download(from: url)
        //localURL is temporary - move to permanent location immediately
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent(url.lastPathComponent)
        try FileManager.default.moveItem(at: localURL, to: destination)
        return destination
    }
}