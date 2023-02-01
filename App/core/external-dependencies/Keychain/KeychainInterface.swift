import Foundation
import KeychainAccess
import JWTKit

protocol KeychainInterface: AnyObject {
  var currentAuthorization: CurrentAuthorization? { get set }
  var jwks: JWKS? { get set }
}

extension Keychain: KeychainInterface { }
