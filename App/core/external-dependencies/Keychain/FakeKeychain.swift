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

  convenience init(sample: JWKSFixtures) {
    self.init(jwks: sample.decoded)
  }
}
#endif
