import 'package:flutter/material.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/screen/home_screen/acceuil.dart';
import 'package:yafintech/screen/home_screen/discussion.dart';
import 'package:yafintech/screen/home_screen/moi.dart';
import 'package:yafintech/screen/home_screen/ongle.dart';
import 'package:yafintech/screen/home_screen/ressource.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  final List<Widget> _fenetres = <Widget>[
    Acceuil(),
    Discussion(),
    Onglets(),
    Ressource(),
    Moi(),
  ];
  /*  late WebSocketService _ws;
  final List<Map<String, dynamic>> _live = [];
  int _viewersCount = 0;
  bool _isConnected = false; */

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  /*   @override
  void initState() async {
    final token = await SecureStorageService.getAccessToken();
    if (token == null) {
      context.go('/connexion');
    }

    // ✅ Créer le service WebSocket
    _ws = WebSocketService(url: '$baseurl', token: token!);

    // ✅ Écouter les messages reçus
    _ws.messages.listen((data) {
      if (!mounted) return;

      final type = data['type'];

      if (type == 'chat') {
        setState(() {
          _live.add(data);
        });
        //_scrollToBottom();
      } else if (type == 'viewers') {
        setState(() {
          _viewersCount = data['count'] ?? 0;
        });
      } else if (type == 'pong') {
        // Réponse au ping, on ignore
      }
    });

    // ✅ Écouter l'état de connexion
    _ws.connectionStatus.listen((connected) {
      if (!mounted) return;
      setState(() {
        _isConnected = connected;
      });
    });

    // ✅ Se connecter
    _ws.connect();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(backgroundColor: AppColors.couleur21),
      body: Center(child: _fenetres.elementAt(_pageIndex)),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.couleur2,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        currentIndex: _pageIndex,
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.message),
            ),
            label: 'discussion',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.access_alarms),
            ),
            label: 'onglet',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.library_books),
            ),
            label: 'ressources',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person),
            ),
            label: 'moi',
          ),
        ],
      ),
    );
  }

  Widget NavigationBar() {
    return Container(
      //color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 10),
      //decoration: BoxDecoration(borderRadius: BorderRadius.only()),
      child: BottomNavigationBar(
        selectedItemColor: AppColors.couleur2,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        //currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.message),
            ),
            label: 'discussion',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.access_alarms),
            ),
            label: 'onglet',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.library_books),
            ),
            label: 'ressources',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person),
            ),
            label: 'moi',
          ),
        ],
      ),
    );
  }
}
