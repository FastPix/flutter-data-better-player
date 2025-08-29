import 'dart:async';
import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:fastpix_better_player_wrapper/valid_events.dart';
import 'package:fastpix_flutter_core_data/fastpix_flutter_core_data.dart';
import 'package:flutter/material.dart';

class FastPixBaseBetterPlayer with PlayerObserver {
  final BetterPlayerController playerController;
  final String workspaceId;
  final String? beaconUrl;
  final bool enabledLogging;
  final PlayerData? playerData;
  final VideoData? videoData;
  final List<CustomData>? customData;
  final String viewerId;
  bool _isPlayerResolutionCalculationDone = false;
  PlayerEvent? _lastDispatchedEvent;
  bool _isEndedCalled = false;
  DateTime? _lastEndedAt;
  DateTime? _lastSeekAt;

  String audioLanguage = 'en';
  double playerWidthSize = 0;
  double playerHeightSize = 0;
  GlobalKey _playerDimensionKey = GlobalKey();
  late FastPixMetrics fastPixMetrics;
  ErrorModel? _errorModel;

  FastPixBaseBetterPlayer._builder(FastPixBaseVideoPlayerBuilder builder)
    : playerController = builder._playerController,
      workspaceId = builder._workspaceId,
      beaconUrl = builder._beaconUrl,
      customData = builder._customData,
      viewerId = builder._viewerId,
      enabledLogging = builder._enabledLogging,
      playerData = builder._playerData,

      videoData = builder._videoData {
    final audioTrack = playerController.betterPlayerAsmsAudioTrack;
    audioLanguage = audioTrack?.language ?? 'en';
    for (var track in playerController.betterPlayerAsmsAudioTracks ?? []) {
      if (track.language != null) {
        audioLanguage = track.language ?? 'en';
        break;
      }
    }
  }

  Future<void> disposeMetrix() async {
    playerController.dispose();
    playerController.removeEventsListener(_onPlayerEvent);
    playerController.removeEventsListener(_oniOSPlayerEvent);
    await fastPixMetrics.dispose(true);
  }

  void start() {
    try {
      // Validate required data before starting
      if (videoData == null || videoData!.videoUrl.isEmpty) {
        throw Exception(
          'Invalid video data: videoData or videoUrl is null/empty',
        );
      }

      if (workspaceId.isEmpty) {
        throw Exception(
          'Invalid configuration: workspaceId is empty',
        );
      }

      if (viewerId.isEmpty) {
        throw Exception('Viewer Id cannot be empty');
      }

      fastPixMetrics =
          FastPixMetricsBuilder()
              .setPlayerObserver(this)
              .setMetricsConfiguration(
                MetricsConfiguration(
                  workspaceId: workspaceId,
                  beaconUrl: beaconUrl,
                  viewerId: viewerId,
                  videoData: videoData,
                  enableLogging: enabledLogging,
                  playerData: playerData,
                  customData: customData,
                ),
              )
              .build();
      _setupEventListener();
    } catch (e) {
      print('Error starting FastPix metrics: $e');
      rethrow;
    }
  }

  void _tryDispatch(PlayerEvent next, {BetterPlayerEvent? event}) {
    final allowed = validTransitions[_lastDispatchedEvent] ?? {};
    if (allowed.contains(next)) {
      if (_lastDispatchedEvent == PlayerEvent.ended &&
          next == PlayerEvent.play) {
        return;
      }
      if (next == PlayerEvent.variantChanged) {
        _handleChangedTrackEvent(event!);
        return;
      }
      if (next == PlayerEvent.error) {
        _errorModel = ErrorModel(
          event?.parameters?['exception'] ?? 'Unknown error',
          event?.parameters?['source'] ?? '503',
        );
      }
      fastPixMetrics.dispatchEvent(next);
      _lastDispatchedEvent = next;
      if (next == PlayerEvent.playing) {
        _isEndedCalled = false;
      }
    } else {
      // ignore invalid transitions
    }
  }

  void _oniOSPlayerEvent(BetterPlayerEvent event) {
    if (!_isPlayerResolutionCalculationDone) {
      _calculatePlayerSize();
    }
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.play:
        _tryDispatch(PlayerEvent.play);
        break;

      case BetterPlayerEventType.progress:
        _calculatePlayerSize();
        if (_lastDispatchedEvent == PlayerEvent.buffering) {
          _tryDispatch(PlayerEvent.buffered);
        }
        if (_lastDispatchedEvent == PlayerEvent.seeking) {
          _tryDispatch(PlayerEvent.seeked);
        }
        if (_lastDispatchedEvent == PlayerEvent.seeked) {
          _tryDispatch(PlayerEvent.play);
        }
        if (_lastDispatchedEvent == PlayerEvent.play) {
          _tryDispatch(PlayerEvent.playing);
        }
        break;

      case BetterPlayerEventType.finished:
        final now = DateTime.now();
        if (_lastEndedAt != null &&
            now.difference(_lastEndedAt!).inSeconds < 2) {
          return;
        }
        _lastEndedAt = now;
        if (!_isEndedCalled) {
          _isEndedCalled = true;
          _lastEndedAt = now;
          _tryDispatch(PlayerEvent.pause);
          _tryDispatch(PlayerEvent.ended);
        }
        break;

      case BetterPlayerEventType.changedTrack:
        _tryDispatch(PlayerEvent.variantChanged, event: event);
        break;

      case BetterPlayerEventType.bufferingStart:
        _tryDispatch(PlayerEvent.buffering);
        break;

      case BetterPlayerEventType.bufferingEnd:
        _tryDispatch(PlayerEvent.buffered);
        break;

      case BetterPlayerEventType.pause:
        _tryDispatch(PlayerEvent.pause);
        break;

      case BetterPlayerEventType.seekTo:
        final now = DateTime.now();
        if (_lastSeekAt != null &&
            now.difference(_lastSeekAt!).inMilliseconds < 500) {
          return;
        }
        _lastSeekAt = now;
        if (_lastDispatchedEvent == PlayerEvent.seeking) {
          _tryDispatch(PlayerEvent.seeked);
        }
        if (_lastDispatchedEvent == PlayerEvent.buffering) {
          _tryDispatch(PlayerEvent.buffered);
        }
        _tryDispatch(PlayerEvent.pause);
        _tryDispatch(PlayerEvent.seeking);
        break;

      case BetterPlayerEventType.exception:
        _tryDispatch(PlayerEvent.error, event: event);
        break;

      default:
        break;
    }
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (!_isPlayerResolutionCalculationDone) {
      _calculatePlayerSize();
    }
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.play:
        _tryDispatch(PlayerEvent.play);
        break;

      case BetterPlayerEventType.progress:
        _calculatePlayerSize();
        if (_lastDispatchedEvent == PlayerEvent.buffering) {
          _tryDispatch(PlayerEvent.buffered);
        }
        if (_lastDispatchedEvent == PlayerEvent.seeking) {
          _tryDispatch(PlayerEvent.seeked);
        }
        if (_lastDispatchedEvent == PlayerEvent.seeked) {
          _tryDispatch(PlayerEvent.play);
        }
        if (_lastDispatchedEvent == PlayerEvent.play) {
          _tryDispatch(PlayerEvent.playing);
        }
        break;

      case BetterPlayerEventType.finished:
        final now = DateTime.now();
        if (_lastEndedAt != null &&
            now.difference(_lastEndedAt!).inSeconds < 2) {
          return;
        }
        _lastEndedAt = now;
        if (!_isEndedCalled) {
          _isEndedCalled = true;
          _lastEndedAt = now;
          _tryDispatch(PlayerEvent.pause);
          _tryDispatch(PlayerEvent.ended);
        }
        break;

      case BetterPlayerEventType.changedTrack:
        _tryDispatch(PlayerEvent.variantChanged, event: event);
        break;

      case BetterPlayerEventType.bufferingStart:
        _tryDispatch(PlayerEvent.buffering);
        break;

      case BetterPlayerEventType.bufferingEnd:
        _tryDispatch(PlayerEvent.buffered);
        break;

      case BetterPlayerEventType.pause:
        _tryDispatch(PlayerEvent.pause);
        break;

      case BetterPlayerEventType.seekTo:
        if (_lastDispatchedEvent == PlayerEvent.seeking) {
          _tryDispatch(PlayerEvent.seeked);
        }
        if (_lastDispatchedEvent == PlayerEvent.buffering) {
          _tryDispatch(PlayerEvent.buffered);
        }
        _tryDispatch(PlayerEvent.pause);
        _tryDispatch(PlayerEvent.seeking);
        break;

      case BetterPlayerEventType.exception:
        _tryDispatch(PlayerEvent.error, event: event);
        break;

      default:
        break;
    }
  }

  void _handleChangedTrackEvent(BetterPlayerEvent event) {
    final paramWidth = event.parameters?['width'];
    final paramHeight = event.parameters?['height'];
    final bitRate = event.parameters?['bitrate'];
    final frameRate = event.parameters?['frameRate'];
    final codec = event.parameters?['codecs'];
    final mimeType = event.parameters?['mimeType'];
    final Map<String, String> attributes = {};
    attributes['width'] =
        (paramWidth ??
                playerController.videoPlayerController?.value.size?.width
                    .toInt())
            .toString();
    attributes['height'] =
        (paramHeight ??
                playerController.videoPlayerController?.value.size?.height
                    .toInt())
            .toString();
    attributes['bitrate'] = bitRate.toString();
    attributes['frameRate'] = frameRate.toString();
    attributes['codecs'] = codec.toString();
    attributes['mimeType'] = mimeType.toString();

    fastPixMetrics.dispatchEvent(
      PlayerEvent.variantChanged,
      attributes: attributes,
    );
  }

  @override
  bool isPlayerAutoPlayOn() {
    return playerController.betterPlayerConfiguration.autoPlay;
  }

  @override
  bool isPlayerFullScreen() {
    return playerController.isFullScreen;
  }

  @override
  bool isPlayerPaused() {
    return playerController.isPlaying() == false;
  }

  @override
  bool isVideoSourceLive() {
    return playerController.isLiveStream();
  }

  @override
  double playerHeight() {
    return playerHeightSize;
  }

  @override
  String playerLanguageCode() {
    return audioLanguage;
  }

  @override
  Future<int> playerPlayHeadTime() async {
    try {
      final position = await playerController.videoPlayerController?.position;
      return position?.inMilliseconds ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  bool playerPreLoadOn() {
    // BetterPlayer doesn't expose preCache directly, so we'll return false as default
    // This is a limitation of the current BetterPlayer API
    return false;
  }

  @override
  double playerWidth() {
    return playerWidthSize;
  }

  @override
  int videoSourceDuration() {
    try {
      return playerController
              .videoPlayerController
              ?.value
              .duration
              ?.inMilliseconds ??
          0;
    } catch (e) {
      return 0;
    }
  }

  @override
  int videoSourceHeight() {
    return playerController.videoPlayerController?.value.size?.height.toInt() ??
        0;
  }

  String _inferMimeTypeFromUrl(String url) {
    if (url.endsWith(".mp4")) return "video/mp4";
    if (url.endsWith(".m3u8")) return "application/x-mpegURL";
    if (url.endsWith(".webm")) return "video/webm";
    if (url.endsWith(".mov")) return "video/quicktime";
    return "application/octet-stream"; // fallback
  }

  @override
  String videoSourceMimeType() {
    return _inferMimeTypeFromUrl(videoData!.videoUrl);
  }

  @override
  String videoSourceUrl() {
    return videoData?.videoUrl ?? "NA";
  }

  @override
  int videoSourceWidth() {
    return playerController.videoPlayerController?.value.size?.width.toInt() ??
        0;
  }

  @override
  String videoThumbnailUrl() {
    return videoData?.videoThumbnailUrl ?? "NA";
  }

  void _calculatePlayerSize() {
    void tryReadSize() {
      final context = _playerDimensionKey.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null &&
            renderBox.hasSize &&
            renderBox.size.width > 0) {
          playerHeightSize = renderBox.size.height;
          playerWidthSize = renderBox.size.width;
          _isPlayerResolutionCalculationDone = true;
          return;
        }
      }
      // Try again on next frame
      WidgetsBinding.instance.addPostFrameCallback((_) => tryReadSize());
    }

    // Start checking size
    WidgetsBinding.instance.addPostFrameCallback((_) => tryReadSize());
  }

  void reportPlayerSize(GlobalKey key) {
    _playerDimensionKey = key;
  }

  @override
  ErrorModel? getPlayerError() {
    return _errorModel;
  }

  void _setupEventListener() {
    if (Platform.isIOS) {
      playerController.addEventsListener(_oniOSPlayerEvent);
    } else {
      playerController.addEventsListener(_onPlayerEvent);
    }
  }
}

class FastPixBaseVideoPlayerBuilder {
  // Required
  final BetterPlayerController _playerController;
  final String _workspaceId;
  final String? _beaconUrl;
  final String _viewerId;

  // Optional with default
  bool _enabledLogging = false;
  PlayerData? _playerData;
  VideoData? _videoData;
  List<CustomData>? _customData;

  FastPixBaseVideoPlayerBuilder({
    required BetterPlayerController playerController,
    required String workspaceId,
    String? beaconUrl,
    required String viewerId,
  }) : _beaconUrl = beaconUrl,
       _workspaceId = workspaceId,
       _playerController = playerController,
       _viewerId = viewerId;

  FastPixBaseVideoPlayerBuilder setEnabledLogging(bool value) {
    _enabledLogging = value;
    return this;
  }

  FastPixBaseVideoPlayerBuilder setCustomData(List<CustomData> value) {
    _customData = value;
    return this;
  }

  FastPixBaseVideoPlayerBuilder setPlayerData(PlayerData? value) {
    _playerData = value;
    return this;
  }

  FastPixBaseVideoPlayerBuilder setVideoData(VideoData? value) {
    _videoData = value;
    return this;
  }

  FastPixBaseBetterPlayer build() {
    return FastPixBaseBetterPlayer._builder(this);
  }
}
