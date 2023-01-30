import Foundation

#if DEBUG
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

  func addStub(status: Int, url: String) {
    let response = HTTPURLResponse(url: URL(string: url)!,
                                   statusCode: status,
                                   httpVersion: nil,
                                   headerFields: nil)!
    self.stubs.append((Data(), response))
  }

  func addRefreshTokenStub(with accessToken: String) {

    let auth = CurrentAuthorization(user: .init(id: .init(),
                                                firstName: "First",
                                                lastName: "Last"),
                                    refreshToken: "new-refresh-token",
                                    accessToken: accessToken)

    let url = URL(string: "\(authServerURL)/api/token")!
    let stub = (
      try! JSONEncoder().encode(auth),
      HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    )

    self.stubs.append(stub)
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

  enum Errors: Error, LocalizedError, Equatable {
    case stubsAreEmpty // add more responses
    case receivedArgsIndexOutOfBounds(Int)
    case requestURLMissing

    var errorDescription: String? {
      switch self {
      case .stubsAreEmpty: return "stubs are empty"
      case .receivedArgsIndexOutOfBounds(let index):
        return "receivedArgsIndexOutOfBounds \(index)"
      case .requestURLMissing: return "request url is missing"
      }
    }
  }
}
#endif
