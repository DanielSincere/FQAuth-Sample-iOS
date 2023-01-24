import Foundation
import AuthenticationServices

extension LoginController {
  
  func handleAuthorization(result: Result<ASAuthorization, Error>, currentLoginAttempt: LoginAttempt) async throws -> CurrentAuthorization {
    switch result {
    case .failure(let failure):
      throw failure
    case .success(let authorization):

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
      
      guard appleIdCredential.state == currentLoginAttempt.state else {
        throw OnSignInErrors.generatedStateDoenstMatchReceivedState
      }

      let body = SIWAAuthRequestBody(
        email: appleIdCredential.email,
        firstName: appleIdCredential.fullName?.givenName,
        lastName: appleIdCredential.fullName?.familyName,
        deviceName: await UIDevice.current.name,
        appleIdentityToken: idTokenString,
        authorizationCode: appleAuthorizationCodeString
      )
      
      let url = URL(string: "/api/siwa/authorize", relativeTo: authServerURL)!.absoluteURL
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = try JSONEncoder().encode(body)
      
      let (data, urlResponse) = try await URLSession.shared.data(for: request)
      if (urlResponse as! HTTPURLResponse).statusCode == 200 {
        return try JSONDecoder().decode(CurrentAuthorization.self, from: data)
      } else {
        let vaporError = try JSONDecoder().decode(VaporError.self, from: data)
        throw vaporError
      }
    }
  }
  
  struct VaporError: Decodable, Error, LocalizedError {
    let reason: String
    
    var errorDescription: String? { "Server error: " + reason }
  }
  
  struct SIWAAuthRequestBody: Encodable {
    let email: String?
    let firstName: String?
    let lastName: String?
    let deviceName: String
    let appleIdentityToken: String
    let authorizationCode: String
  }
  

  enum OnSignInErrors: Error, LocalizedError {
    case nonAppleCredential
    case identityTokenMissing
    case identityTokenCantDeserialize
    case authorizationCodeMissing
    case appleAuthorizationCodeCantDeserialize
    case emailMissing
    case firstNameMissing
    case lastNameMissing
    
    case receivedSignInCallbackWithoutCurrentLoginAttempt
    case generatedStateDoenstMatchReceivedState
    
    var errorDescription: String? {
      switch self {

      case .nonAppleCredential:
        return "non-Apple credential"
      case .identityTokenMissing:
        return "identity token missing"
      case .identityTokenCantDeserialize:
        return "identy token can't deserialize"
      case .authorizationCodeMissing:
        return "authorization code missing"
      case .appleAuthorizationCodeCantDeserialize:
        return "Apple authorization code can't deserialize"
      case .emailMissing:
        return "Email missing"
      case .firstNameMissing:
        return "First name missing"
      case .lastNameMissing:
        return "Last name missing"
        
      case .receivedSignInCallbackWithoutCurrentLoginAttempt:
        return "Internal state error, try again"
      case .generatedStateDoenstMatchReceivedState:
        return "3rd-party tampering detected"
      }
    }
  }
}