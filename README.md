# FastPix Video Data SDK for BetterPlayer (Flutter) - QoE analytics and video monitoring

[![Pub Version](https://img.shields.io/pub/v/fastpix_data_better_player)](https://pub.dev/packages/fastpix_data_better_player)
[![Pub Likes](https://img.shields.io/pub/likes/fastpix_data_better_player)](https://pub.dev/packages/fastpix_data_better_player)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-0CB16D)](https://pub.dev/packages/fastpix_data_better_player)
[![License: Apache 2.0](https://img.shields.io/github/license/FastPix/flutter-data-better-player)](./LICENSE)

The **FastPix Video Data SDK for BetterPlayer** is a Flutter plugin that adds real-time Quality of Experience (QoE) analytics to the [BetterPlayer (`better_player_plus`)](https://pub.dev/packages/better_player_plus) video player. It is the automated, out-of-the-box wrapper: it hooks into BetterPlayer's playback behaviour and automatically tracks startup time, rebuffering, bitrate and resolution shifts, seeking, errors and viewer engagement, and reports them to the FastPix dashboard - with no custom event-tracking code to write.

It is a **Video Data (analytics) SDK, not a video player**. It wraps BetterPlayer to measure playback quality and engagement; it does not replace the player. Reach for it when you already play video with BetterPlayer in a Flutter app and want QoE monitoring without building a data pipeline yourself. For the full list of metrics, see [Monitor Better Player (Flutter)](https://fastpix.com/docs/video-data/monitors/better-player).

**Works with:** Flutter (Android and iOS) · BetterPlayer (`better_player_plus`) · the FastPix Video Data dashboard

[Documentation](https://fastpix.com/docs/video-data/monitors/better-player) · [Create a free account](https://dashboard.fastpix.com/signup?utm_source=github&utm_medium=referral&utm_campaign=github_signup)

## Start here

New to the SDK? Work through these in order:

1. [Before you start](#before-you-start) - create a workspace and get your workspace ID
2. [Install the SDK](#installation)
3. [Add analytics to your BetterPlayer (basic)](#basic-implementation)
4. [Attach video, player and custom metadata](#advanced-configuration)
5. [Configuration parameters](#configuration)
6. [What it tracks](#event-tracking)
7. [FAQ](#faq)

## Why FastPix

- **No event-tracking code to write.** A builder wraps your existing `BetterPlayerController` and hooks the playback events for you - the "automated wrapper" path, not a hand-rolled event listener.
- **Deep QoE out of the box.** Startup time, rebuffering, bitrate and resolution shifts, stalls, seeking and playback errors, reported in near real time.
- **BetterPlayer stays intact.** The full `better_player_plus` API keeps working; the wrapper only observes it.
- **One dashboard.** Metrics land in your FastPix workspace for viewer-engagement and quality-of-experience monitoring.

## Who it's for

- **OTT and streaming apps on BetterPlayer:** monitor QoE (startup, rebuffering, errors) across your catalogue.
- **Online learning and courses:** measure completion, watch time and engagement per lesson.
- **Any Flutter app that plays video with BetterPlayer:** add analytics without replacing your player or writing tracking code.

## Description

The FastPix Better Player Wrapper is a powerful Flutter plugin that seamlessly integrates BetterPlayer with FastPix analytics. It enables developers to track detailed video player metrics, user engagement, and performance analytics while maintaining the full functionality of BetterPlayer. This wrapper handles all the complexity of analytics integration, allowing you to focus on building great video experiences.

## Features

- **Seamless BetterPlayer Plus Integration**: Full compatibility with BetterPlayer Plus's features and API
- **Comprehensive Analytics Tracking**: Automatic tracking of play, pause, seek, buffering, and completion events
- **Cross-Platform Support**: Works on both Android and iOS platforms
- **Real-time Metrics**: Live tracking of player performance and user behavior
- **Custom Data Support**: Ability to attach custom metadata to video sessions
- **Error Handling**: Robust error tracking and reporting with detailed error models
- **Performance Monitoring**: Track player resolution changes, buffering times, and playback quality
- **Flexible Configuration**: Easy setup with builder pattern for customization
- **Logging Support**: Optional detailed logging for debugging and development
- **Audio Language Detection**: Automatic detection and support for multiple audio tracks
- **Player Dimension Tracking**: Real-time monitoring of player size and resolution changes
- **State Management**: Comprehensive player state tracking with valid event transitions
- **Memory Management**: Proper resource cleanup and disposal methods

## Before you start

This SDK reports analytics to a FastPix workspace, so you need an account and a workspace ID. You also need a Flutter app that already plays video with BetterPlayer (`better_player_plus`).

- **Create a free account** and sign in to the [FastPix Dashboard](https://dashboard.fastpix.com/signup?utm_source=github&utm_medium=referral&utm_campaign=github_signup).
- **Set up a workspace** and copy your workspace ID - see [set up a workspace](https://fastpix.com/docs/getting-started/set-up-a-workspace).
- **Already playing video with BetterPlayer?** If not, add [`better_player_plus`](https://pub.dev/packages/better_player_plus) first - this SDK wraps it, it does not replace it.

## Installation

### 1. Add Dependency

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  fastpix_data_better_player: ^1.0.0
  better_player_plus: ^1.0.8
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Platform Setup

#### Android
No additional setup required. The plugin automatically handles Android configuration.

#### iOS
No additional setup required. The plugin automatically handles iOS configuration.

## Usage

### Basic Implementation

```dart
import 'package:fastpix_data_better_player/fastpix_data_better_player.dart';
import 'package:better_player_plus/better_player_plus.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late BetterPlayerController _betterPlayerController;
  late FastPixBaseBetterPlayer _fastPixPlayer;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    // Initialize BetterPlayer
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "https://example.com/video.mp4",
      ),
    );

    // Initialize FastPix wrapper
    _fastPixPlayer = FastPixBaseVideoPlayerBuilder(
      playerController: _betterPlayerController,
      workspaceId: "your_workspace_id",
      beaconUrl: "https://your-beacon-url.com",
      viewerId: "unique_viewer_id",
    )
        .setVideoData(
          VideoData(
            videoUrl: "https://example.com/video.mp4",
            videoThumbnailUrl: "https://example.com/thumbnail.jpg",
          ),
        )
        .setEnabledLogging(true)
        .build();

    // Start analytics tracking
    _fastPixPlayer.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fastPixPlayer.disposeMetrix();
    super.dispose();
  }
}
```

### Advanced Configuration

```dart
// Create custom data for analytics
CustomData customData = CustomData(value: "entertainment");

// Initialize with advanced configuration
_fastPixPlayer = FastPixBaseVideoPlayerBuilder(
  playerController: _betterPlayerController,
  workspaceId: "your_workspace_id",
  beaconUrl: "https://your-beacon-url.com",
  viewerId: "unique_viewer_id",
)
    .setVideoData(
      VideoData(
        videoUrl: "https://example.com/video.mp4",
        videoThumbnailUrl: "https://example.com/thumbnail.jpg",
      ),
    )
    .setPlayerData(
      PlayerData(
        playerName: "better_player",
        playerVersion: "x.x.x",
      ),
    )
    .setCustomData(customData)
    .setEnabledLogging(true)
    .build();
```

## Configuration

### Required Parameters

- **`workspaceId`**: Your FastPix workspace identifier
- **`viewerId`**: Unique identifier for the current viewer/session

### Optional Parameters

- **`enabledLogging`**: Enable/disable detailed logging (default: false)
- **`playerData`**: Custom player information and metadata
- **`videoData`**: Video-specific information including URL and thumbnail
- **`customData`**: Additional custom key-value pairs for analytics

### Environment Variables

Set up your FastPix configuration in your environment:

```bash
# .env file
FASTPIX_WORKSPACE_ID=your_workspace_id
FASTPIX_BEACON_URL=https://your-beacon-url.com
```

### Advanced Features

#### Audio Language Detection
The plugin automatically detects and tracks audio language preferences from available audio tracks:

```dart
// Audio language is automatically detected from player tracks
String audioLanguage = _fastPixPlayer.audioLanguage;
```

#### Player Dimension Tracking
Monitor player size changes in real-time:

```dart
// Report player dimensions for analytics
_fastPixPlayer.reportPlayerSize(_playerKey);
```

#### State Machine Validation
The plugin implements a robust state machine that ensures only valid event transitions occur, preventing invalid analytics data and improving tracking accuracy.

## API / SDK Reference

### Core Classes

#### `FastPixBaseVideoPlayerBuilder`

Builder class for creating FastPix video player instances.

**Constructor:**
```dart
FastPixBaseVideoPlayerBuilder({
  required BetterPlayerController playerController,
  required String workspaceId,
  String beaconUrl,
  required String viewerId,
})
```

**Methods:**
- `setEnabledLogging(bool value)`: Enable/disable logging
- `setCustomData(CustomData value)`: Set custom analytics data
- `setPlayerData(PlayerData? value)`: Set player metadata
- `setVideoData(VideoData? value)`: Set video information
- `build()`: Create the FastPix player instance

#### `FastPixBaseBetterPlayer`

Main wrapper class that handles analytics integration.

**Methods:**
- `start()`: Initialize and start analytics tracking
- `disposeMetrix()`: Clean up analytics resources and player controller
- `reportPlayerSize(GlobalKey key)`: Report player dimensions for analytics

### Event Tracking

The wrapper automatically tracks the following player events with valid state transitions:

- **Player Ready**: When the player is initialized
- **Play**: When video starts playing
- **Pause**: When video is paused
- **Seeking**: When user seeks to a different position
- **Seeked**: When seeking operation completes
- **Buffering**: When video is buffering
- **Buffered**: When buffering completes
- **Playing**: During active playback
- **Variant Changed**: When video quality/resolution changes
- **View Completed**: When video finishes playing
- **Error**: When playback errors occur

The plugin implements a state machine that ensures only valid event transitions occur, preventing invalid analytics data and improving tracking accuracy.

## Which FastPix SDK for Flutter

This repository is the **BetterPlayer analytics** integration. For the other parts of a FastPix Flutter app, use the matching SDK:

| What you want to do | FastPix SDK |
| --- | --- |
| Add QoE analytics to a BetterPlayer video | **fastpix_data_better_player** (this repository) |
| Core Flutter video analytics (the engine this builds on) | [FastPix/flutter-core-data-sdk](https://github.com/FastPix/flutter-core-data-sdk) (`fastpix_flutter_core_data`) |
| Play FastPix HLS video in Flutter | [FastPix/Flutter-Video-Player](https://github.com/FastPix/Flutter-Video-Player) (`fastpix_video_player`) |
| Upload video from a Flutter app | [FastPix/flutter-uploads](https://github.com/FastPix/flutter-uploads) |

## FAQ

**How do I add video analytics to BetterPlayer in Flutter?**
Add `fastpix_data_better_player`, wrap your existing `BetterPlayerController` with `FastPixBaseVideoPlayerBuilder(...).build()`, and call `start()`. The wrapper hooks BetterPlayer's events and reports QoE metrics automatically. See [Add analytics (basic)](#basic-implementation).

**What video quality-of-experience (QoE) metrics does it track?**
Startup time, rebuffering and buffering, bitrate and resolution shifts, seeking, playback errors, and view completion, plus engagement signals. See [What it tracks](#event-tracking) and [Monitor Better Player (Flutter)](https://fastpix.com/docs/video-data/monitors/better-player).

**Is this a video player?**
No. It is a Video Data (analytics) SDK that wraps the BetterPlayer (`better_player_plus`) player. You keep using BetterPlayer for playback; this SDK only measures it.

**Do I have to rewrite my event tracking?**
No. This is the automated-wrapper approach - the builder hooks the playback events for you, so you do not write a custom `addEventsListener` mapping layer.

**Does it work on Android and iOS?**
Yes, both.

**How do I attach video title, player and custom metadata?**
Use `setVideoData(...)`, `setPlayerData(...)` and `setCustomData(...)` on the builder. See [Attach metadata](#advanced-configuration).

**Is it an alternative to rolling my own Firebase/Mixpanel video tracking?**
Yes - it gives you deep, video-specific QoE (bitrate, stalls, startup latency) out of the box, instead of manually logging `video_play` / `video_pause` events to a general analytics backend.

## Documentation

 [Monitor Better Player (Flutter) - FastPix docs](https://fastpix.com/docs/video-data/monitors/better-player) for the full metric list and setup guide, and the [FastPix Video Data overview](https://fastpix.com/docs/video-data/overview).

## Contributing

We welcome contributions to improve the FastPix Better Player Wrapper! Here's how you can help:

### Development Setup

1. Fork the repository
2. Clone your fork locally
3. Install dependencies: `flutter pub get`
4. Create a feature branch: `git checkout -b feature/amazing-feature`
5. Make your changes and add tests
6. Run tests: `flutter test`
7. Commit your changes: `git commit -m 'Add amazing feature'`
8. Push to your branch: `git push origin feature/amazing-feature`
9. Open a Pull Request

### Code Style

- Follow Dart/Flutter best practices
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure all tests pass
- Update documentation for new features

### Reporting Issues

- Use the GitHub issue tracker
- Provide detailed reproduction steps
- Include device/OS information
- Attach relevant logs and error messages

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Dependencies

This plugin requires the following dependencies:
- **Flutter**: >=3.3.0
- **Dart SDK**: ^3.7.2
- **better_player_plus**: ^1.0.8
- **fastpix_flutter_core_data**: Latest version from FastPix repository

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes and updates.

---

**Made with ❤️ by the FastPix Team**
