---
name: Bug Report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description

A clear and concise description of what the bug is.

## Reproduction Steps

1. **Setup Environment**

```yaml
dependencies:
  fastpix_data_better_player: ^0.1.0
```

2. **Code To Reproduce**

```dart
// If you added/updated code examples, include them here
    late FastPixBaseBetterPlayer _fastPixPlayer;
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
```

3. **Expected Behavior**
```
<!-- A clear and concise description of what you expected to happen.  -->
```

4. **Actual Behavior**
```
<!-- A clear and concise description of what actually happened. -->
```

5. **Environment**

- **SDK Version**: [e.g., 1.2.2]
- **Android Version**: [e.g., Android 12]
- **Min SDK Version**: [e.g., 24]
- **Target SDK Version**: [e.g., 35]
- **Device/Emulator**: [e.g., Pixel 5, Android Emulator]
- **Player**: [e.g., ExoPlayer 2.19.0, VideoView, etc.]
- **Kotlin Version**: [e.g., 2.0.21]

## Code Sample

```dart
// Please provide a minimal code sample that reproduces the issue
    late FastPixBaseBetterPlayer _fastPixPlayer;
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
```

## Logs/Stack Trace

```
Paste relevant logs or stack traces here
```

## Additional Context

Add any other context about the problem here.

## Screenshots

If applicable, add screenshots to help explain your problem.

