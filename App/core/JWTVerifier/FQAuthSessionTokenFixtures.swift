import Foundation
import JWTKit

#if DEBUG
enum FQAuthSessionTokenFixtures: String {
  case sample1 = "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6ImF1dGgtcHJpdmF0ZS1rZXkifQ.eyJleHAiOjE2Nzc4NzQ3MTUuMzM0OTcyOSwiZGV2aWNlTmFtZSI6ImlQaG9uZSIsImlzcyI6ImNvbS5mdWxscXVldWVkZXZlbG9wZXIuRlFBdXRoIiwic3ViIjoiOTQ3NkUyNTMtRDg0Qi00N0NELUJFRjktREEzRTU4NTNDQTdFIiwiaWF0IjoxNjc1MjgyNzE1LjMzNDk3NX0.AaFKcBQEd49uduRpjClWRUICURITlAyaO0hGDqO7v1AOSjAYduUpK52Y6Vt1XPSTnzpltDx9znaZpXs2ysvieet6AMzlv6cbSlr28Y3Bxq80dSE6td86u3aX3kbjnp3aCP1v5mgarwhvKqKwPqfuMLL4uaYZVE_jTCRvwfpQwgkhn2sJ"

  func freshlySign(newExpiration: Date) throws -> (token: String, JWKS) {

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
#endif
