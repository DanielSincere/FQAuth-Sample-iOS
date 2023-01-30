import Foundation
import KeychainAccess

protocol KeychainInterface: AnyObject {
  var currentAuthorization: CurrentAuthorization? { get set }
}

extension Keychain: KeychainInterface { }
