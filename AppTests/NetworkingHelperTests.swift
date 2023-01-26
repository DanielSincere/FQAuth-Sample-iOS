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

    urlSession.stubs.append(FakeURLSession.defaultSuccess(for: URL(string: "https://example.com")!))

    _ = try await NetworkingHelper(keychain: keychain, urlSession: urlSession)
      .authorizedRequest(url: URL(string: "https://example.com")!)

    XCTAssertEqual(urlSession.receivedArgs.first?.url, URL(string: "https://example.com")!)
    XCTAssertEqual(urlSession.receivedArgs.first?.value(forHTTPHeaderField: "Authorization"), "Bearer existing-access-token")
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

    urlSession.stubs.append(FakeURLSession.defaultForbidden(for: URL(string: "https://example.com/api/endpoint")!))

    urlSession.stubs.append(FakeURLSession.successTokenResponse(for: URL(string: "https://example.com/api/token")!, accessToken: "new-access-token"))

    urlSession.stubs.append(FakeURLSession.defaultSuccess(for: URL(string: "https://example.com/api/endpoint")!))

    _ = try await NetworkingHelper(keychain: keychain, urlSession: urlSession)
      .authorizedRequest(url: URL(string: "https://example.com/api/endpoint")!)


    XCTAssertEqual(urlSession.stubs.count, 0)
    XCTAssertEqual(urlSession.receivedArgs.count, 3)

    XCTAssertEqual(urlSession.receivedArgs.first?.url, URL(string: "https://example.com/api/endpoint")!)
    XCTAssertEqual(urlSession.receivedArgs.first?.value(forHTTPHeaderField: "Authorization"), "Bearer existing-access-token")

    XCTAssertEqual(urlSession.receivedArgs.second?.url, URL(string: "\(authServerURL)/api/token")!)

    XCTAssertEqual(urlSession.receivedArgs.third?.url, URL(string: "https://example.com/api/endpoint")!)
    XCTAssertEqual(urlSession.receivedArgs.third?.value(forHTTPHeaderField: "Authorization"), "Bearer new-access-token")

  }
}

extension Array {
  var second: Element? {
    guard count > 1 else { return nil }
    return self[1]
  }

  var third: Element? {
    guard count > 2 else { return nil }
    return self[2]
  }
}
