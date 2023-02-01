import Foundation
import JWTKit

final class JWTVerifier {

  var keySet: JWKS?
  let urlSession: URLSessionInterface
  init(keySet: JWKS? = nil, urlSession: URLSessionInterface) {
    self.keySet = keySet
    self.urlSession = urlSession
  }

  func fetchKeySet() async throws {
    let request = URLRequest(url: URL(string: "/api/jwks/public", relativeTo: authServerURL)!)
    let (data, _) = try await urlSession.data(for: request)

    let keySet = try JSONDecoder().decode(JWKS.self, from: data)
    self.keySet = keySet
  }

  func verify(jwt: String) throws -> FQAuthSessionToken {

    guard let keySet = keySet else {
      throw Errors.missingJWKS
    }

    let signers = JWTSigners()
    try signers.use(jwks: keySet)

    return try signers.verify(jwt, as: FQAuthSessionToken.self)
  }

  enum Errors: Error {
    case missingJWKS
  }
}
