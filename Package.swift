// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUICoordinator",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftUICoordinator",
            targets: ["SwiftUICoordinator"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUICoordinator",
            dependencies: []),
        .testTarget(
            name: "SwiftUICoordinatorTests",
            dependencies: ["SwiftUICoordinator"]),
    ]
)
