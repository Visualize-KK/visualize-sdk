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
            url: "https://github.com/Visualize-KK/visualize-sdk/releases/download/2.0.3/VisualizeSDK-2.0.3.xcframework.zip",
            checksum: "1556f7e47ceedd50f64a8a9816b6ce2db8ca04680b380c7c3487d8d54d373076"
        )
    ]
)
