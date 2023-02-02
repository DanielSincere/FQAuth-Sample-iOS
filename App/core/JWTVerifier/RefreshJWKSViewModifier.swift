import SwiftUI

extension View {
  func refreshJWKSPeriodically(with verifier: JWTVerifier) -> some View {
    self.modifier(RefreshJWKSViewModifier(jwtVerifier: verifier))
  }
}

private struct RefreshJWKSViewModifier: ViewModifier {
  let jwtVerifier: JWTVerifier

  func body(content: Self.Content) -> some View {
    content
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
