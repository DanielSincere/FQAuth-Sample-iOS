import Foundation
import KeychainAccess

final class CurrentAuthorizationController: ObservableObject {

  @Published internal private(set) var currentAuthorization: CurrentAuthorization?
  let keychain: KeychainInterface

  init(keychain: KeychainInterface = Keychain()) {
    self.keychain = keychain
    self.currentAuthorization = keychain.currentAuthorization
  }

  init(currentAuthorization: CurrentAuthorization?) {
    let keychain = Keychain(currentAuthorization: currentAuthorization)
    self.keychain = keychain
    self.currentAuthorization = currentAuthorization
  }

  func signOut() {
    self.keychain.currentAuthorization = nil
    self.currentAuthorization = nil
  }

  func login(_ currentAuthorization: CurrentAuthorization) {
    self.currentAuthorization = currentAuthorization
    self.keychain.currentAuthorization = currentAuthorization
  }
}
