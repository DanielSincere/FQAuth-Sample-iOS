import SwiftUI
import KeychainAccess

struct LoggedIn<Content: View>: View {
  @EnvironmentObject
  var loginController: LoginController

  let content: (CurrentAuthorization) -> Content

  var body: some View {
    if let currentAuthorization = loginController.currentAuthorization {
      content(currentAuthorization)
    } else {
      LoginView()
    }
  }
}
