import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:yafintech/screen/fenetre/home.dart';
import 'package:yafintech/services/secure_storage.dart';

String baseurl =
    "https://95d0-2c0f-f0f8-855-4f00-901f-a468-f47c-d798.ngrok-free.app/api";
String storageUrl =
    'http://95d0-2c0f-f0f8-855-4f00-901f-a468-f47c-d798.ngrok-free.app/storage';

Future<Map<String, dynamic>> getUser() async {
  final data = await SecureStorageService.getAccessUser();

  if (data == null || data.isEmpty) {
    return {};
  }

  return jsonDecode(data) as Map<String, dynamic>;
}

Future<String> geToken() async {
  final token = await SecureStorageService.getAccessToken();

  if (token == null || token.isEmpty) {
    return '';
  }
  return token;
}

Future<bool> checkconnecte() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi) ||
      connectivityResult.contains(ConnectivityResult.ethernet);
}

Future<bool> login(String email, String password) async {
  print("$email,  🧶🧶🧶🧶🧶🧶🧶  $password ");
  try {
    final response = await http.post(
      Uri.parse("$baseurl/login"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];
      print('Connexion réussie');
      print('Token : $token');
      print(data['user']);

      await SecureStorageService.saveTokens(accessToken: token);
      await SecureStorageService.saveUser(accessUser: jsonEncode(data['user']));
      return (true);
    } else {
      print(data['message'] ?? 'Identifiants incorrects');
      return (false);
    }
  } catch (e) {
    print('Erreur : $e');
    return (false);
  }
}

Future<String> register(Map<String, dynamic> donnes) async {
  try {
    final response = await http.post(
      Uri.parse('${baseurl}/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },

      body: jsonEncode(donnes),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final token = data['token'];
      print('Inscription  réussie');
      print('Token : $token');
      print(data['user']);
      await SecureStorageService.saveTokens(accessToken: token);
      await SecureStorageService.saveUser(accessUser: jsonEncode(data['user']));
      final gg = response.statusCode;
      print('🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗 $gg');
      return data['message'];
    } else {
      print('♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️');

      print(data['message'] ?? "erreur l'ors de l'incscription ");
      return data['message'];
    }
  } catch (e) {
    print('Erreur : $e');
    return 'erreur du serveur';
  }
}

Future<void> register_Menber(Map<String, dynamic> donnes) async {
  Map nn = donnes;
  print('$nn 🧶🧶🧶🧶🧶');
  try {
    final response = await http.post(
      Uri.parse('${baseurl}/members'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },

      body: jsonEncode(donnes),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final token = data['token'];
      print('Inscription de menbre réussie');
      print('Token : $token');
      //return true;
    } else {
      print(data['message'] ?? "erreur l'ors de l'incscription ");
      //return false;
    }
  } catch (e) {
    print('Erreur : $e');
    //return false;
  }
}

Future<void> role_fonction() async {
  try {
    final response = await http.get(
      Uri.parse('$baseurl/super-admin/roles-and-fonctions'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },

      //body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print('🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖');
      print(data);
    } else {
      print('Erreur : ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Erreur réseau : $e');
  }
}

Future<int> Qr_presence(String qr, double latitude, double longitude) async {
  final user = await SecureStorageService.getAccessUser();

  final jsUser = jsonDecode(user ?? '{}');

  print(
    "👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻 $jsUser",
  );
  try {
    final response = await http.post(
      Uri.parse('$baseurl/attendance/scan-public'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'qr_token': qr,
        'member_code': jsUser['member']['member_code'],
        'lat': latitude,
        'lng': longitude,
      }),
    );
    print('🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖  ${response.statusCode}');
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      //print('🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖');
      print(data);
      return response.statusCode;
    } else {
      print('Erreur : ${response.statusCode}');
      print(response.body);
      return response.statusCode;
    }
  } catch (e) {
    print('Erreur réseau : $e');
    return 0;
  }
}

Future<void> logout() async {
  await SecureStorageService.logout();
}

Future<void> updateProfile(Map<String, dynamic> updatedData) async {
  final user = await SecureStorageService.getAccessUser();
  final jsUser = jsonDecode(user ?? '{}');
  final userId = jsUser['id'];

  try {
    final response = await http.put(
      Uri.parse('$baseurl/members/$userId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Profil mis à jour avec succès');
      print(data);
      // Mettre à jour les informations de l'utilisateur dans le stockage sécurisé
      await SecureStorageService.saveUser(accessUser: jsonEncode(data['user']));
    } else {
      print('Erreur lors de la mise à jour du profil : ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Erreur réseau : $e');
  }
}

Future<Map<String, dynamic>> getFormation() async {
  try {
    final response = await http.get(
      Uri.parse('$baseurl/formations'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $geToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Formations récupérées avec succès');
      //print(data);
      return data;
    } else {
      print(
        'Erreur lors de la récupération des formations : ${response.statusCode}',
      );
      //print(response.body);
      return {'error': 'Erreur lors de la récupération des formations'};
    }
  } catch (e) {
    print('Erreur réseau : $e');
    return {'error': 'Erreur réseau'};
  }
}

Future<Map<String, dynamic>> getRessources() async {
  try {
    final response = await http.get(
      Uri.parse('$baseurl/resources'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $geToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Ressources récupérées avec succès');
      print(data);
      return data;
    } else {
      print(
        'Erreur lors de la récupération des ressources : ${response.statusCode}',
      );
      print(response.body);
      return {'error': 'Erreur lors de la récupération des ressources'};
    }
  } catch (e) {
    print('Erreur réseau : $e');
    return {'error': 'Erreur réseau'};
  }
}

Future<void> resourceCategorie() async {
  try {
    final response = await http.get(
      Uri.parse('$baseurl/resource-categories'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $geToken',
      },

      //body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print('🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖');
      print(data);
    } else {
      print('Erreur : ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Erreur réseau : $e');
  }
}
