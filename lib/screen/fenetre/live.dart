import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LivePages extends StatefulWidget {
  const LivePages({super.key});

  @override
  State<LivePages> createState() => _LivePagesState();
}

class _LivePagesState extends State<LivePages> {
  // ✅ URLs testées et qui fonctionnent
  final List<String> videos = [
    'https://stream.mux.com/VZtzUzGRv02OhRnZCxcNg49OilvolTqdnFLEqBsTwaxU/low.mp4',
    'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ];

  final PageController _pageController = PageController();

  VideoPlayerController? _controller;

  bool _isLoading = false;
  bool _hasError = false;
  bool _showControls = true;

  int _currentIndex = 0;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print('🚀 INIT : Chargement de la première vidéo');
        _startVideo(0);
      }
    });
  }

  // ------------------------------------------------------------
  // CHARGER LA VIDEO
  // ------------------------------------------------------------

  Future<void> _startVideo(int index) async {
    final int request = ++_requestId;

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🎬 Chargement vidéo #$index');
    print('🔗 URL : ${videos[index]}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Dispose l'ancien
    final oldController = _controller;
    _controller = null;

    if (oldController != null) {
      try {
        await oldController.dispose();
        print('🗑️ Ancien controller disposé');
      } catch (e) {
        print('⚠️ Dispose ancien : $e');
      }
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    VideoPlayerController? newController;

    try {
      final url = videos[index];
      final uri = Uri.tryParse(url);

      if (uri == null || !uri.hasScheme) {
        throw Exception('URL invalide');
      }

      print('📡 Création du controller...');

      newController = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
          'Accept': '*/*',
          'Accept-Encoding': 'identity',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      print('⏳ Initialisation (timeout 20s)...');
      final startTime = DateTime.now();

      await newController.initialize().timeout(const Duration(seconds: 20));

      final duration = DateTime.now().difference(startTime);
      print('✅ Initialisé en ${duration.inMilliseconds}ms');
      print('   📐 Taille : ${newController.value.size}');
      print('   ⏱️ Durée : ${newController.value.duration}');

      if (!mounted || request != _requestId) {
        print('⚠️ Requête annulée (nouvelle requête en cours)');
        try {
          await newController.dispose();
        } catch (_) {}
        return;
      }

      _controller = newController;
      newController = null;

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = false;
      });

      print('▶️ Lancement de la lecture...');
      try {
        await _controller?.setLooping(true);
        await _controller?.play();
        print('✅ Lecture démarrée');
      } catch (e) {
        print('⚠️ Erreur play : $e');
      }
    } on TimeoutException {
      print('❌ TIMEOUT après 20s');

      if (newController != null) {
        try {
          await newController.dispose();
        } catch (_) {}
      }

      if (!mounted || request != _requestId) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    } catch (e, stack) {
      print('❌ ERREUR : $e');
      print('📚 Stack : $stack');

      if (newController != null) {
        try {
          await newController.dispose();
        } catch (_) {}
      }

      if (!mounted || request != _requestId) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  // ------------------------------------------------------------
  // RETRY
  // ------------------------------------------------------------

  Future<void> _retry() async {
    if (_isLoading) return;
    await _startVideo(_currentIndex);
  }

  // ------------------------------------------------------------
  // CHANGEMENT DE PAGE
  // ------------------------------------------------------------

  void _onPageChanged(int index) {
    if (index == _currentIndex) return;

    print('📄 Changement de page : $index');

    setState(() {
      _currentIndex = index;
      _showControls = true;
    });

    _startVideo(index);
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    print('🗑️ Dispose LivePages');
    _requestId++;
    _pageController.dispose();

    final controller = _controller;
    _controller = null;

    if (controller != null) {
      try {
        controller.dispose();
      } catch (e) {
        print('⚠️ Dispose final : $e');
      }
    }

    super.dispose();
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return _buildPage(index);
        },
      ),
    );
  }

  Widget _buildPage(int index) {
    final isCurrentPage = index == _currentIndex;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black),

        if (isCurrentPage) _buildVideoContent(),

        // Badge LIVE
        Positioned(
          top: 50,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: Colors.white, size: 10),
                SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Info
        Positioned(
          left: 20,
          right: 100,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Live ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Diffusion en direct',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        // Compteur
        Positioned(
          right: 20,
          bottom: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${index + 1}/${videos.length}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),

        // Tap play/pause
        if (isCurrentPage &&
            _controller != null &&
            _controller!.value.isInitialized &&
            !_isLoading &&
            !_hasError)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
                setState(() {});
              },
            ),
          ),
      ],
    );
  }

  // ------------------------------------------------------------
  // CONTENU VIDÉO
  // ------------------------------------------------------------

  Widget _buildVideoContent() {
    if (_hasError) return _buildError();

    if (_isLoading || _controller == null) {
      return _buildLoading();
    }

    // Le controller est forcément initialisé ici
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller!,
      builder: (context, value, child) {
        if (value.hasError) return _buildError();
        if (!value.isInitialized) return _buildLoading();

        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: value.size.width,
              height: value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // CHARGEMENT
  // ------------------------------------------------------------

  Widget _buildLoading() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 35,
              height: 35,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Chargement du live...',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ERREUR
  // ------------------------------------------------------------

  Widget _buildError() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white70, size: 50),
              const SizedBox(height: 12),
              const Text(
                'Live indisponible',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Vérifiez votre connexion Internet.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
