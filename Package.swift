// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "ChouTiUI",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .visionOS(.v1),
  ],
  products: [
    .library(name: "ChouTiUI", targets: ["ChouTiUI"]),
  ],
  dependencies: [
    .package(url: "https://github.com/honghaoz/ChouTi", branch: "master"),
    .package(url: "https://github.com/honghaoz/ComposeUI", branch: "master"),
  ],
  targets: [
    .target(name: "ChouTiUI", dependencies: ["ChouTi", "ComposeUI"], path: "ChouTiUI/Sources"),
  ]
)
