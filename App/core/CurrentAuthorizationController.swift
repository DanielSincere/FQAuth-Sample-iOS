import Foundation
import KeychainAccess

final class CurrentAuthorizationController: ObservableObject {

  @Published internal private(set) var currentAuthorization: CurrentAuthorization?
  let keychain: KeychainInterface
  let jwtVerifier: JWTVerifierInterface

  init(keychain: KeychainInterface = Keychain(), jwtVerifier: JWTVerifierInterface) {
    self.keychain = keychain
    self.jwtVerifier = jwtVerifier
    self.currentAuthorization = keychain.currentAuthorization
  }

  func signOut() {
    self.keychain.currentAuthorization = nil
    self.currentAuthorization = nil
  }

  func login(_ currentAuthorization: CurrentAuthorization) throws {

    _ = try jwtVerifier.verify(jwt: currentAuthorization.accessToken)

    self.currentAuthorization = currentAuthorization
    self.keychain.currentAuthorization = currentAuthorization
  }
}
