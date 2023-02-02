// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "Scripts",
  platforms: [.macOS(.v11)],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.0.0"),
    .package(url: "https://github.com/swiftpackages/DotEnv.git", from: "3.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "project",
      dependencies: ["Sh","DotEnv"]),
    .executableTarget(
      name: "test",
      dependencies: ["Sh"]),
  ]
)
