import Foundation
import SwiftUI

struct RandomStringScreen: View {
  @EnvironmentObject var networking: FQNetworking
  @EnvironmentObject var currentAuthController: CurrentAuthorizationController
  @Binding var currentRoute: NavigationPath

  var body: some View {

    RandomStringView(controller: RandomStringController(networking: networking),
                     currentRoute: $currentRoute)
  }
}
