import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/screen/fenetre/pdf_page.dart';
import 'package:yafintech/screen/fenetre/pdf_widget.dart';
import 'package:yafintech/screen/home_screen/ongle.dart';

import "screen/auth/connexion.dart";
import 'screen/auth/inscription.dart';
import 'screen/auth/inscription_local.dart';
import 'screen/auth/inscription_mail.dart';
import 'screen/auth/inscription_nom.dart';
import 'screen/auth/inscription_profile.dart';
import 'screen/auth/inscription_statut.dart';
import 'screen/auth/password.dart';
import 'screen/fenetre/fn.dart';
import 'screen/fenetre/home.dart';
import 'screen/fenetre/live.dart';
import 'screen/fenetre/live_page.dart';
import 'screen/fenetre/message.dart';
import 'screen/fenetre/qr_page.dart';
import 'screen/fenetre/scanner.dart';
import 'screen/fenetre/profile.dart';
import 'services/audio_handler.dart';
import 'services/secure_storage.dart';

late GoRouter routes;
late MyAudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await SecureStorageService.getAccessToken();
  print('Token from secure storage:📱📱📱📱📱📱 $token');
  routes = GoRouter(
    initialLocation: token == null || token.isEmpty ? '/connexion' : '/',
    //initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(path: '/inscription', builder: (context, state) => Inscription()),
      GoRoute(path: '/fn', builder: (context, state) => Fn()),
      GoRoute(
        path: '/inscriptionNom',
        builder: (context, state) => InscriptionNom(),
      ),
      GoRoute(
        path: '/inscriptionMail',
        builder: (context, state) {
          final nouveauUtilisateur = state.extra as Map<String, dynamic>;
          return InscriptionMail(nouveauUtilisateur: nouveauUtilisateur);
        },
      ),
      GoRoute(
        path: '/inscriptionLocal',
        builder: (context, state) {
          final nouveauUtilisateur = state.extra as Map<String, dynamic>;
          return InscriptionLocal(nouveauUtilisateur: nouveauUtilisateur);
        },
      ),
      GoRoute(
        path: '/inscriptionStatut',
        builder: (context, state) {
          final nouveauUtilisateur = state.extra as Map<String, dynamic>;
          return InscriptionStatut(nouveauUtilisateur: nouveauUtilisateur);
        },
      ),
      GoRoute(path: '/connexion', builder: (context, state) => Connexion()),
      GoRoute(
        path: '/password',
        builder: (context, state) {
          final nouveauUtilisateur = state.extra as Map<String, dynamic>;
          return Password(nouveauUtilisateur: nouveauUtilisateur);
        },
      ),
      GoRoute(
        path: '/inscriptionProfile',
        builder: (context, state) {
          final nouveauUtilisateur = state.extra as Map<String, dynamic>;
          return InscriptionProfile(nouveauUtilisateur: nouveauUtilisateur);
        },
      ),
      GoRoute(path: '/message', builder: (context, state) => Message()),
      GoRoute(path: '/scanner', builder: (context, state) => ScannerPage()),
      GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
      GoRoute(path: '/live', builder: (context, state) => LivePage()),
      GoRoute(path: '/lives', builder: (context, state) => LivePages()),
      GoRoute(path: '/qrPage', builder: (context, state) => QrCodePage()),
      GoRoute(
        path: '/pdf',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};

          return PdfPage(
            pdfPath: extra['pdfPath'] ?? '',
            pdfName: extra['pdfName'] ?? 'Document PDF',
            pdfDescription: extra['pdfDescription'] ?? '',
          );
        },
      ),
    ],
  );

  // ✅ Initialiser le service audio en arrière-plan
  /* audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.yafintech.audio',
      androidNotificationChannelName: 'Lecture audio',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  ); */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routes,
    );
  }
}
