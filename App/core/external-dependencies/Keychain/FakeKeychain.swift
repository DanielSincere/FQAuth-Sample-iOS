import Foundation
import JWTKit

#if DEBUG
final class FakeKeychain: KeychainInterface {
  var currentAuthorization: App.CurrentAuthorization?
  var jwks: JWKS?
}
#endif
