import Foundation

/// Talks to YOUR backend — never to Visualize directly, and never holds a
/// secret key. The app only ever sees the short-lived session token your
/// server mints. This is the client half of the sample partner backend in
/// ../backend-quickstart.
enum PartnerBackend {
    /// Point this at your running backend. With the sample backend on your
    /// machine and the app in the Simulator, localhost works; on a device,
    /// use your machine's LAN address or a deployed URL.
    static let baseURL = URL(string: "http://localhost:8080")!

    static func sessionToken() async throws -> String {
        var request = URLRequest(url: baseURL.appendingPathComponent("session"))
        request.httpMethod = "POST"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        struct Minted: Decodable { let session_token: String }
        return try JSONDecoder().decode(Minted.self, from: data).session_token
    }
}
