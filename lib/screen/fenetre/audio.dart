import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderWidget extends StatefulWidget {
  const AudioRecorderWidget({super.key});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  String? _filePath;
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;

  @override
  void initState() {
    super.initState();
    _checkPermission();

    // ✅ Écouter les changements d'état
    _recordSub = _recorder.onStateChanged().listen((state) {
      if (mounted) {
        setState(() => _recordState = state);
      }
    });
  }

  // ------------------------------------------------------------
  // VÉRIFIER LA PERMISSION
  // ------------------------------------------------------------

  Future<void> _checkPermission() async {
    if (await _recorder.hasPermission()) {
      debugPrint('✅ Permission accordée');
    } else {
      debugPrint('❌ Permission refusée');
    }
  }

  // ------------------------------------------------------------
  // DÉMARRER L'ENREGISTREMENT
  // ------------------------------------------------------------

  Future<void> _startRecording() async {
    try {
      if (!await _recorder.hasPermission()) {
        debugPrint('❌ Permission refusée');
        return;
      }

      // ✅ 1. Définir le chemin du fichier
      final Directory dir = await getApplicationDocumentsDirectory();
      final String path =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      //'${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // ✅ 2. Configuration
      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        numChannels: 1,
        bitRate: 128000,
      );

      // ✅ 3. Démarrer (retourne void, le chemin est déjà connu)
      await _recorder.start(config, path: path);

      if (!mounted) return;

      setState(() {
        _isRecording = true;
        _isPaused = false;
        _filePath = path;
      });

      debugPrint('🎙️ Enregistrement démarré : $path');
    } catch (e) {
      debugPrint('❌ Erreur start : $e');
    }
  }

  // ------------------------------------------------------------
  // METTRE EN PAUSE
  // ------------------------------------------------------------

  Future<void> _pauseRecording() async {
    try {
      await _recorder.pause();
      if (!mounted) return;
      setState(() => _isPaused = true);
      debugPrint('⏸️ Enregistrement en pause');
    } catch (e) {
      debugPrint('❌ Erreur pause : $e');
    }
  }

  // ------------------------------------------------------------
  // REPRENDRE
  // ------------------------------------------------------------

  Future<void> _resumeRecording() async {
    try {
      await _recorder.resume();
      if (!mounted) return;
      setState(() => _isPaused = false);
      debugPrint('▶️ Enregistrement repris');
    } catch (e) {
      debugPrint('❌ Erreur resume : $e');
    }
  }

  // ------------------------------------------------------------
  // ARRÊTER
  // ------------------------------------------------------------

  Future<void> _stopRecording() async {
    try {
      // ✅ stop() retourne le chemin final du fichier
      final path = await _recorder.stop();

      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _isPaused = false;
        _filePath = path;
      });

      debugPrint('✅ Enregistrement sauvegardé : $path');
    } catch (e) {
      debugPrint('❌ Erreur stop : $e');
    }
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    _recordSub?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enregistrement audio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Statut
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              size: 80,
              color: _isRecording
                  ? (_isPaused ? Colors.orange : Colors.red)
                  : Colors.grey,
            ),
            const SizedBox(height: 20),

            Text(
              _isRecording
                  ? (_isPaused ? 'En pause' : 'Enregistrement en cours...')
                  : 'Prêt à enregistrer',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // ✅ Boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouton principal (Démarrer / Arrêter)
                FloatingActionButton.large(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  backgroundColor: _isRecording ? Colors.red : Colors.green,
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                // Bouton Pause / Reprendre
                if (_isRecording) ...[
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _isPaused ? _resumeRecording : _pauseRecording,
                    backgroundColor: Colors.orange,
                    child: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 40),

            // ✅ Afficher le chemin du fichier
            if (_filePath != null && !_isRecording)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      '✅ Enregistrement sauvegardé :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _filePath!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
