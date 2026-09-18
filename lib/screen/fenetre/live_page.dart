import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:yafintech/core/theme/app_color.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> with WidgetsBindingObserver {
  final TextEditingController _tcontroller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool commente = false;

  double _lastBottomInset = 0;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print('🚀 INIT : Chargement de la première vidéo');
        _startVideo(0);
      }
    });
  }

  // ------------------------------------------------------------
  // ✅ DÉTECTER LA FERMETURE DU CLAVIER
  // ------------------------------------------------------------

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final bottomInset = View.of(context).viewInsets.bottom;

    // ✅ Si le clavier vient de se fermer ET qu'on est en mode commentaire
    if (_lastBottomInset > 0 && bottomInset == 0 && commente) {
      // ✅ Cacher le TextField EN MÊME TEMPS
      if (mounted) {
        setState(() {
          commente = false;
        });
      }
    }

    _lastBottomInset = bottomInset;
  }

  // ------------------------------------------------------------
  // FERMER LE COMMENTAIRE
  // ------------------------------------------------------------

  void _fermerCommentaire() {
    _focusNode.unfocus();
    setState(() {
      commente = false;
    });
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

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        actionLive(),

        // Tap play/pause
        if (isCurrentPage &&
            _controller != null &&
            _controller!.value.isInitialized &&
            !_isLoading &&
            !_hasError)
          Container(),
      ],
    );
  }

  Widget actionLive() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          // ✅ En-tête
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (commente) {
                    _fermerCommentaire();
                    return;
                  }
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "nom de l'eglise",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "description",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
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
            ],
          ),

          const Expanded(child: SizedBox()),

          Container(
            // margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  height: 300,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < 25; i++)
                          Text(
                            'commentaire....',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                commente
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _tcontroller,
                                focusNode: _focusNode,
                                autofocus: true,
                                textInputAction: TextInputAction.send,
                                decoration: InputDecoration(
                                  //hintText: 'Écrire un commentaire...',
                                  //prefixIcon: const Icon(Icons.send),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: AppColors.couleur21,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(width: 3),
                                  ),
                                ),
                                /* onSubmitted: (value) {
                          debugPrint('📤 Envoyé : $value');
                          _controller.clear();
                          _fermerCommentaire();
                        }, */
                              ),
                            ),
                            SizedBox(width: 5),
                            IconButton(
                              onPressed: () {
                                if (commente) {
                                  _fermerCommentaire();
                                  return;
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Color.fromARGB(205, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                commente = true;
                              });
                            },
                            child: Container(
                              height: 45,
                              width: 250,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Commentaire...',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // ✅ Retirer l'observateur
    WidgetsBinding.instance.removeObserver(this);
    _tcontroller.dispose();
    _focusNode.dispose();

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
}
