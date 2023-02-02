func writeAuthServerURL(config: Config) throws {
try
"""
import Foundation
let authServerURL: URL = URL(string: "\(config.fqAuthServerURL)")!
"""
  .write(toFile: "App/authServerURL.swift", atomically: true, encoding: .utf8)
}
