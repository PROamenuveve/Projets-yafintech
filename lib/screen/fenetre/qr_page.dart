import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/core/outils/outils.dart';
import 'package:yafintech/services/auth_service.dart';
import 'package:yafintech/services/secure_storage.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  Map<String, dynamic> jsUser = {};
  void getUser() async {
    if (mounted) {
      final data = await SecureStorageService.getAccessUser();
      /* if (jsUser == Null) {
        setState(() {
          context.pop();
        });
      } */
      setState(() {
        jsUser = jsonDecode(data ?? '{}');
      });
      print('💀💀💀💀💀💀💀💀');
      print(jsUser['member']['member_code']);
    }
  }

  @override
  void initState() {
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jsUser['name'] ?? 'Utilisateur'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Le QR code avec design
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: jsUser['member']?['member_code'] ?? 'null',
                  version: QrVersions.auto,
                  size: 220,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const SizedBox(height: 30),

              // Boutons
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
