import Foundation
import KeychainAccess

protocol KeychainInterface {
  var currentAuthorization: CurrentAuthorization? { get set }
}

extension Keychain: KeychainInterface { }
