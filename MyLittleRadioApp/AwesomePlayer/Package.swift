// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AwesomePlayer",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AwesomePlayer",
            targets: ["AwesomePlayer"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-async-algorithms",
            from: "1.0.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AwesomePlayer",
            dependencies: [
                .product(
                    name: "AsyncAlgorithms",
                    package: "swift-async-algorithms"
                )
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "AwesomePlayerTests",
            dependencies: [
                "AwesomePlayer",
                .product(
                    name: "AsyncAlgorithms",
                    package: "swift-async-algorithms"
                )
            ]
        )
    ]
)
