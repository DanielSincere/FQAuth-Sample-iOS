import Foundation
import SwiftUI

struct RandomStringScreen: View {
  @EnvironmentObject var networkingHelper: NetworkingHelper
  @EnvironmentObject var currentAuthController: CurrentAuthorizationController
  @Binding var currentRoute: NavigationPath

  var body: some View {

    RandomStringView(controller: RandomStringController(networkingHelper: networkingHelper),
                     currentRoute: $currentRoute)
  }
}
