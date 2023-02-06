import SwiftUI

extension View {
  func revalidateCurrentAuthPeriodically(currentAuthController: CurrentAuthorizationController) -> some View {

    self
      .task {
        await currentAuthController.reverify()
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification), perform: { _ in
        Task {
          await currentAuthController.reverify()
        }
      })
  }
}
