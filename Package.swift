// swift-tools-version: 5.9
//
// WebmasterID iOS SDK 1.3.0 — binary distribution.
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
            url: "https://github.com/PetroTitan/webmasterid-mobile-sdk/releases/download/1.3.0/WebmasterID.xcframework.zip",
            checksum: "577c27d345c0b6dff3005890492d4f92f111f544b67f5a6a4a843909f8553962"
        ),
        .binaryTarget(
            name: "WebmasterIDStoreKit",
            url: "https://github.com/PetroTitan/webmasterid-mobile-sdk/releases/download/1.3.0/WebmasterIDStoreKit.xcframework.zip",
            checksum: "8c02f4903d93bba4bd226dbd8e18ebd191c76550c2ff8eac320d3e2e5ccfd684"
        ),
    ]
)
