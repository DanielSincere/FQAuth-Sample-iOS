import Foundation
import JWTKit

#if DEBUG
enum JWKSFixtures: String {
  case sample1 =
  """
  {"keys":[{"kid":"auth-public-key","crv":"P-521","y":"nPkvuqtwOTLc3PJcbI3XmmEV-x56zM_VMOEPHE0Yt0LiOyb_8PAYHV0Ori7YEdeijtj6l-pOER-33KUf5vzxOfA","x":"ATHID-n4Pc0E2BzaZZHsD1NOQp25z5hhnFK96A7WMvH8-WZI_AalrCxxtqUZrzScNLnnoi4Zi0p-CcEUikSowQEY","kty":"EC","alg":"ES512"}]}
  """
  case empty =
  """
  {"keys": []}
  """

  var data: Data {
    rawValue.data(using: .utf8)!
  }
  var decoded: JWKS {
    try! JSONDecoder().decode(JWKS.self, from: data)
  }
}
#endif
