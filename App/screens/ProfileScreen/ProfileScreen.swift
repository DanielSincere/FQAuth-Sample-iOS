import SwiftUI

struct ProfileScreen: View {

  var body: some View {
    LoggedIn { currentAuthorization in
      VStack {
        Spacer()
        Text("Signed in as").bold()
        Text(currentAuthorization.user.fullName)
        Spacer()
        SignOutButton()
      }
    }
    .navigationTitle("Profile screen")
  }
}
