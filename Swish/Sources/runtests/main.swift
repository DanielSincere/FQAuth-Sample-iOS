import Sh
import Foundation

try sh(.terminal,
"""
xcrun xcodebuild test \
-scheme App \
-project App.xcodeproj \
-sdk iphoneos \
-destination "platform=iOS Simulator,OS=16.1,name=iPhone 14 Pro Max" \
CODE_SIGNING_ALLOWED=No
""")
