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
            url: "https://github.com/Visualize-KK/visualize-sdk/releases/download/2.0.0/VisualizeSDK-2.0.0.xcframework.zip",
            checksum: "ed8094b35965270946b47751f34036e3ec45176f4cee62e597c99cb71348f850"
        )
    ]
)
