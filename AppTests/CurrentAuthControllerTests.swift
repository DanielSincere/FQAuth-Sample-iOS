import Foundation
import XCTest
@testable import App

final class CurrentAuthControllerTests: XCTestCase {

  func testReverifySignsOutWhenVerificationFails() async {

    let keychain = FakeKeychain(currentAuthorizationFixture: .sample1)
    let jwtVerifier = AlwaysFailingFakeJWTVerifier()
    let controller = await CurrentAuthorizationController(keychain: keychain, jwtVerifier: jwtVerifier)

    await controller.reverify()
    XCTAssertNil(keychain.currentAuthorization)
    let controllerCurrentAuth = await controller.currentAuthorization
    XCTAssertNil(controllerCurrentAuth)
  }

  func testReverifyDoesNothingOnSuccess() async {
    let keychain = FakeKeychain(currentAuthorizationFixture: .sample1)
    let jwtVerifier = FakeJWTVerifier()
    let controller = await CurrentAuthorizationController(keychain: keychain, jwtVerifier: jwtVerifier)

    await controller.reverify()
    XCTAssertNotNil(keychain.currentAuthorization)
    let controllerCurrentAuth = await controller.currentAuthorization
    XCTAssertNotNil(controllerCurrentAuth)
    XCTAssertEqual(keychain.currentAuthorization?.accessToken, controllerCurrentAuth?.accessToken)
  }

  func testReverifyDoesNothingWhenKeychainIsEmpty() async {
    let keychain = FakeKeychain()
    let jwtVerifier = FakeJWTVerifier()
    let controller = await CurrentAuthorizationController(keychain: keychain, jwtVerifier: jwtVerifier)

    await controller.reverify()
    XCTAssertNil(keychain.currentAuthorization)
    let controllerCurrentAuth = await controller.currentAuthorization
    XCTAssertNil(controllerCurrentAuth)
  }
}
