import Foundation
import KeychainAccess

extension Keychain {

  private static let currentAuthorizationKey = "com.fullqueuedeveloper.keychain.current-authorization"
  convenience init(currentAuthorization: CurrentAuthorization?) {
    self.init()
    self.currentAuthorization = currentAuthorization
  }
  var currentAuthorization: CurrentAuthorization? {
    get {
      guard let data = self[data: Self.currentAuthorizationKey] else {
        return nil
      }

      do {
        return try JSONDecoder().decode(CurrentAuthorization.self, from: data)
      } catch {
        print("error decoding Current Authorization from keychain", error)
        return nil
      }
    }
    set {
      do {
        let newData = try JSONEncoder().encode(newValue)
        self[data: Self.currentAuthorizationKey] = newData
      } catch {
        print("error encoding user for keychain", error)
      }
    }
  }
}
