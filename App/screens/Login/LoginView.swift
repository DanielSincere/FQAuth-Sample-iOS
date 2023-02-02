import SwiftUI
import AuthenticationServices

public struct LoginView: View {

  @ObservedObject
  var loginController: LoginController

  @State var error: ErrorAtInstant?

  struct ErrorAtInstant: Identifiable {
    let error: Error
    let id: Date
  }

  public var body: some View {
    VStack {

      Text("Random string login").font(.title)
      Spacer()

      if let error = error {
        Text("Error")
        Text(error.error.localizedDescription)
      }

      SignInWithAppleButton { req in
        loginController.onSignIn(request: req)
      } onCompletion: { (result: Result<ASAuthorization, Error>) in
        Task {
          do {
            try await loginController.onSignIn(result: result)
          } catch {
            await MainActor.run {
              self.error = ErrorAtInstant(error: error, id: Date())
            }
          }
        }
      }
      .frame(height: 50)
      .padding()

      Spacer()

    }
  }
}

#if DEBUG

struct LoginView_Previews: PreviewProvider {

  static var emptyLoginController: LoginController {
    LoginController(currentAuthController: CurrentAuthorizationController(jwtVerifier: .fake))
  }

  static var previews: some View {
    Group {
      LoginView(loginController: emptyLoginController)
    }
  }
}
#endif
