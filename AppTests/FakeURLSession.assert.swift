import Foundation
import XCTest
@testable import App

extension FakeURLSession {
  func assertReceivedArgs(at index: Int, url: String, token: String?, file: StaticString = #filePath, line: UInt = #line) throws {
    XCTAssertLessThan(index, receivedArgs.count, file: file, line: line)
    guard index < receivedArgs.count else {
      throw Errors.receivedArgsIndexOutOfBounds(index)
    }
    
    let request = receivedArgs[index]

    XCTAssertEqual(request.url, URL(string: url))

    if let token {
      XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)",
                     file: file, line: line)
    } else {
      XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"),
                   file: file, line: line)
    }
  }
}
