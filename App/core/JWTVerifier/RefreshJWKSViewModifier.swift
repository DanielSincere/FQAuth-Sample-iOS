import SwiftUI

extension View {
  func refreshJWKSPeriodically(with jwtVerifier: JWTVerifier) -> some View {
    self
      .task {
      await jwtVerifier.refresh()
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification), perform: { _ in
      Task {
        await jwtVerifier.refresh()
      }
    })
  }
}
