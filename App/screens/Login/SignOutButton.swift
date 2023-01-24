import SwiftUI

public struct SignOutButton: View {

  @EnvironmentObject
  var loginController: LoginController

  public var body: some View {
    Button("Sign out", action: signOut)
      .buttonStyle(.borderedProminent)
  }

  private func signOut() {
    loginController.signOut()
  }
}

struct SignOutButton_Previews: PreviewProvider {
  static var previews: some View {
    SignOutButton()
      .environmentObject(LoginController())
  }
}
