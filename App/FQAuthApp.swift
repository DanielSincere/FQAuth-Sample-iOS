import SwiftUI

@main
struct FQAuthApp: App {

  @StateObject
  var loginController = LoginController()

  @State
  var currentRoute: NavigationPath = NavigationPath()

  var body: some Scene {
    WindowGroup {
      LoggedIn { currentAuthorization in
        NavigationStack(path: $currentRoute) {

          RandomStringView(currentRoute: $currentRoute)
            .navigationDestination(for: AppRoute.self) { appRoute in
              switch appRoute {
              case .randomString:
                RandomStringView(currentRoute: $currentRoute)
              case .profile:
                ProfileScreen()
              }
            }
        }
      }
      .environmentObject(loginController)
    }
  }
}
