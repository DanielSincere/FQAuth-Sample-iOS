import Foundation
import AuthenticationServices

final class LoginController: ObservableObject {
  
  @Published var currentLoginAttempt: LoginAttempt? = nil

  let currentAuthController: CurrentAuthorizationController
  init(currentAuthController: CurrentAuthorizationController) {
    self.currentAuthController = currentAuthController
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
    let authorization = try await self.handleAuthorization(result: result,
                                                  currentLoginAttempt: currentLoginAttempt)
    await MainActor.run {
      currentAuthController.login(authorization)
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
