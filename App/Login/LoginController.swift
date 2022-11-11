import Foundation
import AuthenticationServices
import KeychainAccess

final class LoginController: ObservableObject {

  @Published var currentAuthorization: CurrentAuthorization?

  init(currentAuthorization: CurrentAuthorization? = Keychain().currentAuthorization) {
    self.currentAuthorization = currentAuthorization
  }

  func signOut() {
    Keychain().currentAuthorization = nil
    self.currentAuthorization = nil
  }

  func onSignIn(request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]

  }

  func onSignIn(result: Result<ASAuthorization, Error>) async throws {
    let user = try await self.handleAuthorization(result: result)
    await MainActor.run {
      self.currentAuthorization = user
      Keychain().currentAuthorization = user
    }
  }
}
