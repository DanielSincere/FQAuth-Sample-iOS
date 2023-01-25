import Foundation
import KeychainAccess

public struct NetworkingHelper {

  let keychain: KeychainInterface
  let urlSession: URLSessionInterface

  public func authorizedRequest(url: URL, httpMethod: String = "GET") async throws -> (Data, URLResponse) {
    guard let token = keychain.currentAuthorization?.accessToken else {
      throw Errors.notLoggedIn
    }

    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    return try await urlSession.data(for: request)
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
