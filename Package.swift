// swift-tools-version: 6.0
import PackageDescription

// The Visualize iOS SDK, as a binary Swift package.
//
// Integration: Xcode → File → Add Package Dependencies → this repo's URL →
// pick a version. The framework downloads from this repo's Releases; the
// checksum below makes Swift Package Manager refuse any tampered zip.
let package = Package(
    name: "VisualizeSDK",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "VisualizeSDK", targets: ["VisualizeSDK"])
    ],
    targets: [
        .binaryTarget(
            name: "VisualizeSDK",
            url: "https://github.com/Visualize-KK/visualize-sdk/releases/download/2.0.2/VisualizeSDK-2.0.2.xcframework.zip",
            checksum: "bc1b6d1a7e9a2b16a13974a397ff2b74eddd76bf9e2288f5b8da5f7e6291a277"
        )
    ]
)
