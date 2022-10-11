import Sh
import Foundation

let config = try Config.load()


try
"""
let authServerURL = "\(config.serverURL)"
"""
  .write(toFile: "App/authServerURL.swift", atomically: true, encoding: .utf8)


try sh(.terminal,
       "mint run -m Mintfile yonaskolb/Xcodegen xcodegen -s xcodegen.yml",
       environment: [
        "FQAUTH_BUNDLE_ID": config.bundleID,
        "FQAUTH_DEVELOPMENT_TEAM": config.developmentTeam,
       ])
