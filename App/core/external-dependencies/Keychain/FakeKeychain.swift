import Foundation
import JWTKit

#if DEBUG
final class FakeKeychain: KeychainInterface {
  var currentAuthorization: App.CurrentAuthorization?
  var jwks: JWKS?

  init(currentAuthorization: App.CurrentAuthorization? = nil, jwks: JWKS? = nil) {
    self.currentAuthorization = currentAuthorization
    self.jwks = jwks
  }

  convenience init(sample: JWKSFixtures) {
    self.init(jwks: sample.decoded)
  }
}
#endif
