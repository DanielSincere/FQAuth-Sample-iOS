import Foundation
import JWTKit

#if DEBUG
final class FakeKeychain: KeychainInterface {
  var currentAuthorization: CurrentAuthorization?
  var jwks: JWKS?

  init(currentAuthorization: CurrentAuthorization? = nil, jwks: JWKS? = nil) {
    self.currentAuthorization = currentAuthorization
    self.jwks = jwks
  }

  convenience init(currentAuthorizationFixture: CurrentAuthorizationFixtures) {
    self.init(currentAuthorization: currentAuthorizationFixture.decoded)
  }

  convenience init(jwksFixture: JWKSFixtures) {
    self.init(jwks: jwksFixture.decoded)
  }
}
#endif
