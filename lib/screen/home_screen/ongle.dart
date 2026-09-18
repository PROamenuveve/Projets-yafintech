import 'package:flutter/material.dart';
import 'package:yafintech/screen/home_screen/formation.dart';
import 'package:yafintech/screen/home_screen/mesRessource.dart';
import 'package:yafintech/screen/home_screen/ressource.dart';

class Onglets extends StatefulWidget {
  const Onglets({super.key});

  @override
  State<Onglets> createState() => _OngletsState();
}

class _OngletsState extends State<Onglets> {
  @override
  Widget build(BuildContext context) {
    // ✅ 1. On enveloppe tout dans un DefaultTabController

    final TabBarView listOngle = TabBarView(
      children: [
        Center(child: Formation()),
        Center(child: Ressource()),
        Center(child: MesRessource()),
      ],
    );
    return DefaultTabController(
      length: listOngle.children.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes Ressources'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Formations', icon: Icon(Icons.school)),
              Tab(text: 'Ressources', icon: Icon(Icons.folder_open)),
              Tab(text: 'Mes Ressources', icon: Icon(Icons.save_alt)),
            ],
            // Optionnel : rendre les onglets défilables horizontalement
            isScrollable: true,
            // Optionnel : changer la couleur de l'indicateur
            indicatorColor: Colors.white,
          ),
        ),
        // ✅ 3. On ajoute le TabBarView dans le body
        body: listOngle,
      ),
    );
  }
}
