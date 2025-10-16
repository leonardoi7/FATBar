// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FATBar",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FATBar",
            targets: ["FATBar"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // No external dependencies required - uses only SwiftUI and Foundation
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FATBar",
            dependencies: [],
            path: "Sources/FATBar",
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        ),
        .testTarget(
            name: "FATBarTests",
            dependencies: ["FATBar"],
            path: "Tests/FATBarTests"
        ),
    ],
    swiftLanguageModes: [.v5]
)
