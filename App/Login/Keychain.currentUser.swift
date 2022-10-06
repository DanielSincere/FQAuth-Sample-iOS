import Foundation
import KeychainAccess

extension Keychain {

  private static let keychainKey = "com.fullqueuedeveloper.fqauth-sample-ios.current-user"

  var currentUser: User? {
    get {
      guard let data = self[data: Self.keychainKey] else {
        return nil
      }

      do {
        return try JSONDecoder().decode(User.self, from: data)
      } catch {
        print("error decoding user from keychain", error)
        return nil
      }
    }
    set {
      do {
        let newData = try JSONEncoder().encode(newValue)
        self[data: Self.keychainKey] = newData
      } catch {
        print("error encoding user for keychain", error)
      }
    }
  }
}
