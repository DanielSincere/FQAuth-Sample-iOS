import XCTest
@testable import App

final class FQNetworkingTests: XCTestCase {

  var urlSession: FakeURLSession!
  var keychain: FakeKeychain!
  var currentAuthController: CurrentAuthorizationController!
  var jwtVerifier: FakeJWTVerifier!
  override func setUpWithError() throws {
    urlSession = FakeURLSession()
    keychain = FakeKeychain()
    jwtVerifier = FakeJWTVerifier()

    keychain.currentAuthorization = CurrentAuthorization(
      user: .init(id: .init(),
                  firstName: "First",
                  lastName: "Last"),
      refreshToken: "existing-refresh-token",
      accessToken: "existing-access-token")

    jwtVerifier.addStub("existing-access-token", .sample1)
    jwtVerifier.addStub("new-access-token", .sample1)

    currentAuthController = CurrentAuthorizationController(keychain: keychain, jwtVerifier: jwtVerifier)
  }
  override func tearDownWithError() throws { }

  func testAuthorizationIsSetFromKeychain() async throws {

    urlSession.addStub(status: 200, url: "https://example.com")

    _ = try await FQNetworking(urlSession: urlSession,
                                   currentAuthController: currentAuthController)
      .authorizedRequest(url: URL(string: "https://example.com")!)

    XCTAssertEqual(urlSession.receivedArgs.first?.url, URL(string: "https://example.com")!)
    XCTAssertEqual(urlSession.receivedArgs.first?.value(forHTTPHeaderField: "Authorization"), "Bearer existing-access-token")
  }

  func testForbiddenResponseTriggersTokenRefreshAndRetry() async throws  {

    urlSession.addStub(status: 403, url: "https://example.com/api/endpoint")
    urlSession.addRefreshTokenStub(with: "new-access-token")
    urlSession.addStub(status: 200, url: "https://example.com/api/endpoint")

    _ = try await FQNetworking(urlSession: urlSession,
                                   currentAuthController: currentAuthController)
      .authorizedRequest(url: URL(string: "https://example.com/api/endpoint")!)

    XCTAssertEqual(urlSession.stubs.count, 0)
    XCTAssertEqual(urlSession.receivedArgs.count, 3)

    try urlSession.assertReceivedArgs(at: 0,
                                      url: "https://example.com/api/endpoint",
                                      token: "existing-access-token")

    try urlSession.assertReceivedArgs(at: 1,
                                      url: "\(authServerURL)/api/token",
                                      token: nil)

    XCTAssertEqual(keychain.currentAuthorization?.accessToken, "new-access-token")

    try urlSession.assertReceivedArgs(at: 2,
                                      url: "https://example.com/api/endpoint",
                                      token: "new-access-token")
  }
}
