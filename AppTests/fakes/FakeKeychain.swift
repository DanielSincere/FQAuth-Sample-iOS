import Foundation
@testable import App

final class FakeKeychain: KeychainInterface {
  var currentAuthorization: App.CurrentAuthorization?
}
