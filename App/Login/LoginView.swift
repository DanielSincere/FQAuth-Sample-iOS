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
    if let user = loginController.currentUser {
      VStack {
        Text("Signed in as \(user.name)!")
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

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LoginView()
        .environmentObject(LoginController(currentUser: nil))

      LoginView()
        .environmentObject(LoginController(currentUser: User(id: .init(), name: "Person Sample", accessToken: "my-access-token", refreshToken: "my-refresh-token")))
    }
  }
}
