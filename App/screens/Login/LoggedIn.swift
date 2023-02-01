import SwiftUI

struct LoggedIn<Content: View>: View {
  @EnvironmentObject
  var currentAuthController: CurrentAuthorizationController

  let content: (CurrentAuthorization) -> Content

  var body: some View {
    if let currentAuthorization = currentAuthController.currentAuthorization {
      content(currentAuthorization)
    } else {
      LoginView(loginController: LoginController(currentAuthController: currentAuthController ))
    }
  }
}

#if DEBUG
struct LoggedIn_Previews: PreviewProvider {

  static let currentAuth = CurrentAuthorization(
    user: User(id: .init(),
               firstName: "Person",
               lastName: "Sample"),
    refreshToken: "my-refresh-token",
    accessToken: "my-access-token")

  static var previews: some View {
    Group {
      LoggedIn() { auth in
        Text("If you see this it's an error")
      }
      .environmentObject(CurrentAuthorizationController(keychain: FakeKeychain()))

      LoggedIn() { auth in
        Text("Success! Logged in as \(auth.user.fullName)")
      }
      .environmentObject(CurrentAuthorizationController(keychain: FakeKeychain(currentAuthorization: currentAuth)))
    }
  }
}
#endif
