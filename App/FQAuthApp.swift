import SwiftUI

@main
struct FQAuthApp: App {

  @StateObject
  var loginController = LoginController()

  var body: some Scene {
    WindowGroup {
      VStack {
        Text("hello")

        LoggedIn { currentAuthorization in
          RandomStringView()
        }
      }
      .environmentObject(loginController)
    }
  }
}


