import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yafintech/services/auth_service.dart';

class LiveServiceActive {
  Timer? _pollingTimer;
  final _liveController = StreamController<Map<String, dynamic>?>.broadcast();

  // ✅ Stream qui émet les données du live en cours (ou null)
  Stream<Map<String, dynamic>?> get liveStream => _liveController.stream;

  Map<String, dynamic>? _currentLive;
  Map<String, dynamic>? get currentLive => _currentLive;

  bool _isPolling = false;

  // ------------------------------------------------------------
  // DÉMARRER LE POLLING
  // ------------------------------------------------------------

  void demarrer({Duration interval = const Duration(seconds: 2)}) {
    if (_isPolling) return;
    _isPolling = true;

    debugPrint(
      '▶️ Démarrage du polling live (toutes les ${interval.inSeconds}s)',
    );

    // Premier appel immédiat
    _fetchActiveLive();

    // Puis appels réguliers
    _pollingTimer = Timer.periodic(interval, (_) => _fetchActiveLive());
  }

  // ------------------------------------------------------------
  // ARRÊTER LE POLLING
  // ------------------------------------------------------------

  void arreter() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
    debugPrint('⏹️ Arrêt du polling live');
  }

  // ------------------------------------------------------------
  // APPEL API
  // ------------------------------------------------------------

  Future<void> _fetchActiveLive() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseurl/live-streams/active'),
            headers: {
              'Authorization': 'Bearer $geToken',
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(const Duration(seconds: 10));

      // ✅ 200 OK : un live est en cours
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Détecter un changement (nouveau live)
        final newLiveId = data['id'];
        final oldLiveId = _currentLive?['id'];

        _currentLive = data;

        if (newLiveId != oldLiveId) {
          debugPrint('🔴 Nouveau live détecté : ${data['title']}');
        }

        _liveController.add(data);
      }
      // ✅ 204 No Content (ou 404) : pas de live en cours
      else if (response.statusCode == 204 || response.statusCode == 404) {
        if (_currentLive != null) {
          debugPrint('⚫ Le live est terminé');
        }

        _currentLive = null;
        _liveController.add(null);
      }
      // ❌ Autre erreur
      else {
        debugPrint('❌ Erreur API : ${response.statusCode}');
        debugPrint('Body : ${response.body}');
      }
    } on TimeoutException {
      debugPrint('⏱️ Timeout lors du fetch du live');
    } catch (e) {
      debugPrint('❌ Exception : $e');
    }
  }

  // ------------------------------------------------------------
  // FORCER UN RAFRAÎCHISSEMENT
  // ------------------------------------------------------------

  Future<void> refresh() async {
    await _fetchActiveLive();
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  void dispose() {
    arreter();
    _liveController.close();
  }
}

class LiveService {
  Timer? _pollingTimer;
  final _liveController = StreamController<Map<String, dynamic>?>.broadcast();

  // ✅ Stream qui émet les données du live en cours (ou null)
  Stream<Map<String, dynamic>?> get liveStream => _liveController.stream;

  Map<String, dynamic>? _currentLive;
  Map<String, dynamic>? get currentLive => _currentLive;

  bool _isPolling = false;

  // ------------------------------------------------------------
  // DÉMARRER LE POLLING
  // ------------------------------------------------------------

  void demarrer({Duration interval = const Duration(seconds: 2)}) {
    if (_isPolling) return;
    _isPolling = true;

    debugPrint(
      '▶️ Démarrage du polling live (toutes les ${interval.inSeconds}s)',
    );

    // Premier appel immédiat
    _fetchActiveLive();

    // Puis appels réguliers
    _pollingTimer = Timer.periodic(interval, (_) => _fetchActiveLive());
  }

  // ------------------------------------------------------------
  // ARRÊTER LE POLLING
  // ------------------------------------------------------------

  void arreter() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
    debugPrint('⏹️ Arrêt du polling live');
  }

  // ------------------------------------------------------------
  // APPEL API
  // ------------------------------------------------------------

  Future<void> _fetchActiveLive() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseurl/live-streams'),
            headers: {
              'Authorization': 'Bearer $geToken',
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(const Duration(seconds: 10));

      // ✅ 200 OK : un live est en cours
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Détecter un changement (nouveau live)
        final newLiveId = data['id'];
        final oldLiveId = _currentLive?['id'];

        _currentLive = data;

        if (newLiveId != oldLiveId) {
          debugPrint('🔴 Nouveau live détecté : ${data['title']}');
        }

        _liveController.add(data);
      }
      // ✅ 204 No Content (ou 404) : pas de live en cours
      else if (response.statusCode == 204 || response.statusCode == 404) {
        if (_currentLive != null) {
          debugPrint('⚫ Le live est terminé');
        }

        _currentLive = null;
        _liveController.add(null);
      }
      // ❌ Autre erreur
      else {
        debugPrint('❌ Erreur API : ${response.statusCode}');
        debugPrint('Body : ${response.body}');
      }
    } on TimeoutException {
      debugPrint('⏱️ Timeout lors du fetch du live');
    } catch (e) {
      debugPrint('❌ Exception : $e');
    }
  }

  // ------------------------------------------------------------
  // FORCER UN RAFRAÎCHISSEMENT
  // ------------------------------------------------------------

  Future<void> refresh() async {
    await _fetchActiveLive();
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  void dispose() {
    arreter();
    _liveController.close();
  }
}

class getFormationService {
  Timer? _pollingTimer;
  final _formationController =
      StreamController<Map<String, dynamic>?>.broadcast();

  // ✅ Stream
  Stream<Map<String, dynamic>?> get formationStream =>
      _formationController.stream;

  Map<String, dynamic>? _currentFormation;
  Map<String, dynamic>? get currentLive => _currentFormation;

  bool _isPolling = false;

  // ------------------------------------------------------------
  // DÉMARRER LE POLLING
  // ------------------------------------------------------------

  void demarrer({Duration interval = const Duration(seconds: 2)}) {
    if (_isPolling) return;
    _isPolling = true;

    debugPrint(
      '▶️ Démarrage du polling formation (toutes les ${interval.inSeconds}s)',
    );

    // Premier appel immédiat
    _fetchActiveLive();

    // Puis appels réguliers
    _pollingTimer = Timer.periodic(interval, (_) => _fetchActiveLive());
  }

  // ------------------------------------------------------------
  // ARRÊTER LE POLLING
  // ------------------------------------------------------------

  void arreter() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
    debugPrint('⏹️ Arrêt du polling formation');
  }

  // ------------------------------------------------------------
  // APPEL API
  // ------------------------------------------------------------

  Future<void> _fetchActiveLive() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseurl/formations'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $geToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final newLiveId = data['id'];
        final oldLiveId = _currentFormation?['id'];

        _currentFormation = data;

        if (newLiveId != oldLiveId) {
          debugPrint('🔴 nouveau formation : ${data['title']}');
        }

        _formationController.add(data);
      } else if (response.statusCode == 204 || response.statusCode == 404) {
        if (_currentFormation != null) {
          debugPrint('⚫ Formation indisponible');
        }

        _currentFormation = null;
        _formationController.add(null);
      }
      // ❌ Autre erreur
      else {
        debugPrint('❌ Erreur API : ${response.statusCode}');
        debugPrint('Body : ${response.body}');
      }
    } on TimeoutException {
      debugPrint('⏱️ Timeout lors du fetch du live');
    } catch (e) {
      debugPrint('❌ Exception : $e');
    }
  }

  // ------------------------------------------------------------
  // FORCER UN RAFRAÎCHISSEMENT
  // ------------------------------------------------------------

  Future<void> refresh() async {
    await _fetchActiveLive();
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  void dispose() {
    arreter();
    _formationController.close();
  }
}

class getRessourceService {
  Timer? _pollingTimer;

  // ✅ Utiliser 'dynamic' pour accepter à la fois les Maps et les Lists
  final _ressourceController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get ressourceStream => _ressourceController.stream;

  dynamic _currentRessource;
  dynamic get currentLive => _currentRessource;

  bool _isPolling = false;

  void demarrer({Duration interval = const Duration(seconds: 2)}) {
    if (_isPolling) return;
    _isPolling = true;

    debugPrint('▶️ Démarrage du polling (toutes les ${interval.inSeconds}s)');
    _fetchActiveLive();
    _pollingTimer = Timer.periodic(interval, (_) => _fetchActiveLive());
  }

  void arreter() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
    debugPrint('⏹️ Arrêt du polling');
  }

  Future<void> _fetchActiveLive() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseurl/resources',
            ), // Assurez-vous que baseurl est défini
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $geToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      // ✅ VÉRIFICATION CRUCIALE : Ne pas continuer si le contrôleur est fermé
      if (_ressourceController.isClosed) return;

      if (response.statusCode == 200) {
        // ✅ Ne pas forcer le typage en Map, accepter le dynamic
        final dynamic data = jsonDecode(response.body);
        _currentRessource = data;

        if (!_ressourceController.isClosed) {
          _ressourceController.add(data);
        }
      } else if (response.statusCode == 204 || response.statusCode == 404) {
        _currentRessource = null;
        if (!_ressourceController.isClosed) {
          _ressourceController.add(null);
        }
      } else {
        debugPrint('❌ Erreur API : ${response.statusCode}');
      }
    } on TimeoutException {
      debugPrint('⏱️ Timeout lors du fetch');
    } catch (e) {
      debugPrint('❌ Exception : $e');
    }
  }

  Future<void> refresh() async => await _fetchActiveLive();

  void dispose() {
    arreter();
    _ressourceController.close();
  }
}

class getMyRessourceService {
  Timer? _pollingTimer;

  // ✅ Utiliser 'dynamic' pour accepter à la fois les Maps et les Lists
  final _myressourceController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get ressourceStream => _myressourceController.stream;

  dynamic _currentMycessource;
  dynamic get currentLive => _currentMycessource;

  bool _isPolling = false;

  void demarrer({Duration interval = const Duration(seconds: 2)}) {
    if (_isPolling) return;
    _isPolling = true;

    debugPrint('▶️ Démarrage du polling (toutes les ${interval.inSeconds}s)');
    _fetchActiveLive();
    _pollingTimer = Timer.periodic(interval, (_) => _fetchActiveLive());
  }

  void arreter() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
    debugPrint('⏹️ Arrêt du polling');
  }

  Future<void> _fetchActiveLive() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseurl/resources',
            ), // Assurez-vous que baseurl est défini
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $geToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      // ✅ VÉRIFICATION CRUCIALE : Ne pas continuer si le contrôleur est fermé
      if (_myressourceController.isClosed) return;

      if (response.statusCode == 200) {
        // ✅ Ne pas forcer le typage en Map, accepter le dynamic
        final dynamic data = jsonDecode(response.body);
        _currentMycessource = data;

        if (!_myressourceController.isClosed) {
          _myressourceController.add(data);
        }
      } else if (response.statusCode == 204 || response.statusCode == 404) {
        _currentMycessource = null;
        if (!_myressourceController.isClosed) {
          _myressourceController.add(null);
        }
      } else {
        debugPrint('❌ Erreur API : ${response.statusCode}');
      }
    } on TimeoutException {
      debugPrint('⏱️ Timeout lors du fetch');
    } catch (e) {
      debugPrint('❌ Exception : $e');
    }
  }

  Future<void> refresh() async => await _fetchActiveLive();

  void dispose() {
    arreter();
    _myressourceController.close();
  }
}
