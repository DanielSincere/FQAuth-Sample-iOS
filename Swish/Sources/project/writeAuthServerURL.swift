
func writeAuthServerURL(config: Config) throws {
try
"""
let authServerURL: String = "\(config.serverURL)"
"""
  .write(toFile: "App/authServerURL.swift", atomically: true, encoding: .utf8)
}
