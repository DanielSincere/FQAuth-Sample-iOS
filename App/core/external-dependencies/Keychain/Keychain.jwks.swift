import Foundation
import KeychainAccess
import JWTKit

extension Keychain {

  private static let jwksKey = "com.fullqueuedeveloper.keychain.jwks"

  var jwks: JWKS? {
    get {
      guard let data = self[data: Self.jwksKey] else {
        return nil
      }

      do {
        return try JSONDecoder().decode(JWKS.self, from: data)
      } catch {
        print("error decoding JWKS from keychain", error)
        return nil
      }
    }
    set {
      do {
        let data = try JSONEncoder().encode(newValue)
        self[data: Self.jwksKey] = data
      } catch {
        print("error encoding JWKS from keychain", error)
      }
    }
  }
}
