// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "swift-dedici-hkdf",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "DediciHKDF",
            targets: ["DediciHKDF"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto", from: "2.2.1"),
    ],
    targets: [
        .target(
            name: "DediciHKDF",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
            ]
        ),
        .testTarget(
            name: "DediciHKDFTests",
            dependencies: ["DediciHKDF"]
        ),
    ]
)
