import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:yafintech/services/auth_service.dart';
import 'package:yafintech/services/reload_service.dart';

// ============================================================
// PAGE DE CHAT COMPLÈTE
// ============================================================

class ChatPage extends StatefulWidget {
  final int id;
  const ChatPage({super.key, required this.id});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Map<String, dynamic>? msgData;
  late final msgId _msgidservice = msgId(widget.id);
  StreamSubscription? _streamSubscription;

  // ✅ Données hardcodées
  final String contactName = 'Jean Dupont';
  final String? contactAvatar = '';
  final bool isOnline = true;

  bool _hasText = false;
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  String? _filePath;
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;

  List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
    _scrollToBottom();
    _recordSub = _recorder.onStateChanged().listen((state) {
      if (mounted) {
        setState(() => _recordState = state);
      }
    });

    _streamSubscription = _msgidservice.msidStream.listen((data) {
      if (!mounted) return;

      setState(() {
        if (data == null) {
          msgData = null;
          _messages = [];
          return;
        }

        // Normalise TOUJOURS en Map
        if (data is List) {
          msgData = {'messages': data};
        } else if (data is Map<String, dynamic>) {
          msgData = data;
        } else {
          msgData = {'messages': []};
        }

        // Remplit _messages depuis msgData quelle que soit la source
        final raw = msgData?['messages'];
        _messages = (raw is List) ? List<dynamic>.from(raw) : <dynamic>[];

        print('🥛 msgData = msgData');
        print('🏈 _messages.length = _messages');
      });
    });

    _msgidservice.demarrer(interval: const Duration(seconds: 20));
  }

  // ------------------------------------------------------------
  // ENVOYER UN MESSAGE
  // ------------------------------------------------------------
  String _formatHeure(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';

    try {
      // ✅ 1. Parser la date ISO
      final date = DateTime.parse(dateStr)
          .toLocal(); // Local = heure du téléphone

      // ✅ 2. Extraire heures et minutes
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');

      return '$h:$m';
    } catch (e) {
      debugPrint('❌ Erreur parsing date : $e');
      return '';
    }
  }

  void _envoyerMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add({
        'contenu': text,
        'created_at': now.toString(),
        'is_mine': true,
        'lu': false,
      });
      sendMsg(msgData?['contact']['id'], text);
    });

    _controller.clear();
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF6C63FF),
                  /*  backgroundImage: contactAvatar != null
                     ? NetworkImage(contactAvatar!)
                      : null, */
                  child: Text(
                    msgData?['contact']['initiales'].toUpperCase() ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msgData?['contact']['name'] ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isOnline ? 'En ligne' : 'Hors ligne',
                    style: TextStyle(
                      color: isOnline ? Colors.green : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call, color: Color(0xFF6C63FF)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // =========================
          // LISTE DES MESSAGES
          // =========================
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('Aucun message'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return _buildChatBubble(
                        message: msg['contenu'],
                        time: _formatHeure(msg['created_at']),
                        isMe: msg['is_mine'],
                        isRead: msg['lu'] ?? false,
                        index: index,
                      );
                    },
                  ),
          ),

          // =========================
          // ZONE DE SAISIE
          // =========================
          _buildInput(),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BULLE DE MESSAGE
  // ------------------------------------------------------------

  Widget _buildChatBubble({
    required String message,
    required String time,
    required bool isMe,
    required bool isRead,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ✅ Avatar (si pas moi)
          if (!isMe) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[400],
              /* backgroundImage: contactAvatar != null
                  ? NetworkImage(contactAvatar!)
                  : null, */
              child: Text(
                msgData?['contact']['initiales'].toUpperCase() ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // ✅ Bulle
          Flexible(
            child: GestureDetector(
              onLongPress: () => _afficherOptionsMessage(index),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF6C63FF) : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: isMe
                        ? const Radius.circular(18)
                        : const Radius.circular(4),
                    bottomRight: isMe
                        ? const Radius.circular(4)
                        : const Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Nom (si pas moi)
                    if (!isMe) ...[
                      Text(
                        contactName,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],

                    // ✅ Message
                    Text(
                      message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ✅ Heure + lu
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            color: isMe
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            isRead ? Icons.done_all : Icons.done,
                            color: isRead
                                ? Colors.lightBlueAccent
                                : Colors.white.withOpacity(0.7),
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ZONE DE SAISIE
  // ------------------------------------------------------------

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ✅ Bouton pièce jointe
            /*  IconButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Pièce jointe')));
              },
              icon: const Icon(Icons.attach_file, color: Color(0xFF6C63FF)),
            ), */

            // ✅ Champ de saisie
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Écrire un message...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            GestureDetector(
              onTap: _hasText ? _envoyerMessage : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // OPTIONS AU LONG PRESS
  // ------------------------------------------------------------

  void _afficherOptionsMessage(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copier'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Message copié')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Répondre'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                setState(() => _messages.removeAt(index));
                Navigator.pop(context);
                //context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      if (!await _recorder.hasPermission()) {
        debugPrint('❌ Permission refusée');
        return;
      }

      // ✅ 1. Définir le chemin du fichier
      final Directory dir = await getApplicationDocumentsDirectory();
      final String path =
          'yaf/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

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

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _recordSub?.cancel();
    _recorder.dispose();

    _streamSubscription?.cancel();
    _msgidservice.arreter();
    super.dispose();
  }
}
