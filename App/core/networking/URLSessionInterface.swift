import Foundation

protocol URLSessionInterface {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionInterface {

}
