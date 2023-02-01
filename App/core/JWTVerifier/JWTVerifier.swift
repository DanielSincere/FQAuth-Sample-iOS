import Foundation
import JWTKit

final class JWTVerifier {

  var keySet: JWKS?
  let keychain: KeychainInterface
  let urlSession: URLSessionInterface
  init(keychain: KeychainInterface, urlSession: URLSessionInterface) {
    self.urlSession = urlSession
    self.keychain = keychain

    if !(keychain.jwks?.keys.isEmpty ?? true) {
      self.keySet = keychain.jwks
    }
  }

  func fetchKeySet() async throws {
    let request = URLRequest(url: URL(string: "/api/jwks/public", relativeTo: authServerURL)!)
    let (data, _) = try await urlSession.data(for: request)

    let keySet = try JSONDecoder().decode(JWKS.self, from: data)
    guard !keySet.keys.isEmpty else {
      throw Errors.emptyJWKS
    }
    self.keychain.jwks = keySet
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

  enum Errors: Error, Equatable {
    case missingJWKS
    case emptyJWKS
  }
}
