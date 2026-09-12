import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/screen/auth/connexion.dart';
import 'package:yafintech/screen/auth/inscription.dart';
import 'package:yafintech/screen/auth/inscription_local.dart';
import 'package:yafintech/screen/auth/inscription_mail.dart';
import 'package:yafintech/screen/auth/inscription_nom.dart';
import 'package:yafintech/screen/auth/inscription_profile.dart';
import 'package:yafintech/screen/auth/inscription_statut.dart';
import 'package:yafintech/screen/auth/password.dart';
import 'package:yafintech/screen/fenetre/fn.dart';
import 'package:yafintech/screen/fenetre/home.dart';
import 'package:yafintech/screen/fenetre/message.dart';
import 'package:yafintech/screen/fenetre/scanner.dart';
import 'package:yafintech/screen/fenetre/profile.dart';
import 'package:yafintech/services/audio_handler.dart';
import 'package:yafintech/services/secure_storage.dart';

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
