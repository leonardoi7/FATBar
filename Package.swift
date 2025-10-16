// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FATBar",
    // Minimum platform versions for backward compatibility
    // iOS 15+: Enables broad device support while maintaining modern SwiftUI features
    // Liquid Glass effects automatically activate on iOS 26+ via runtime version detection
    platforms: [
        .iOS(.v15),      // iOS 15.0+ for backward compatibility
        .macOS(.v12),    // macOS 12.0+ (Monterey)
        .tvOS(.v15),     // tvOS 15.0+
        .watchOS(.v8)    // watchOS 8.0+
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
