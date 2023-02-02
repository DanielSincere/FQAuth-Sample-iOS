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
      .refreshJWKSPeriodically(with: jwtVerifier)
      .revalidateCurrentAuthPeriodically(
        currentAuthController: currentAuthController,
        jwtVerifier: jwtVerifier)
    }
  }

  init() {
    let keychain = Keychain()
    let urlSession = URLSession.shared
    let jwtVerifier = JWTVerifier(keychain: keychain, urlSession: urlSession)

    let currentAuthController = CurrentAuthorizationController(
      keychain: keychain,
      jwtVerifier: jwtVerifier)

    self.networking = FQNetworking(urlSession: urlSession,
                                   currentAuthController: currentAuthController)
    self.currentAuthController = currentAuthController
    self.jwtVerifier = jwtVerifier
  }
}
