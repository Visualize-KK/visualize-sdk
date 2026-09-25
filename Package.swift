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
            url: "https://github.com/Visualize-KK/visualize-sdk/releases/download/1.0.0/VisualizeSDK-1.0.0.xcframework.zip",
            checksum: "6eeeeef24406a9080e1a6167d2dd107e8f1e8b56620baad0e720296f79e28297"
        )
    ]
)
