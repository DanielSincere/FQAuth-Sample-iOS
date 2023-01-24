import Foundation

func isPreview() -> Bool {
  ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
