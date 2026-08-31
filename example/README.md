# fastpix_data_better_player example

A minimal Flutter app showing [BetterPlayer](https://pub.dev/packages/better_player_plus)
wired to FastPix analytics via `fastpix_data_better_player`.

On the home screen you enter a **Workspace ID** and a **Playback ID** (a sample
one is prefilled), tap **Play video**, and the app streams the video while
sending playback metrics to your FastPix workspace.

## Prerequisites

- Flutter SDK (Dart `^3.7.2`)
- An iOS Simulator / Android emulator or a connected device
- A FastPix **Workspace ID** and a **Playback ID**

## Run

```bash
cd example
flutter pub get
flutter run
```

`flutter run` targets whatever device is connected; if several are, pass
`-d <device-id>` (see `flutter devices`).

### iOS (simulator)

```bash
open -a Simulator          # boot a simulator
cd example
flutter run -d ios
```

### Android (emulator)

```bash
flutter emulators                        # list available AVDs
flutter emulators --launch <avd-id>      # e.g. Pixel_6_Pro
cd example
flutter run -d android
```

Then on the home screen:

1. Enter your **Workspace ID**.
2. Enter a **Playback ID** (or keep the prefilled sample).
3. Tap **Play video**.

The stream URL is derived as `https://stream.fastpix.io/<playbackId>.m3u8`.

## Notes

- The example depends on the plugin by path (`fastpix_data_better_player: { path: ../ }`),
  so it always builds against the local source in this repo.
- `viewerId` must be a valid UUID — the FastPix beacon rejects non-UUID values
  with HTTP 400. The example uses a fixed UUID; swap it for a real per-viewer id.
- `beaconUrl` is omitted, so the SDK derives the beacon from the Workspace ID.

See the repo [README](../README.md) for the full SDK API reference.
