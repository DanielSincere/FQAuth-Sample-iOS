import Sh
import Foundation

let config = try Config.load()


try sh(.terminal,
"mint run -m Mintfile yonaskolb/Xcodegen xcodegen -s xcodegen.yml",
environment: [
  "FQAUTH_BUNDLE_ID": config.bundleID,//"com.fullqueuedeveloper.FQAuthSampleiOSApp",
  "FQAUTH_DEVELOPMENT_TEAM": config.developmentTeam,//"ARST1234",
  "FQAUTH_SERVER_URL": config.serverURL//"auth.example.com",
])
