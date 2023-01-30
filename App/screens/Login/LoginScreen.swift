import Foundation
import SwiftUI

struct LoginScreen: View {

  @EnvironmentObject var currentAuthController: CurrentAuthorizationController
  
  var body: some View {
    if let currentAuthorization = currentAuthController.currentAuthorization {
      SignedInView(currentAuthorization: currentAuthorization)
    } else {
      LoginView(loginController: LoginController(currentAuthController: currentAuthController))
    }
  }
}
