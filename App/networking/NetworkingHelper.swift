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

    let response = try await urlSession.data(for: request)

    guard (response.1 as! HTTPURLResponse).statusCode == 403 else {
      return response
    }


    let refreshTokenRequest = URLRequest(url: URL(string: "api/token", relativeTo: authServerURL)!)

    let refreshTokenResponse = try await urlSession.data(for: refreshTokenRequest)

    if (refreshTokenResponse.1 as! HTTPURLResponse).statusCode == 200 {
      let newAuthorization = try JSONDecoder().decode(CurrentAuthorization.self, from: refreshTokenResponse.0)
      var secondRequest = URLRequest(url: url)
      secondRequest.httpMethod = httpMethod
      print()
      print(newAuthorization)
      print(newAuthorization.accessToken)
      print("-----")
      secondRequest.setValue("Bearer \(newAuthorization.accessToken)", forHTTPHeaderField: "Authorization")
      // notify login controller
      // store in keychain
      return try await urlSession.data(for: secondRequest)
    } else {
      let vaporError = try JSONDecoder().decode(LoginController.VaporError.self, from: refreshTokenResponse.0)
      throw vaporError
    }
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
