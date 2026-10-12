# Changelog

## 1.3.1 — 2026-10-12

### Fixed: the WebmasterIDStoreKit privacy manifest is valid XML

App Store Connect refused uploads of apps embedding `WebmasterIDStoreKit` 1.3.0
with **ITMS-91056** at `Frameworks/WebmasterIDStoreKit.framework/PrivacyInfo.xcprivacy`:
a comment inside the manifest contained `--`, which XML forbids. Only that
comment is corrected. The declarations are unchanged — Purchase History and
User ID, linked to the user, not used for tracking, purpose analytics; no
tracking; no required-reason API — and nothing else changed from 1.3.0: no
runtime, API, consent or delivery change. Apps that embed only `WebmasterID`
were not affected.

Update to `from: "1.3.1"`, or let `from: "1.3.0"` resolve to 1.3.1 with
File → Packages → Update to Latest Package Versions, then upload again.

## 1.3.0 — 2026-10-11

### Events leave on their own

Through 1.2.0 `track` only wrote to disk: nothing sent an event unless the app
called `flush()` or forwarded a background transition, so an iOS app that did
neither kept its events on the device, across launches.

- **Automatic delivery.** The first queued event arms ONE delivery
  `autoFlushDelay` (5 s) later; events queued meanwhile join it and never push
  it back. `autoFlushDelay: 0` restores the 1.2.0 behaviour.
- **Lifecycle observed by the client** where UIKit exists: going to the
  background delivers at once inside `ProcessInfo.performExpiringActivity`
  (extension-safe); coming back arms a delivery for anything still queued.
  Nothing promises delivery after suspension, force-quit or termination —
  unsent events stay on disk and go out when the app next runs. Calls a host
  already makes (`applicationDidEnterBackground()`) remain harmless.
- **Startup resume.** A queue an earlier launch left is armed at startup —
  after the consent decision and the identity restore, never before them.
- **Retries are real** — while the app runs. A transport error or a 5xx arms
  its retry: full jitter, at least 1 s, capped at 300 s. A 429 waits for its
  full `Retry-After` (at least 1 s; bounded only by the 7-day event age, never
  by a shorter local cap); an explicit `flush()` inside that window is the
  host's decision and sends at once. **No stop after `maxDeliveryAttempts`**
  any more: a phone offline for minutes recovers without a relaunch. A
  suspended or terminated app runs no timer; its events go out after it next
  runs. A 403 still stops delivery for the
  launch, keeps the events, and asks again on the next launch.
- **One delivery at a time.** A concurrent `flush()`, the automatic delivery
  and a background transition join the delivery already running instead of
  returning `false`; a cancelled caller cancels it and the rest is re-armed.
- **Diagnostics that do not claim what is not true.** `retryState` is
  `.scheduled` only while a retry is armed, with the time left;
  `nextAutomaticDeliveryAt` is new. The counters are documented as this
  process's: `queued` 2 with `queuedEvents` 21 after a relaunch is normal.
- Configuration gains `autoFlushDelay`, `lifecycle` and `scheduler`;
  `WebmasterIDRandomSource` gains `jitter()` with a default. Additive and
  source-compatible.

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
