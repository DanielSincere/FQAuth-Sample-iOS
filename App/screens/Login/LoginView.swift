import SwiftUI
import AuthenticationServices

public struct LoginView: View {

  @EnvironmentObject var loginController: LoginController

  @State var error: ErrorAtInstant?

  struct ErrorAtInstant: Identifiable {
    let error: Error
    let id: Date
  }

  public var body: some View {
    if let currentAuthorization = loginController.currentAuthorization {
      VStack {
        Text("Signed in as \(currentAuthorization.user.fullName)!")
        Button("Sign out") {
          loginController.signOut()
        }
      }
    } else {
      VStack {
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
      }
    }
  }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LoginView()
        .environmentObject(LoginController(currentAuthorization: nil))

      LoginView()
        .environmentObject(LoginController(currentAuthorization:
                                            CurrentAuthorization(user: User(id: .init(), firstName: "Person", lastName: "Sample"),
                                                                 refreshToken: "my-refresh-token",
                                                                 accessToken: "my-access-token")))
    }
  }
}
#endif
