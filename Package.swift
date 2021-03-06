// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Upvest",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Upvest",
            targets: ["Upvest"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/jernejstrasner/SwiftCrypto.git", from: "1.0.1"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.3.2"),
        .package(url: "https://github.com/Quick/Quick.git", from: "1.3.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Upvest",
            dependencies: ["SwiftCrypto"],
            path: "Sources"), //path for target to look for sources
        .testTarget(
            name: "UpvestTests",
            dependencies: [
                "Upvest",
                "Quick",
                "Nimble"
            ],
 	    path: "Tests")
    ]
)
