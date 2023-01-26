import Foundation
import KeychainAccess

public struct NetworkingHelper {

  let keychain: KeychainInterface
  let urlSession: URLSessionInterface

  var refreshTokenURL: URL { URL(string: "api/token", relativeTo: authServerURL)! }

  public func authorizedRequest(url: URL, httpMethod: String = "GET") async throws -> (Data, URLResponse) {

    guard let token = keychain.currentAuthorization?.accessToken else {
      throw Errors.notLoggedIn
    }

    let response = try await makeRequest(url: url,
                                         httpMethod: httpMethod,
                                         authToken: token)

    guard response.1.statusCode == 403 else {
      return response
    }


    let newAuthorization = try await refreshToken()

    // notify login controller
    // store in keychain

    return try await makeRequest(url: url,
                                 httpMethod: httpMethod,
                                 authToken: newAuthorization.accessToken)
  }

  private func refreshToken() async throws -> CurrentAuthorization {
    let refreshTokenResponse = try await makeRequest(url: refreshTokenURL,
                                                     httpMethod: "POST")

    guard refreshTokenResponse.1.statusCode == 200 else {
      let vaporError = try JSONDecoder().decode(LoginController.VaporError.self, from: refreshTokenResponse.0)
      throw vaporError
    }

    return try JSONDecoder().decode(CurrentAuthorization.self,
                                                    from: refreshTokenResponse.0)
  }

  private func makeRequest(url: URL, httpMethod: String, authToken: String? = nil) async throws -> (Data, HTTPURLResponse) {
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    if let authToken {
      request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    }

    return try await urlSession.data(for: request) as! (Data, HTTPURLResponse)
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
