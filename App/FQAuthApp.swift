import SwiftUI
import KeychainAccess

@main
struct FQAuthApp: App {

  @ObservedObject
  var currentAuthController: CurrentAuthorizationController

  var networking: FQNetworking

  var jwtVerifier: JWTVerifier

  @State
  var currentRoute: NavigationPath = NavigationPath()

  var body: some Scene {
    WindowGroup {
      LoggedIn { currentAuthorization in
        NavigationStack(path: $currentRoute) {

          RandomStringScreen(currentRoute: $currentRoute)
            .navigationDestination(for: AppRoute.self) { appRoute in
              switch appRoute {
              case .randomString:
                RandomStringScreen(currentRoute: $currentRoute)
              case .profile:
                ProfileScreen()
              }
            }
        }
      }
      .environmentObject(currentAuthController)
      .environmentObject(networking)
    }
  }

  init() {
    let keychain = Keychain()
    let urlSession = URLSession.shared

    let currentAuthController = CurrentAuthorizationController(keychain: keychain)
    self.currentAuthController = currentAuthController
    self.networking = FQNetworking(urlSession: urlSession,
                                             currentAuthController: currentAuthController)

    self.jwtVerifier = JWTVerifier(urlSession: urlSession)
  }
}
