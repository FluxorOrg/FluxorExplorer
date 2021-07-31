// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FluxorExplorerInterceptor",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "FluxorExplorerInterceptor",
            targets: ["FluxorExplorerInterceptor"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/FluxorOrg/Fluxor",
            from: "4.0.0"),
        .package(path: "../FluxorExplorerSnapshot"),
    ],
    targets: [
        .target(
            name: "FluxorExplorerInterceptor",
            dependencies: ["Fluxor", "FluxorExplorerSnapshot"]),
        .testTarget(
            name: "FluxorExplorerInterceptorTests",
            dependencies: ["Fluxor", "FluxorExplorerInterceptor"]),
    ])
