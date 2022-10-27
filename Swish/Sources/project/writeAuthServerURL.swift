
func writeAuthServerURL(config: Config) throws {
try
"""
import Foundation
let authServerURL: URL = URL(string: "\(config.serverURL)")!
"""
  .write(toFile: "App/authServerURL.swift", atomically: true, encoding: .utf8)
}
