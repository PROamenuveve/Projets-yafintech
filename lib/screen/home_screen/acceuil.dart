import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/screen/home_screen/infos.dart';
import 'package:yafintech/services/secure_storage.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton( onPressed: () {}, icon: Icon(Icons.menu), ),
        title: Text(
          'Nom du fidele',
          maxLines: 3,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/scanner');
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
          IconButton(
            onPressed: () async {
              //await SecureStorageService.logout();
              //context.go('/connexion');
            },
            icon: Icon(Icons.gps_not_fixed),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),

      body: Container(
        color: const Color.fromARGB(255, 205, 200, 216),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 2,
                          color: AppColors.couleur21,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(children: [const MonCarrousel()]),
            ),
          ],
        ),
      ),
    );
  }
}
