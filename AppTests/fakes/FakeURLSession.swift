import Foundation
@testable import App

final class FakeURLSession: URLSessionInterface {

  var dataFor: (Data, URLResponse)?
  var dataForRequest: URLRequest?
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {

    self.dataForRequest = request

    guard let requestUrl = request.url else {
      throw Errors.requestURLMissing
    }

    return dataFor ?? ("".data(using: .utf8)!, URLResponse(url: requestUrl, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))
  }

  enum Errors: Error {
    case fakeNotSetUp
    case requestURLMissing
  }
}
