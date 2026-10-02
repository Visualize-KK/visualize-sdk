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
            url: "https://github.com/Visualize-KK/visualize-sdk/releases/download/2.0.1/VisualizeSDK-2.0.1.xcframework.zip",
            checksum: "f1d9ffeefb599e96230788c365ac267fc7adf1260334662b9b1a6c580f10801f"
        )
    ]
)
