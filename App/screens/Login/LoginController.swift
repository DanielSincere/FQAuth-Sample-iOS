import Foundation
import AuthenticationServices
import KeychainAccess

final class LoginController: ObservableObject {

  @Published var currentAuthorization: CurrentAuthorization?
  
  @Published var currentLoginAttempt: LoginAttempt? = nil

  init(currentAuthorization: CurrentAuthorization? = Keychain().currentAuthorization) {
    self.currentAuthorization = currentAuthorization
  }

  func signOut() {
    Keychain().currentAuthorization = nil
    self.currentAuthorization = nil
  }

  func onSignIn(request: ASAuthorizationAppleIDRequest) {
    let loginAttempt = LoginAttempt()
    self.currentLoginAttempt = loginAttempt
    request.requestedScopes = [.fullName, .email]
    request.state = loginAttempt.state
    request.nonce = loginAttempt.nonce
  }

  func onSignIn(result: Result<ASAuthorization, Error>) async throws {
    guard let currentLoginAttempt = currentLoginAttempt else {
      throw OnSignInErrors.receivedSignInCallbackWithoutCurrentLoginAttempt
    }
    let user = try await self.handleAuthorization(result: result,
                                                  currentLoginAttempt: currentLoginAttempt)
    await MainActor.run {
      self.currentAuthorization = user
      Keychain().currentAuthorization = user
    }
  }
  
  struct LoginAttempt {
    let state: String
    let nonce: String
    
    init() {
      self.state = UUID().uuidString
      self.nonce = UUID().uuidString
    }
  }
}
