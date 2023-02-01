import XCTest
@testable import App
import Foundation
import JWTKit

final class JWTVerifierTests: XCTestCase {

  func testOnLoad_FetchesAndStoresJWKSfromTheServer() async throws {
    let keychain = FakeKeychain()
    let urlSession = FakeURLSession()
    urlSession.addStub(status: 200, url: "/api/jwks/public", data: JWKSFixtures.sample1.data)

    let verifier = JWTVerifier(keychain: keychain, urlSession: urlSession)
    try await verifier.fetchKeySet()
    XCTAssertNotNil(verifier.keySet)
    let jwks: JWKS = try XCTUnwrap(keychain.jwks)
    XCTAssertFalse(jwks.keys.isEmpty)
  }

  func testRejectsJWKSWhenEmptyWhenLoadingFromServer() async throws {
    let keychain = FakeKeychain()
    let urlSession = FakeURLSession()
    urlSession.addStub(status: 200, url: "/api/jwks/public", data: JWKSFixtures.empty.data)
    let verifier = JWTVerifier(keychain: keychain, urlSession: urlSession)

    do {
      try await verifier.fetchKeySet()
      XCTFail("expected a throw")
    } catch {
      if let verifierError = error as? JWTVerifier.Errors {
        XCTAssertEqual(verifierError, .emptyJWKS)
      } else {
        XCTFail("unexpected error \(error.localizedDescription)")
      }
    }

    XCTAssertNil(verifier.keySet)
  }

  func testRejectsJWKSWhenEmptyWhenLoadingFromKeychain() throws {
    let keychain = FakeKeychain(sample: .empty)
    let verifier = JWTVerifier(keychain: keychain,
                               urlSession: FakeURLSession())
    XCTAssertNil(verifier.keySet)
  }

  func testOnInitFetchJWKSFromKeychain() throws {
    let keychain = FakeKeychain(sample: .sample1)
    let verifier = JWTVerifier(keychain: keychain,
                               urlSession: FakeURLSession())

    let keySet = try XCTUnwrap(verifier.keySet)
    let key = try XCTUnwrap(keySet.find(identifier: "auth-public-key")?.first)

    XCTAssertEqual(key.x, "ATHID-n4Pc0E2BzaZZHsD1NOQp25z5hhnFK96A7WMvH8-WZI_AalrCxxtqUZrzScNLnnoi4Zi0p-CcEUikSowQEY")
  }

  func testVerifyFQAuthSessionTokenUsingStoredJWKs() throws {

    let verifier = JWTVerifier(keychain: FakeKeychain(sample: .sample1),
                               urlSession: FakeURLSession())

    let token: FQAuthSessionToken = try verifier.verify(jwt: FQAuthSessionTokenFixtures.sample1.rawValue)
    XCTAssertEqual(token.iss.value, "com.fullqueuedeveloper.FQAuth")
  }

  func testVerifyThrowsWhenMissingJWKS() throws {

    let verifier = JWTVerifier(keychain: FakeKeychain(),
                               urlSession: FakeURLSession())

    XCTAssertThrowsError(try verifier.verify(jwt: "SessionTokenFixture.sample1")) { error in

      if let verifierError = error as? JWTVerifier.Errors {
        XCTAssertEqual(verifierError, .missingJWKS)
      } else {
        XCTFail("unexpected error \(error.localizedDescription)")
      }
    }
  }

  func testVerifyFreshlySignedToken() throws {
    let sample: FQAuthSessionTokenFixtures = .sample1
    let newExpiration = Date(timeIntervalSinceNow: 600)
    let (token, jwks) = try sample.freshlySign(newExpiration: newExpiration)

    let verifier = JWTVerifier(keychain: FakeKeychain(jwks: jwks),
                               urlSession: FakeURLSession())
    XCTAssertNoThrow(try verifier.verify(jwt: token))
  }
}
