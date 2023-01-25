import Foundation
import KeychainAccess

public struct NetworkingHelper {
  public func authorizedRequest(url: URL, httpMethod: String = "GET") async throws -> (Data, URLResponse) {
    guard let token = Keychain().currentAuthorization?.accessToken else {
      throw Errors.notLoggedIn
    }

    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    return try await URLSession.shared.data(for: request)
  }

  public enum Errors: Error, LocalizedError {
    case urlSession(Error)
    case notLoggedIn

    public var errorDescription: String? {
      switch self {
      case .notLoggedIn:
        return "Not logged in"
      case .urlSession(let error):
        return "URL Session error: " + error.localizedDescription
      }
    }
  }
}
