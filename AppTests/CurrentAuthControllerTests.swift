import Foundation
import XCTest
@testable import App

final class CurrentAuthControllerTests: XCTestCase {

  func testReverifySignsOutWhenVerificationFails() {

    let keychain = FakeKeychain(sample: .sample1)
    let jwtVerifier = AlwaysFailingFakeJWTVerifier()
    let controller = CurrentAuthorizationController(keychain: keychain, jwtVerifier: jwtVerifier)

    controller.reverify()
    XCTAssertNil(keychain.currentAuthorization)
    XCTAssertNil(controller.currentAuthorization)
  }

  func testReverifyDoesNothingOnSuccess() {
    let keychain = FakeKeychain()//currentAuthorization: .sample1)
    let jwtVerifier = FakeJWTVerifier()
//    jwtVerifier.addStub(<#T##token: String##String#>, .sample1)
    let controller = CurrentAuthorizationController(keychain: keychain, jwtVerifier: jwtVerifier)

    controller.reverify()
    XCTAssertNil(keychain.currentAuthorization)
    XCTAssertNil(controller.currentAuthorization)
  }
}
