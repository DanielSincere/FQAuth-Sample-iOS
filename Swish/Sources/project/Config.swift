import Foundation
import DotEnv
import Sh

struct Config {

  let bundleID: String
  let developmentTeam: String
  let fqAuthServerURL: String
  let randomStringServerURL: String

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
    let fqAuthServerURL = env("FQAUTH_SERVER_URL")
    let randomStringServerURL = env("RANDOM_STRING_SERVER_URL")

    guard let bundleID, let developmentTeam, let fqAuthServerURL, let randomStringServerURL = randomStringServerURL else {
      return nil
    }

    return Config(bundleID: bundleID,
                  developmentTeam: developmentTeam,
                  fqAuthServerURL: fqAuthServerURL,
                  randomStringServerURL: randomStringServerURL)
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
      let fqAuthServerURL = try security("FQAUTH_SERVER_URL")
      let randomStringServerURL = try security("RANDOM_STRING_SERVER_URL")

      return Config(bundleID: bundleID,
                    developmentTeam: developmentTeam,
                    fqAuthServerURL: fqAuthServerURL,
                    randomStringServerURL: randomStringServerURL)
    } catch {
      return nil
    }
  }

  static func security(_ key: String) throws -> String {
    try sh(String.self, "security find-generic-password -a $(whoami) -s \(key) -w")
  }
}
