// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "VHCarrouselCollectionView",
    platforms: [.iOS(.v10)],
    products: [.library(name: "VHCarrouselCollectionView", targets: ["VHCarrouselCollectionView"])],
    targets: [.target(name: "VHCarrouselCollectionView")],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
