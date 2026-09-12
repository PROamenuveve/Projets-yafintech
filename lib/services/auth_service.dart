import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:yafintech/services/secure_storage.dart';

String baseurl =
    "https://b348-2c0f-f0f8-855-4f00-a9e5-72bc-3d37-3913.ngrok-free.app";

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
      Uri.parse("$baseurl/api/login"),
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
      Uri.parse('${baseurl}/api/register'),
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
      Uri.parse('${baseurl}/api/members'),
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
      Uri.parse('$baseurl/api/super-admin/roles-and-fonctions'),
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

Future<bool> Qr_presence(String qr) async {
  final user = await SecureStorageService.getAccessUser();

  final jsUser = jsonDecode(user ?? '{}');

  print(
    "👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻 $jsUser",
  );
  try {
    final response = await http.post(
      Uri.parse('$baseurl/api/attendance/scan-public'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'qr_token': qr,
        'member_code': jsUser['member']['member_code'],
      }),
    );
    print('🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖  ${response.statusCode}');
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      //print('🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖');
      print(data);
      return true;
    } else {
      print('Erreur : ${response.statusCode}');
      print(response.body);
      return false;
    }
  } catch (e) {
    print('Erreur réseau : $e');
    return false;
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
      Uri.parse('$baseurl/api/members/$userId'),
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

Future<Map<String, dynamic>> getEvent() async {
  final token = await SecureStorageService.getAccessToken();
  try {
    final response = await http.get(
      Uri.parse('$baseurl/api/formations'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
      Uri.parse('$baseurl/api/resources'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${await SecureStorageService.getAccessToken()}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Ressources récupérées avec succès');
      //print(data);
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
