// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Requester",
    platforms: [
        SupportedPlatform.iOS(
            SupportedPlatform.IOSVersion.v16
        ),
        SupportedPlatform.macOS(
            SupportedPlatform.MacOSVersion.v12
        ),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Requester",
            targets: ["Requester"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Requester",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "RequesterTests",
            dependencies: ["Requester"]
        ),
    ]
)
