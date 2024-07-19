// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "FileCacheUnit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
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
