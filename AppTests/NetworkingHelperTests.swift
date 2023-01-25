import XCTest
@testable import App

final class NetworkingHelperTests: XCTestCase {

  override func setUpWithError() throws { }
  override func tearDownWithError() throws { }

  func testAuthorizationIsSetFromKeychain() async throws {

    let urlSession = FakeURLSession()
    let keychain = FakeKeychain()

    keychain.currentAuthorization = CurrentAuthorization(
      user: .init(id: .init(),
                  firstName: "First",
                  lastName: "Last"),
      refreshToken: "existing-refresh-token",
      accessToken: "existing-access-token")

    _ = try await NetworkingHelper(keychain: keychain, urlSession: urlSession)
      .authorizedRequest(url: URL(string: "https://example.com")!)

    XCTAssertEqual(urlSession.dataForRequest?.url, URL(string: "https://example.com")!)
    XCTAssertEqual(urlSession.dataForRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer existing-access-token")
  }

  func testForbiddenResponseTriggersTokenRefreshAndRetry() async throws  {
    let urlSession = FakeURLSession()
    let keychain = FakeKeychain()
    keychain.currentAuthorization = CurrentAuthorization(
      user: .init(id: .init(),
                  firstName: "First",
                  lastName: "Last"),
      refreshToken: "existing-refresh-token",
      accessToken: "existing-access-token")

//    urlSession.dataFor =

    _ = try await NetworkingHelper(keychain: keychain, urlSession: urlSession)
      .authorizedRequest(url: URL(string: "https://example.com")!)

    XCTAssertEqual(urlSession.dataForRequest?.url, URL(string: "https://example.com")!)
    XCTAssertEqual(urlSession.dataForRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer existing-access-token")




  }
}
