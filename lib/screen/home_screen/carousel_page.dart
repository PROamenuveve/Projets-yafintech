import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/services/auth_service.dart';
import 'package:yafintech/services/reload_service.dart';

class MonCarrousel extends StatefulWidget {
  const MonCarrousel({super.key});

  @override
  State<MonCarrousel> createState() => _MonCarrouselState();
}

class _MonCarrouselState extends State<MonCarrousel> {
  final PageController _pageController = PageController();
  Map<String, dynamic>? formationData;
  final getFormationService _formationservice = getFormationService();
  StreamSubscription? _streamFormation;

  Map<String, dynamic>? ressourcesData;
  final getRessourceService _ressourceservice = getRessourceService();
  StreamSubscription? _streamRessource;

  Timer? _timer;

  int _pageActuelle = 0;

  List<Widget> get containers => [
    InkWell(
      onTap: () {
        context.push('/ongle', extra: 0);
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.couleur2,
          borderRadius: BorderRadius.circular(20),
          //border: BoxBorder.all(width: 1, color: Colors.green),
        ),

        child: Column(
          children: [
            Text(
              'Formations',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "$storageUrl/${formationData?['data']?.first['cover_image']}",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Text(
                      'chargement',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    );
                  },

                  // ==================================================
                  // ERREUR DE TELECHARGEMENT
                  // ==================================================
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Erreur chargement image : $error');

                    return Text(
                      'Erreur de chargement ',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),

    InkWell(
      onTap: () {
        context.push('/ongle', extra: 1);
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.couleur2,
          borderRadius: BorderRadius.circular(20),
          // border: BoxBorder.all(width: 1, color: Colors.green),
        ),

        child: Column(
          children: [
            Text(
              'Ressources',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "$storageUrl/${ressourcesData?['data']?.last['cover_image']}",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Text(
                      'chargement',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    );
                  },

                  // ==================================================
                  // ERREUR DE TELECHARGEMENT
                  // ==================================================
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Erreur chargement image : $error');

                    return Text(
                      'Erreur de chargement ',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    /*  InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Container 3',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    ), */
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!_pageController.hasClients) return;

      _pageActuelle++;

      if (_pageActuelle >= containers.length) {
        _pageActuelle = 0;
      }

      _pageController.animateToPage(
        _pageActuelle,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastOutSlowIn,
      );
    });

    _streamFormation = _formationservice.formationStream.listen((data) {
      if (!mounted) return;

      if (data != null) {
        setState(() {
          if (data is List) {
            formationData = data;
          } else {
            formationData = data;
          }
          print('🪂 : formationData');
        });
      } else {
        setState(() {
          formationData = null;
        });
      }
    });

    _streamRessource = _ressourceservice.ressourceStream.listen((data) {
      if (!mounted) return;

      if (data != null) {
        setState(() {
          // Si l'API renvoie directement une liste, on l'emballe dans un Map
          if (data is List) {
            ressourcesData = {'data': data};
          } else {
            ressourcesData = data as Map<String, dynamic>;
          }
          print('🪂 : ressourcesData');
        });
      } else {
        setState(() {
          ressourcesData = null;
        });
      }
    });

    _ressourceservice.demarrer(interval: const Duration(seconds: 30));

    _formationservice.demarrer(interval: const Duration(seconds: 30));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _streamFormation?.cancel();
    _formationservice.arreter();
    _streamRessource?.cancel();
    _ressourceservice.arreter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: containers.length,
        onPageChanged: (index) {
          setState(() {
            _pageActuelle = index;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: containers[index],
          );
        },
      ),
    );
  }
}
