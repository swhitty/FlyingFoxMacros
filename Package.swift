// swift-tools-version:5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "FlyingFoxMacros",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "FlyingFoxMacros",
            targets: ["FlyingFoxMacros"]
        ),
    ],
    dependencies: [
        // Depend on the Swift 5.10 release of SwiftSyntax
        .package(url: "https://github.com/swhitty/FlyingFox.git", from: "0.16.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"601.0.0-prerelease")
    ],
    targets: [
        .target(
            name: "FlyingFoxMacros",
            dependencies: [
                "Plugins",
                .product(name: "FlyingFox", package: "FlyingFox")
            ],
            path: "Macros/Sources",
            swiftSettings: .upcomingFeatures
        ),
        .testTarget(
            name: "FlyingFoxMacrosTests",
            dependencies: [
                "FlyingFoxMacros"
            ],
            path: "Macros/Tests",
            swiftSettings: .upcomingFeatures
        ),
        .macro(
            name: "Plugins",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "Plugins/Sources",
            swiftSettings: .upcomingFeatures
        )
    ]
)

extension Array where Element == SwiftSetting {

    static var upcomingFeatures: [SwiftSetting] {
        [
            .enableUpcomingFeature("ExistentialAny"),
            .enableExperimentalFeature("StrictConcurrency")
        ]
    }
}
