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
    // TODO: once ChouTi, ComposeUI are stable, use release tag.
    .package(url: "https://github.com/honghaoz/ChouTi", branch: "master"),
    .package(url: "https://github.com/honghaoz/ComposeUI", branch: "master"),
  ],
  targets: [
    .target(
      name: "ChouTiUI",
      dependencies: [
        "ChouTi",
        "ComposeUI",
      ]
    ),
    .testTarget(
      name: "ChouTiUITests",
      dependencies: [
        "ChouTiUI",
        .product(name: "ChouTiTest", package: "ChouTi"),
      ]
    ),
  ]
)
