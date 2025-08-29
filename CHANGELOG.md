# Changelog

All notable changes to the FastPix Better Player Wrapper project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-08-29

### Added
- **Core Plugin Structure**: Complete Flutter plugin architecture with Android and iOS platform support
- **BetterPlayer Integration**: Seamless wrapper around BetterPlayer with full API compatibility
- **FastPix Analytics Integration**: Comprehensive video player metrics and tracking system
- **Cross-Platform Support**: Native implementation for both Android (Kotlin) and iOS platforms
- **Event Tracking System**: Automatic tracking of all major player events including:
  - Player initialization and ready state
  - Play, pause, and completion events
  - Seeking and buffering operations
  - Resolution and quality changes
  - Error handling and reporting
- **Builder Pattern Implementation**: Clean and intuitive API using builder pattern for configuration
- **Real-time Metrics Collection**: Live tracking of player performance, user engagement, and playback quality
- **Custom Data Support**: Ability to attach custom metadata and analytics data to video sessions
- **Player Dimension Tracking**: Automatic detection and reporting of player size and resolution
- **Audio Language Detection**: Support for multiple audio tracks and language identification
- **Comprehensive Error Handling**: Robust error tracking with detailed error models and reporting
- **Logging System**: Optional detailed logging for debugging and development purposes
- **Performance Optimization**: Efficient event handling with debouncing for iOS seek operations
- **Memory Management**: Proper resource cleanup and disposal methods
- **Flutter Core SDK Integration**: Built-in integration with FastPix core analytics SDK

### Technical Features
- **Platform Interface**: Implements `PlayerObserver` interface for analytics integration
- **Event Listener Management**: Efficient event handling with BetterPlayer event system
- **State Management**: Comprehensive player state tracking and management
- **Configuration Management**: Flexible configuration system with required and optional parameters
- **Type Safety**: Full Dart type safety with null safety support
- **Performance Monitoring**: Real-time performance metrics and analytics data collection
