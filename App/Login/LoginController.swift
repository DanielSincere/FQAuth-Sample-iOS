import Foundation
import AuthenticationServices
import KeychainAccess

final class LoginController: ObservableObject {

  @Published var currentUser: User?

  init(currentUser: User? = Keychain().currentUser) {
    self.currentUser = currentUser
  }

  func signOut() {
    Keychain().currentUser = nil
    self.currentUser = nil
  }

  func onSignIn(request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
  }

  func onSignIn(result: Result<ASAuthorization, Error>) async throws {
    let user = try await self.handleAuthorization(result: result)
    await MainActor.run {
      self.currentUser = user
      Keychain().currentUser = user
    }
  }


}
