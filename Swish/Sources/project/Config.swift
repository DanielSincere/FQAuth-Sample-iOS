import Foundation
import DotEnv
import Sh

struct Config {

  let bundleID: String
  let developmentTeam: String
  let serverURL: String

  static func load() throws -> Self {
    if let config = loadFromEnv() {
      return config
    }  else if let config = loadDotEnv() {
      return config
    } else if let config = loadFromSecurity() {
      return config
    } else {
      throw CouldNotLoadConfig()
    }
  }

  struct CouldNotLoadConfig: Error, LocalizedError {
    let errorDescription: String? = "Could not load config from Environment, .env, or from `security`"
  }

  private static func env(_ key: String) -> String? {
    ProcessInfo.processInfo.environment[key]
  }

  private static func loadFromEnv() -> Self? {
    let bundleID = env("FQAUTH_BUNDLE_ID")
    let developmentTeam = env("FQAUTH_DEVELOPMENT_TEAM")
    let serverURL = env("FQAUTH_SERVER_URL")

    guard let bundleID, let developmentTeam, let serverURL else {
      return nil
    }

    return Config(bundleID: bundleID,
                  developmentTeam: developmentTeam,
                  serverURL: serverURL)
  }

  private static func loadDotEnv() -> Self? {

    do {
      try DotEnv.load(path: ".env")
    } catch {
      print(error)
      return nil
    }

    return loadFromEnv()
  }

  static func loadFromSecurity() -> Self? {
    do {
      let bundleID = try security("FQAUTH_IOS_BUNDLE_ID")
      let developmentTeam = try security("FQAUTH_DEVELOPMENT_TEAM")
      let serverURL = try security("FQAUTH_SERVER_URL")

      return Config(bundleID: bundleID,
                    developmentTeam: developmentTeam,
                    serverURL: serverURL)
    } catch {
      return nil
    }
  }

  static func security(_ key: String) throws -> String {
    try sh(String.self, "security find-generic-password -a $(whoami) -s \(key) -w")
  }
}
