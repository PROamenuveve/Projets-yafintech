import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final bool autoPlay;

  const VideoCard({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
    this.autoPlay = false,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;

  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _controller.initialize();

      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      if (widget.autoPlay) {
        await _controller.play();
      }
    } catch (e) {
      debugPrint('Erreur vidéo : $e');

      if (!mounted) return;

      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _playPause() {
    if (!_isInitialized) return;

    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }

    setState(() {});
  }

  void _rewind() {
    if (!_isInitialized) return;

    final currentPosition = _controller.value.position;

    final newPosition = currentPosition - const Duration(seconds: 10);

    _controller.seekTo(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  void _forward() {
    if (!_isInitialized) return;

    final currentPosition = _controller.value.position;
    final duration = _controller.value.duration;

    final newPosition = currentPosition + const Duration(seconds: 10);

    _controller.seekTo(newPosition > duration ? duration : newPosition);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  // Widget qui affiche le contenu de la vidéo
  Widget _buildVideo() {
    if (_isInitialized) {
      return Column(
        children: [
          // =========================
          // VIDEO
          // =========================
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),

          // =========================
          // BARRE DE PROGRESSION
          // =========================
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),

          // =========================
          // CONTROLES
          // =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // -10 secondes
              IconButton(
                onPressed: _rewind,
                icon: const Icon(Icons.replay_10, size: 30),
              ),

              // PLAY / PAUSE
              IconButton(
                onPressed: _playPause,
                icon: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  size: 45,
                ),
              ),

              // +10 secondes
              IconButton(
                onPressed: _forward,
                icon: const Icon(Icons.forward_10, size: 30),
              ),
            ],
          ),

          // =========================
          // DUREE
          // =========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_controller.value.position)),
                Text(_formatDuration(_controller.value.duration)),
              ],
            ),
          ),
        ],
      );
    }

    if (_hasError) {
      return Container(
        height: 220,
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text(
                'Impossible de charger la vidéo',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    // =========================
    // CHARGEMENT
    // =========================
    return Container(
      height: 220,
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // VIDEO
          // =========================
          _buildVideo(),

          // =========================
          // TITRE
          // =========================
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 12, 15, 5),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),

          // =========================
          // DESCRIPTION
          // =========================
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
