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
    // TODO: once ChouTi is stable, use release instead of develop branch.
    .package(url: "https://github.com/honghaoz/ChouTi", branch: "develop"),
  ],
  targets: [
    .target(
      name: "ChouTiUI",
      dependencies: [
        "ChouTi",
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
