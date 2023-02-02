import Sh
import Foundation

try sh(.terminal, "xcrun xcodebuild test -scheme App")
