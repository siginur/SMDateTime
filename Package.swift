// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SMDateTime",
    products: [
        .library(name: "SMDateTime", targets: ["SMDateTime"])
    ],
    targets: [
        .target(
            name: "SMDateTime",
            dependencies: [],
            path: "SMDateTime")
    ]
)
