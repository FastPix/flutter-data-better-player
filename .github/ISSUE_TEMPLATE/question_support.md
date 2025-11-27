---
name: Question/Support
about: Ask questions or get help with the FastPix Resumable Uploads SDK
title: '[QUESTION] '
labels: ['question', 'needs-triage']
assignees: ''
---

# Question/Support

Thank you for reaching out! We're here to help you with the FastPix Resumable Uploads SDK. Please provide the following information:

## Question Type
- [ ] How to use a specific feature
- [ ] Integration help
- [ ] Configuration question
- [ ] Performance question
- [ ] Troubleshooting help
- [ ] Other: _______________

## Question
**What would you like to know?**

<!-- Please provide a clear, specific question -->

## What You've Tried
**What have you already attempted to solve this?**

```dart
import 'package:fastpix_data_better_player/fastpix_data_better_player.dart';

// Your attempted code here
```

## Current Setup
**Describe your current setup:**

## Environment
- **SDK Version**: [e.g., 1.2.2]
- **Android Version**: [e.g., Android 12]
- **Min SDK Version**: [e.g., 24]
- **Target SDK Version**: [e.g., 35]
- **Device/Emulator**: [e.g., Pixel 5, Android Emulator]
- **Player**: [e.g., ExoPlayer 2.19.0, VideoView, etc.]
- **Kotlin Version**: [e.g., 2.0.21]

## Configuration
```dart
// Your current SDK configuration (remove sensitive information)
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

## Expected Outcome
**What are you trying to achieve?**

<!-- Describe your end goal -->

## Error Messages (if any)
```
<!-- If you're getting errors, paste them here -->
```

## Additional Context

### Use Case
**What are you building?**

- [ ] Web application
- [ ] Mobile app (web-based)
- [ ] File upload service
- [ ] Media upload platform
- [ ] Other: _______________


### Timeline
**When do you need this resolved?**

- [ ] ASAP (blocking development)
- [ ] This week
- [ ] This month
- [ ] No rush

### Resources Checked
**What resources have you already checked?**

- [ ] README.md
- [ ] Documentation
- [ ] Examples
- [ ] Stack Overflow
- [ ] GitHub Issues
- [ ] Other: _______________

## Priority
Please indicate the urgency:

- [ ] Critical (Blocking production deployment)
- [ ] High (Blocking development)
- [ ] Medium (Would like to know soon)
- [ ] Low (Just curious)

## Checklist
Before submitting, please ensure:

- [ ] I have provided a clear question
- [ ] I have described what I've tried
- [ ] I have included my current setup
- [ ] I have checked existing documentation
- [ ] I have provided sufficient context

---

**We'll do our best to help you get unstuck! 🚀**

**For urgent issues, please also consider:**
- [FastPix Documentation](https://docs.fastpix.io/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/fastpix)
- [GitHub Discussions](https://github.com/FastPix/web-uploads-sdk/discussions)
