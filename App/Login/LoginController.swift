import Foundation
import AuthenticationServices
import KeychainAccess

final class LoginController: ObservableObject {

  @Published var currentUser: User?

  init() {
    self.currentUser = Keychain().currentUser
  }

  init(currentUser: User?) {
    self.currentUser = currentUser
  }

  func signOut() {
    
  }

  func onSignIn(request: ASAuthorizationAppleIDRequest) {
    
  }

  func onSignIn(result: Result<ASAuthorization, Error>) {
    
  }
}
