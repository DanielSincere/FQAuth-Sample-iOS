import SwiftUI
import AuthenticationServices

public struct LoginView: View {

  @EnvironmentObject
  var loginController: LoginController

  public var body: some View {

    if let user = loginController.currentUser {
      VStack {
        Text("Signed in as \(user.name)!")
        Button("Sign out") {
          loginController.signOut()
        }
      }
    } else {

      SignInWithAppleButton { req in
        loginController.onSignIn(request: req)
      } onCompletion: { (result: Result<ASAuthorization, Error>) in
        loginController.onSignIn(result: result)
      }
      .frame(height: 50)
      .padding()
    }
  }
}
