import Foundation

#if DEBUG
final class FakeKeychain: KeychainInterface {
  var currentAuthorization: App.CurrentAuthorization?
}
#endif
