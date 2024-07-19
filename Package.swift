// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "FileCacheUnit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "FileCacheUnit",
            targets: ["FileCacheUnit"]),
    ],
    targets: [
        .target(
            name: "FileCacheUnit",
            dependencies: []),
        .testTarget(
            name: "FileCacheUnitTests",
            dependencies: ["FileCacheUnit"]),
    ]
)
