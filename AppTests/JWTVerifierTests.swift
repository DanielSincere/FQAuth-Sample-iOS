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
      default:
        XCTFail("Unexpected error \(error.localizedDescription)")
      }
    }
  }

  func testVerifyFreshlySignedToken() throws {
    let (freshlySignedToken, jwks) = try freshlySign(sample: .sample1)
    let verifier = JWTVerifier(keySet: jwks,
                               urlSession: FakeURLSession())
    XCTAssertNoThrow(try verifier.verify(jwt: freshlySignedToken))
  }

  private func freshlySign(sample: FQAuthSessionTokenFixtures) throws -> (token: String, JWKS) {

    let privateKeyBase64 = "LS0tLS1CRUdJTiBFQyBQQVJBTUVURVJTLS0tLS0KQmdVcmdRUUFJdz09Ci0tLS0tRU5EIEVDIFBBUkFNRVRFUlMtLS0tLQotLS0tLUJFR0lOIEVDIFBSSVZBVEUgS0VZLS0tLS0KTUlIYkFnRUJCRUVDLzFLcUxVaDgzdXZ2ZWJnS0RvWTcvaVhWdkR0dGt3b3RPRjg1ck5yMzMxNnNxbEZHVEJoagppcmx1MHhua3hqY2hEeXpVV0E0QXBvNnpYekpKV1RKTU9hQUhCZ1VyZ1FRQUk2R0JpUU9CaGdBRUFkNURXaGFLClRwT1hhK21qaXgweG8xN1NGSGx4UG16YXdKWkJiRldXQ3dZMFZOSTdveGlBcHRLNlVtbWdlM3NBVkxSMitoQTcKTGsyRm9aSEltYmlEbUdrcUFLcTdyRUNmYjB2SHRmeWhXWEdydjBRMnZ1MTV1elF5ZldkNDhSV2ZEbEVadTE2eAp0aWV1aHpnSjJGWmI2bkMvb2dFYjk5TjNxajVWT0xTeXFzcnNQejlKCi0tLS0tRU5EIEVDIFBSSVZBVEUgS0VZLS0tLS0K"
    let signers = JWTSigners()

    let unverifiedSampleToken: FQAuthSessionToken = try signers.unverified(FQAuthSessionTokenFixtures.sample1.rawValue)

    let updatedSampleToken = unverifiedSampleToken.withUpdatedExpiration(newExpiration: Date(timeIntervalSinceNow: 600))
    let privateKey = try ECDSAKey.private(pem: Data(base64Encoded: privateKeyBase64)!)
    signers.use(.es512(key: privateKey))

    let resignedToken = try signers.sign(updatedSampleToken)

    let jwks = JWKS(keys: [.ecdsa(.es512,
                                  identifier: JWKIdentifier(string: "testJWKs"),
                                  x: privateKey.parameters?.x,
                                  y: privateKey.parameters?.y,
                                  curve: .p521,
                                  privateKey: nil)])

    return (resignedToken, jwks)
  }
}

private extension FQAuthSessionToken {
  func withUpdatedExpiration(newExpiration: Date) -> Self {
    .init(userID: self.userID!, deviceName: self.deviceName, expiration: ExpirationClaim(value: newExpiration), iss: self.iss)
  }
}
