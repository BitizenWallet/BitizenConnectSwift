// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "BitizenConnectSwift",
    platforms: [
        .macOS(.v10_14), .iOS(.v13),
    ],
    products: [
        .library(
            name: "BitizenConnectSwift",
            targets: ["BitizenConnectSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "1.5.1"))
    ],
    targets: [
        .target(
            name: "BitizenConnectSwift", 
            dependencies: ["CryptoSwift"],
            path: "Sources"),
        .testTarget(name: "BitizenConnectSwiftTests", dependencies: ["BitizenConnectSwift"], path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)
