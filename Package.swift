// swift-tools-version: 5.9
//
// WebmasterID iOS SDK 1.3.1 — binary distribution.
//
// GENERATED from the release's build manifest. Each URL is an immutable
// release asset and each checksum is the SHA-256 SwiftPM verifies before it
// unpacks anything. A change is a new version, never an edited one.
//
// Products:
//   WebmasterID          consent-first analytics events. Foundation and
//                        Security only — it does not link StoreKit.
//   WebmasterIDStoreKit  OPTIONAL. Apple-signed purchase evidence for
//                        server-side verification. Add it only if the app
//                        sells something.
import PackageDescription

let package = Package(
    name: "WebmasterID",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "WebmasterID", targets: ["WebmasterID"]),
        // The StoreKit module links the core, so its product carries both.
        .library(name: "WebmasterIDStoreKit", targets: ["WebmasterIDStoreKit", "WebmasterID"]),
    ],
    targets: [
        .binaryTarget(
            name: "WebmasterID",
            url: "https://github.com/PetroTitan/webmasterid-mobile-sdk/releases/download/1.3.1/WebmasterID.xcframework.zip",
            checksum: "1742bbfa9665380e9843369b0f38d4687461eeb652a08750271978215db951e3"
        ),
        .binaryTarget(
            name: "WebmasterIDStoreKit",
            url: "https://github.com/PetroTitan/webmasterid-mobile-sdk/releases/download/1.3.1/WebmasterIDStoreKit.xcframework.zip",
            checksum: "c8479044bf090f5a7d55058550a78d10897e57610c299022709267f959b496e7"
        ),
    ]
)
