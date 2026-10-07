# WebmasterID for iOS — Swift package (binary)

Consent-first analytics events from an iOS app to WebmasterID, and — optionally —
Apple-signed purchase evidence for server-side verification.

This repository holds **only** the Swift package manifest and documentation. The
SDK ships as two binary XCFrameworks attached to each release; Xcode downloads
them and checks each one against the SHA-256 the manifest names. No GitHub
account, token or access request is needed.

| | |
| --- | --- |
| Products | `WebmasterID` (analytics; Foundation and Security only, never StoreKit) · `WebmasterIDStoreKit` (optional: Apple's signed transactions, verified on WebmasterID's servers) |
| Platforms | iOS 15+ (device arm64; Simulator arm64 and x86_64) |
| Toolchain | Xcode 26.0 or newer |
| Language | Swift. No Objective-C header is shipped and Objective-C is not supported. |

## Start here

The installation guide for every platform — the dashboard, the first run, how
to see the first event, purchases, troubleshooting and updates — is at
**https://webmasterid.com/docs/mobile-sdk**.

## Install

Xcode: **File → Add Package Dependencies…**, paste
`https://github.com/PetroTitan/webmasterid-mobile-sdk.git`, and add **WebmasterID**
to your app target — **WebmasterIDStoreKit** only if your app sells something.

`Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/PetroTitan/webmasterid-mobile-sdk.git", from: "1.2.0")
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [.product(name: "WebmasterID", package: "webmasterid-mobile-sdk")]
    )
]
```

## Use

```swift
import WebmasterID

// Your property's PUBLIC id from the WebmasterID dashboard. It ships inside
// your app; it addresses your property and is not a credential.
let client = WebmasterIDClient(
    configuration: try WebmasterIDConfiguration(appPropertyID: "ap_xxxxxxxxxxxxxxxx", consent: .notDetermined)
)
await client.setConsent(.analyticsAllowed)          // nothing is collected before this
try await client.identify(externalUserID: "<your-account-key>")   // never an e-mail
try await client.track(.screenView, context: .init(screen: "BookingDetail"))
```

The WebmasterID dashboard shows these steps for your own property, including the
lifecycle, sign-out and in-app purchase snippets, and tells you when the first
event has arrived.

**In-app purchases (1.2.0).** A purchase is attributed to a user only when the
`appAccountToken` Apple signed into the transaction equals the one registered
with `identify(externalUserID:appAccountToken:)`. Pass the same random,
per-account UUID to both. The SDK never finishes a transaction and sends nothing
for an `.unverified` result. It forwards Apple's signed transaction unread; the
WebmasterID service verifies it and records the product, price and currency.

## Privacy

Each framework carries its own `PrivacyInfo.xcprivacy` at its root: tracking is
false, no tracking domains, no required-reason APIs; only `WebmasterIDStoreKit`
declares Purchase History. An app that adds only `WebmasterID` does not link
StoreKit.

## Versions and support

Releases are immutable: a tag, its assets and their checksums never change — a
fix is a new version. Pin with `exact:` to hold a version; the previous version
stays installable. WebmasterID supports the latest release. Report a security
problem privately (see SECURITY.md).

Compiled code can be inspected; the SDK holds no secret and none is needed.

## License

The frameworks are licensed under the terms in `LICENSE`; third-party notices are
in `THIRD_PARTY_NOTICES.md`. Use of the WebmasterID service is governed by its
Terms of Service (https://webmasterid.com/terms).
