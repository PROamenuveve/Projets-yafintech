import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/core/theme/app_font.dart';
import 'package:yafintech/services/auth_service.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool scanned = false;
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'YAFINTECH',
            style: AppFonts.font1Gras.copyWith(
              color: AppColors.couleur1,
              fontSize: 50,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller: controller,

            onDetect: (capture) async {
              if (scanned) return;

              for (final barcode in capture.barcodes) {
                final String? value = barcode.rawValue;

                if (value != null) {
                  scanned = true;

                  try {
                    final jsValue = jsonDecode(value);
                    if (jsValue['t'] == null) {
                      throw Exception('QR invalide');
                    }

                    final presence = await Qr_presence(jsValue['t']);

                    await controller.stop();
                    if (presence) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('presence validé '),
                          duration: Duration(seconds: 1),
                          backgroundColor: Color.fromARGB(255, 36, 242, 42),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('QR_CODE expiré !'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Color.fromARGB(255, 241, 55, 42),
                        ),
                      );
                    }

                    if (!mounted) return;

                    context.pop();
                  } catch (e) {
                    scanned = false;

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('QR_CODE invalide !'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color.fromARGB(255, 241, 55, 42),
                      ),
                    );
                  }

                  return;
                }
              }
            },
          ),

          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
