import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/services/reload_service.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  Map<String, dynamic>? ctchatData;
  final ctConversation _ctchatservice = ctConversation();
  StreamSubscription? _streamct;
  bool search = false;
  TextEditingController _searchControler = TextEditingController();

  @override
  void initState() {
    super.initState();

    _streamct = _ctchatservice.ctConversationStream.listen((data) {
      if (!mounted) return;
      if (data != null) {
        setState(() {
          if (data is List) {
            ctchatData = {'data': data};
          } else {
            ctchatData = data as Map<String, dynamic>;
          }

          //print('🤖🤖🤖 :ctchatData');
        });
      } else {
        setState(() {
          ctchatData = null;
        });
      }
    });

    _ctchatservice.demarrer(interval: const Duration(seconds: 20));
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawData = ctchatData?['data'];

    final List<dynamic> dataList = rawData == null
        ? []
        : (rawData is List ? rawData : [rawData]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Discussions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                search = !search;
              });
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),

      body: Column(
        children: [
          if (search)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _searchControler,
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
              ),
            ),
          Expanded(
            child: dataList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Pas de conversation',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount:
                        ctchatData?['data'].length ?? 9, // ✅ dataList partout
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 40),
                    itemBuilder: (context, index) {
                      // lst[index];
                      final conv =
                          ctchatData?['data'][index] ??
                          []; // ✅ dataList partout
                      return _buildConversationItem(context, conv);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(
    BuildContext context,
    Map<String, dynamic> conv,
  ) {
    final hasUnread = (conv['unread_count'] ?? 0) > 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF6C63FF),
            backgroundImage: conv['avatar'] != null
                ? NetworkImage(conv['avatar'])
                : null,
            child: conv['avatar'] == null
                ? Text(
                    conv['initiales'].toUpperCase() ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
          if (conv['isOnline'] == true)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        conv['name'] ?? '',
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          conv['last_message']?['contenu'] ?? '',
          style: TextStyle(
            color: hasUnread ? Colors.black87 : Colors.grey[600],
            fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatHeure(conv['last_message']?['created_at']) ?? '',
            style: TextStyle(
              color: hasUnread ? const Color(0xFF6C63FF) : Colors.grey[600],
              fontSize: 12,
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          if (hasUnread)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${conv['unread_count']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        context.push('/chart', extra: conv?['id'] ?? 69);
        final u = conv?['id'];
        print("😒😒😒😒😒😒 $u ");
      },
    );
  }

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

  @override
  void dispose() {
    _searchControler.dispose();
    _ctchatservice.arreter();
    super.dispose();
  }
}
