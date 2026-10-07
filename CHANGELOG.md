# Changelog

## 1.2.0

First binary release. Same public API as 1.1.0, plus:

- **Privacy manifests valid under Apple's TN3181.** Both frameworks' `PrivacyInfo.xcprivacy` carried an empty
  `NSPrivacyAccessedAPITypes` array, which Apple lists as invalid, and an empty
  `NSPrivacyTrackingDomains` array, which Apple says to remove when tracking is
  false. Both keys are now absent; nothing declared changed (tracking false, no
  required-reason API, the same collected-data types).
- **A 413 on a batch of more than one event no longer loops.** The SDK re-sent
  the identical batch at once, for ever, when the server (or a proxy in front
  of it) answered 413 to a batch within the SDK's own limit. It now halves the
  batch on each 413, down to one event, which is dropped and counted as before.

- `identify(externalUserID:appAccountToken:)` and
  `WebmasterIDIdentityClaimDecision`: a purchase is claimed for a user only when
  the `appAccountToken` Apple signed into the transaction equals the registered
  one; otherwise the payment is recorded with no user. **Behaviour change for
  1.1.0 integrations:** `identify(externalUserID:)` alone still attributes events;
  its purchases are recorded without a user. Pass the token to both calls.
- `WebmasterIDStoreKitDiagnostics.lastIdentityClaim` and `identityClaimsWithheld`.
- **Startup and consent:** a client at `.notDetermined` collects, sends and
  deletes nothing — restoring `.analyticsAllowed` keeps the installation id
  (1.1.0 deleted it at every start). `flush()` sends nothing before a decision.
- **Identity at launch:** a stored account key labels nothing until `identify`
  confirms it in the new process (same key: same identity period). Delivery
  waits for that at most `WebmasterIDContract.identityRestoreWindow` (30 s).
  **Behaviour change** for apps that never call `identify` at launch.
  `diagnostics().deliveryHold` explains a hold.
- `WebmasterIDDiagnostics.identityStorage` and `identityStorageFailures`: a
  write of the account key that did not land is reported as a category
  (`unavailable`, `locked`, `encoding`, `unknown`) — never the key, the token
  or the Keychain status. Events after it carry no account key. A custom
  `WebmasterIDIdentityStore` needs no change.
- Distributed as XCFrameworks (iOS 15+, built with Xcode 26.0.1), each with its
  privacy manifest at the framework root.
