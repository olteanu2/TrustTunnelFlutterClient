# Building TrustTunnelFlutterClient — with per-app routing

This fork adds a per-app routing screen (choose which apps use the VPN)
to the Flutter app.

## Prerequisites

- Flutter **3.38.3** exactly (pinned in `pubspec.yaml`) — use
  [FVM](https://fvm.app/) if your system Flutter is a different version:

dart pub global activate fvm
fvm install 3.38.3
fvm use 3.38.3

- A GitHub personal access token with `read:packages` (see main README).
- The native Android library from
  [TrustTunnelClient](https://github.com/olteanu2/TrustTunnelClient)
  (this fork) — see that repo's `BUILDING.md`. This fork's
  `trusttunnel-client-android` dependency is published at version
  `<VERSION>` — either build it yourself via `publishToMavenLocal`, or
  download the prebuilt AAR from this repo's Releases page and drop it
  into `plugins/vpn_plugin/android/libs/`.

## Building

export GPR_KEY=<your_personal_access_token>
make init
fvm flutter build apk --release


Resulting APK: `build/app/outputs/flutter-apk/app-release.apk`
