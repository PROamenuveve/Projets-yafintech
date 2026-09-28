import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/screen/home_screen/carousel_page.dart';
import 'package:yafintech/services/auth_service.dart';
import 'package:yafintech/services/secure_storage.dart';
import 'package:yafintech/services/reload_service.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> with SingleTickerProviderStateMixin {
  Map<String, dynamic> jsUser = {};
  final LiveServiceActive _liveService = LiveServiceActive();
  Map<String, dynamic>? _live;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    userGet();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _liveService.liveStream.listen((live) {
      if (!mounted) return;

      setState(() {
        _live = live;
        print('💿💿💿💿💿💿💿💿💿  live');
      });

      _updateAnimation();
    });

    // ✅ 4. Démarrer le polling
    _liveService.demarrer(interval: const Duration(seconds: 30));
  }

  void userGet() async {
    try {
      final data = await getUser();

      if (!mounted) return;

      setState(() {
        jsUser = Map<String, dynamic>.from(data);
      });

      debugPrint('✅ jsUser mis à jour : ${jsUser?['name']}');
    } catch (e) {
      debugPrint('❌ Erreur userGet : $e');
    }
  }

  bool _isLiveActive() {
    if (_live == null) return false;
    final data = _live!['data'];
    if (data == null || data is! Map) return false;
    return data['status'] == 'live';
  }

  void _updateAnimation() {
    if (_isLiveActive()) {
      // ✅ Live actif → démarrer la pulsation
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      // ❌ Pas de live → arrêter la pulsation
      if (_pulseController.isAnimating) {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          jsUser?['name'] ?? 'Nom ',
          maxLines: 3,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/live');
            },
            icon: _isLiveActive()
                ? ScaleTransition(
                    scale: _pulseAnimation,
                    child: const Icon(
                      Icons.circle,
                      size: 25,
                      color: Colors.green,
                    ),
                  )
                : const Icon(
                    Icons.circle,
                    size: 25,
                    color: Color.fromARGB(255, 147, 87, 83),
                  ),
          ),
          IconButton(
            onPressed: () => context.push('/scanner'),
            icon: const Icon(Icons.qr_code_scanner),
          ),
          IconButton(
            onPressed: () async {
              // context.push('/audio');
            },
            icon: const Icon(Icons.gps_not_fixed),
          ),
          IconButton(
            onPressed: () {
              //context.push('/event');
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        //color: const Color.fromARGB(255, 205, 200, 216),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
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
                  ),
                ],
              ),
            ),
            const SingleChildScrollView(
              child: Column(children: [MonCarrousel()]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _liveService.dispose();
    super.dispose();
  }
}
