import XCTest
@testable import App
import Foundation
import JWTKit

final class JWTVerifierTests: XCTestCase {

  func testOnLoad_FetchesAndStoresJWKSfromTheServer() async throws {
    let urlSession = FakeURLSession()
    urlSession.addStub(status: 200, url: "/api/jwks/public", data: JWKSFixtures.sample1.data)

    let verifier = JWTVerifier(urlSession: urlSession)
    try await verifier.fetchKeySet()
    XCTAssertNotNil(verifier.keySet)
  }

  func testVerifyFQAuthSessionTokenUsingStoredJWKs() throws {
    let urlSession = FakeURLSession()
    let verifier = JWTVerifier(keySet: JWKSFixtures.sample1.decoded,
                               urlSession: urlSession)

    let token: FQAuthSessionToken = try verifier.verify(jwt: FQAuthSessionTokenFixtures.sample1.rawValue)
    XCTAssertEqual(token.iss.value, "com.fullqueuedeveloper.FQAuth")
  }

  func testVerifyThrowsWhenMissingJWKS() throws {

    let verifier = JWTVerifier(keySet: nil,
                               urlSession: FakeURLSession())

    XCTAssertThrowsError(try verifier.verify(jwt: "SessionTokenFixture.sample1")) { error in

      guard let e = error as? JWTVerifier.Errors else {
        XCTFail("unexpected error \(error.localizedDescription)")
        return
      }

      switch e {
      case .missingJWKS:
        break // success
      }
    }
  }

  func testVerifyFreshlySignedToken() throws {
    let sample: FQAuthSessionTokenFixtures = .sample1
    let newExpiration = Date(timeIntervalSinceNow: 600)
    let (token, jwks) = try sample.freshlySign(newExpiration: newExpiration)

    let verifier = JWTVerifier(keySet: jwks,
                               urlSession: FakeURLSession())
    XCTAssertNoThrow(try verifier.verify(jwt: token))
  }
}

