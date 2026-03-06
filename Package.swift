// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "brainf*ck compiler",
    defaultLocalization: "en-GB",
    platforms: [.macOS("26.0")],
    products: [.executable(name: "bfc", targets: ["brainf*ck compiler"])],
    targets: [
        .target(name: "BFAbstractSyntaxTree", dependencies: ["BFCommand"]),
        .testTarget(name: "BFAbstractSyntaxTree tests", dependencies: ["BFAbstractSyntaxTree"]),
        .target(name: "BFCommand"),
        .testTarget(name: "BFCommand tests", dependencies: ["BFCommand"]),
        .executableTarget(name: "brainf*ck compiler", dependencies: ["BFAbstractSyntaxTree", "Utilities"]),
        .systemLibrary(name: "LLVM", pkgConfig: "llvm", providers: [.brew(["llvm"])]),
        .target(name: "Utilities"),
        .testTarget(name: "Utilities tests", dependencies: ["Utilities"])
    ]
)
