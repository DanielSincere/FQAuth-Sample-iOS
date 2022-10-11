import Foundation
import AuthenticationServices

extension LoginController {

  func handleAuthorization(result: Result<ASAuthorization, Error>) async throws -> User {
    switch result {
    case .failure(let failure):
      throw failure
    case .success(let authorization):
        guard let appleIdProvider = authorization.provider as? ASAuthorizationAppleIDProvider else {
          throw OnSignInErrors.nonAppleProvider
        }

        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
          throw OnSignInErrors.nonAppleCredential
        }

        guard let appleIDToken = appleIdCredential.identityToken else {
          throw OnSignInErrors.identityTokenMissing
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          throw OnSignInErrors.identityTokenCantDeserialize
        }

        guard let appleAuthorizationCode = appleIdCredential.authorizationCode else {
          throw OnSignInErrors.authorizationCodeMissing
        }

        guard let appleAuthorizationCodeString = String(data: appleAuthorizationCode, encoding: .utf8) else {
          throw OnSignInErrors.appleAuthorizationCodeCantDeserialize
        }

        guard let email = appleIdCredential.email else {
          throw OnSignInErrors.emailMissing
        }

        let body = SIWAAuthRequestBody(
          email: email,
          fullName: appleIdCredential.fullName,
          appleIdentityToken: idTokenString,
          authorizationCode: appleAuthorizationCodeString
        )


      let url = URL(string: "\(authServerURL)/api/auth/siwa")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")

      let (data, urlResponse) = try await URLSession.shared.data(for: request)
      let user = try JSONDecoder().decode(User.self, from: data)
      return user
    }
  }

  struct SIWAAuthRequestBody: Codable {
    let email: String
    let fullName: PersonNameComponents?
    let appleIdentityToken: String
    let authorizationCode: String
  }

  enum OnSignInErrors: Error {
    case nonAppleProvider
    case nonAppleCredential
    case identityTokenMissing
    case identityTokenCantDeserialize
    case authorizationCodeMissing
    case appleAuthorizationCodeCantDeserialize
    case emailMissing
  }
}
