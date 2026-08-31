import 'package:better_player_plus/better_player_plus.dart';
import 'package:fastpix_data_better_player/fastpix_data_better_player.dart';
import 'package:fastpix_flutter_core_data/fastpix_flutter_core_data.dart';
import 'package:flutter/material.dart';

// Prefilled sample playback ID. No default workspace ID — users enter theirs.
const String _samplePlaybackId = '7c8d5087-edf7-462f-a1b3-e2fbd30747fa';

// FastPix serves HLS as https://stream.fastpix.io/<playbackId>.m3u8
String _streamUrl(String playbackId) =>
    'https://stream.fastpix.io/$playbackId.m3u8';

void main() => runApp(const FastPixExampleApp());

class FastPixExampleApp extends StatelessWidget {
  const FastPixExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastPix Better Player Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF568BFF)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _workspaceIdController = TextEditingController();
  final _playbackIdController = TextEditingController(text: _samplePlaybackId);

  @override
  void dispose() {
    _workspaceIdController.dispose();
    _playbackIdController.dispose();
    super.dispose();
  }

  void _play() {
    final workspaceId = _workspaceIdController.text.trim();
    final playbackId = _playbackIdController.text.trim();
    if (workspaceId.isEmpty || playbackId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter both Workspace ID and Playback ID'),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PlayerScreen(workspaceId: workspaceId, playbackId: playbackId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FastPix Better Player')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'BetterPlayer + FastPix analytics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _workspaceIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Workspace ID',
                  hintText: 'e.g. 1177266527498207235',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _playbackIdController,
                decoration: const InputDecoration(
                  labelText: 'Playback ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play video'),
                onPressed: _play,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.workspaceId,
    required this.playbackId,
  });

  final String workspaceId;
  final String playbackId;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final BetterPlayerController _controller;
  late final FastPixBaseBetterPlayer _fastPix;
  final GlobalKey _playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    final streamUrl = _streamUrl(widget.playbackId);

    _controller = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        streamUrl,
      ),
    );

    _fastPix =
        FastPixBaseVideoPlayerBuilder(
              playerController: _controller,
              workspaceId: widget.workspaceId,
              // The beacon validates viewerId (fpviid) as a UUID — a plain string 400s.
              viewerId: 'b2c9a1e4-3d6f-4a8b-9c1d-2e5f7a0b3c4d',
            )
            .setVideoData(
              VideoData(
                videoSourceUrl: streamUrl,
                videoTitle: 'FastPix Better Player Demo',
                fpPlaybackId: widget.playbackId,
              ),
            )
            .setPlayerData(PlayerData('better_player', '1.0.8'))
            .setCustomData(
              CustomData(
                'flutter-example',
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
              ),
            )
            .setEnabledLogging(true)
            .build();

    // Let the SDK read the rendered player dimensions.
    _fastPix.reportPlayerSize(_playerKey);
    _fastPix.start();
  }

  @override
  void dispose() {
    // disposeMetrix() flushes final metrics and disposes the controller.
    _fastPix.disposeMetrix();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: Center(
        child: AspectRatio(
          key: _playerKey,
          aspectRatio: 16 / 9,
          child: BetterPlayer(controller: _controller),
        ),
      ),
    );
  }
}
