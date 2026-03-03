// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "brainf*ck compiler",
    defaultLocalization: "en-GB",
    products: [
        .executable(name: "bfc", targets: ["brainf*ck compiler"])
    ],
    targets: [
        .target(name: "Utilities"),
        .testTarget(name: "Utilities tests", dependencies: ["Utilities"]),
        .executableTarget(name: "brainf*ck compiler", dependencies: ["Utilities"])
    ]
)
