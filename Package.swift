// swift-tools-version: 5.9
//
// WebmasterID iOS SDK 1.2.0 — binary distribution.
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
            url: "https://github.com/PetroTitan/webmasterid-mobile-sdk/releases/download/1.2.0/WebmasterID.xcframework.zip",
            checksum: "aeb53c747cb5fe6e6662f7eba5e464ea491ddfe4ca036f7360a7b8a0365d1b39"
        ),
        .binaryTarget(
            name: "WebmasterIDStoreKit",
            url: "https://github.com/PetroTitan/webmasterid-mobile-sdk/releases/download/1.2.0/WebmasterIDStoreKit.xcframework.zip",
            checksum: "c0d42d566f18c54c9bc7a73e15fc36ffab3a7d6e34e78b872f50c220eed5f24d"
        ),
    ]
)
