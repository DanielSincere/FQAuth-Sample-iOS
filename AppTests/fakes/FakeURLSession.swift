import Foundation
@testable import App

final class FakeURLSession: URLSessionInterface {

  var stubs: [(Data, HTTPURLResponse)] = []
  var receivedArgs: [URLRequest] = []

  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    self.receivedArgs.append(request)

    guard let next = stubs.first else {
      throw Errors.stubsAreEmpty
    }

    self.stubs = Array(stubs.dropFirst())
    return next
  }

  static func defaultForbidden(for url: URL) -> (Data, HTTPURLResponse) {(
    "".data(using: .utf8)!,
    HTTPURLResponse(url: url, statusCode: 403, httpVersion: nil, headerFields: nil)!
  )}

  static func defaultSuccess(for url: URL) -> (Data, HTTPURLResponse) { (
    "".data(using: .utf8)!,
    HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
  )}

  static func successTokenResponse(for url: URL, accessToken: String = "new-access-token") -> (Data, HTTPURLResponse) {

    let auth = CurrentAuthorization(user: .init(id: .init(),
                                                firstName: "First",
                                                lastName: "Last"),
                                    refreshToken: "new-refresh-token",
                                    accessToken: accessToken)

    return (
      try! JSONEncoder().encode(auth),
      HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    )
  }

  enum Errors: Error, LocalizedError {
    case stubsAreEmpty // add more responses
    case requestURLMissing

    var errorDescription: String? {
      switch self {
      case .stubsAreEmpty: return "stubs are empty"
      case .requestURLMissing: return "request url is missing"
      }
    }
  }
}
