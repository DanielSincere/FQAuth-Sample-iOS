import SwiftUI

extension View {
  func revalidateCurrentAuthPeriodically(currentAuthController: CurrentAuthorizationController) -> some View {

    self
      .task {
        currentAuthController.reverify()
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification), perform: { _ in
        currentAuthController.reverify()
      })
  }
}
