import Foundation
import SwiftUI

struct SignedInView: View {
  @EnvironmentObject var currentAuthController: CurrentAuthorizationController
  let currentAuthorization: CurrentAuthorization

  var body: some View {
    VStack {
      Text("Signed in as \(currentAuthorization.user.fullName)!")
      Button("Sign out") {
        currentAuthController.signOut()
      }
    }
  }
}
