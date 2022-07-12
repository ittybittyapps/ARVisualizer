// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "ARVisualizer",
    products: [
        .library(name: "ClientCore", targets: ["ClientCore"])
    ],
    targets: [
        .target(name: "CCore", publicHeadersPath: "include"),
        .target(name: "ClientCore", dependencies: [.target(name: "CCore")])
    ]
)
