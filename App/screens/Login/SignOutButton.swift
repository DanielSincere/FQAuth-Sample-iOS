import SwiftUI

public struct SignOutButton: View {

  @EnvironmentObject
  var currentAuthController: CurrentAuthorizationController

  public var body: some View {
    Button("Sign out", action: signOut)
      .buttonStyle(.borderedProminent)
  }

  private func signOut() {
    currentAuthController.signOut()
  }
}

struct SignOutButton_Previews: PreviewProvider {
  static var previews: some View {
    SignOutButton()
      .environmentObject(CurrentAuthorizationController())
  }
}
