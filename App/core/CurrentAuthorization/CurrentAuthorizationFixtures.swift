import Foundation
import JWTKit

#if DEBUG
enum CurrentAuthorizationFixtures: String {
  case sample1 = """
  {}
  """

  var decoded: CurrentAuthorization {
    let userID = UUID()

    let (accessToken, _) = try! FQAuthSessionTokenFixtures.sample1.freshlySign(newExpiration: Date(timeIntervalSinceNow: 10000))

    return CurrentAuthorization(user: User(id: userID,
                                           firstName: "Sample",
                                           lastName: "O'Samples"),
                                refreshToken: "arst",
                                accessToken: accessToken)
  }
}
#endif
