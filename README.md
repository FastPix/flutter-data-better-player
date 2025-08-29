# FastPix Better Player Wrapper

A Flutter plugin that provides a wrapper around BetterPlayer with FastPix analytics integration for comprehensive video player metrics and tracking.

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

## Installation

### 1. Add Dependency

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  fastpix_better_player_wrapper: ^0.1.0
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
List<CustomData> customData = [
  CustomData(value: "entertainment"),
  CustomData(value: "action"),
];

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
- `setCustomData(List<CustomData> value)`: Set custom analytics data
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
