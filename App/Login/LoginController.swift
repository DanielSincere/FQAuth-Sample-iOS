import Foundation
import AuthenticationServices

final class LoginController: ObservableObject {

  @Published var currentUser: User?

  func signOut() {
    
  }

  func onSignIn(request: ASAuthorizationAppleIDRequest) {
    
  }

  func onSignIn(result: Result<ASAuthorization, Error>) {
    
  }
}


