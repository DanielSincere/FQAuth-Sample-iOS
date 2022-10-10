import Sh
import Foundation

try sh(.terminal,
"mint run -m Mintfile yonaskolb/Xcodegen xcodegen -s xcodegen.yml",
environment: [
  "FQAUTH_BUNDLE_ID": "com.fullqueuedeveloper.FQAuthSampleiOSApp",
  "FQAUTH_DEVELOPMENT_TEAM": "ARST1234",
])
