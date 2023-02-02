import Foundation
import JWTKit

#if DEBUG
final class FakeJWTVerifier: JWTVerifierInterface {

  var stubs: [String: FQAuthSessionTokenFixtures] = [:]
  func addStub(_ token: String, _ fixture: FQAuthSessionTokenFixtures) {
    stubs[token] = fixture
  }

  func verify(jwt: String) throws -> FQAuthSessionToken {
    if let stub = stubs[jwt] {
      let (newToken, _) = try stub.freshlySign(newExpiration: Date())
      return try JWTSigners().unverified(newToken)
    }
    return try JWTSigners().unverified(jwt)
  }
}

extension JWTVerifierInterface where Self == FakeJWTVerifier {
  static var fake: FakeJWTVerifier { FakeJWTVerifier() }
}

#endif
