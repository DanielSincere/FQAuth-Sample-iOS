import XCTest

final class FakeURLSessionTests: XCTestCase {

  override func setUpWithError() throws {

  }

  override func tearDownWithError() throws {

  }

  let exampleURL = URL(string: "https://example.com")!

  func testThrowsWhenResponsesAreEmpty() async throws {

    let fake = FakeURLSession()

    do {
      let _ = try await fake.data(for: URLRequest(url: exampleURL))
      XCTFail("expected error")
    } catch {
      XCTAssertEqual(error as? FakeURLSession.Errors, FakeURLSession.Errors.stubsAreEmpty)
    }

  }

  func testReturnsNextResult() async throws {
    let fake = FakeURLSession()

    fake.stubs.append(FakeURLSession.defaultForbidden(for: exampleURL))

    let result = try await fake.data(for: URLRequest(url: exampleURL))
    XCTAssertEqual(result.0, FakeURLSession.defaultForbidden(for: exampleURL).0)
    XCTAssertEqual(result.1.url, exampleURL)
    XCTAssertEqual((result.1 as! HTTPURLResponse).statusCode, 403)
  }

  func testReturnsNextResultWhenMultiple() async throws {
    let fake = FakeURLSession()

    fake.stubs.append(FakeURLSession.defaultForbidden(for: exampleURL))
    fake.stubs.append(FakeURLSession.defaultSuccess(for: exampleURL))

    let result1 = try await fake.data(for: URLRequest(url: exampleURL))
    XCTAssertEqual(result1.0, FakeURLSession.defaultForbidden(for: exampleURL).0)
    XCTAssertEqual(result1.1.url, exampleURL)
    XCTAssertEqual((result1.1 as! HTTPURLResponse).statusCode, 403)

    let result2 = try await fake.data(for: URLRequest(url: exampleURL))
    XCTAssertEqual(result2.0, FakeURLSession.defaultForbidden(for: exampleURL).0)
    XCTAssertEqual(result2.1.url, exampleURL)
    XCTAssertEqual((result2.1 as! HTTPURLResponse).statusCode, 200)
  }
}
