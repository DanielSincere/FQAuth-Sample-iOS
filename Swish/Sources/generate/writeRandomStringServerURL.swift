func writeRandomStringServerURL(config: Config) throws {
try
"""
import Foundation
let randomStringServerURL: URL = URL(string: "\(config.randomStringServerURL)")!
"""
  .write(toFile: "App/randomStringServerURL.swift", atomically: true, encoding: .utf8)
}
