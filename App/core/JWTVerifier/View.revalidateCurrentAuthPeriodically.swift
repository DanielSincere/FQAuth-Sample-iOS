import SwiftUI

extension View {
  func revalidateCurrentAuthPeriodically(
    currentAuthController: CurrentAuthorizationController,
    jwtVerifier: JWTVerifier) -> some View {

    self
      .task {
        guard let token = currentAuthController.currentAuthorization?.accessToken else {
          return
        }

        do {
          _ = try jwtVerifier.verify(jwt: token)
        } catch {
          currentAuthController.signOut()
        }
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification), perform: { _ in
        
        guard let token = currentAuthController.currentAuthorization?.accessToken else {
          return
        }

        do {
          _ = try jwtVerifier.verify(jwt: token)
        } catch {
          currentAuthController.signOut()
        }
      })
  }
}
