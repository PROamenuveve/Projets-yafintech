import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/screen/fenetre/chatIA.dart';
import 'package:yafintech/screen/fenetre/chatlist.dart';
import 'package:yafintech/screen/fenetre/chatlistIA.dart';
import 'package:yafintech/screen/fenetre/profile.dart';
import 'package:yafintech/screen/home_screen/evenement.dart';
import 'package:yafintech/screen/home_screen/acceuil.dart';
import 'package:yafintech/screen/home_screen/discussion.dart';
import 'package:yafintech/screen/home_screen/moi.dart';
import 'package:yafintech/screen/home_screen/ongle.dart';
import 'package:yafintech/screen/home_screen/ressource.dart';
import 'package:yafintech/services/reload_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  final List<Widget> _fenetres = <Widget>[
    Acceuil(),
    ChatListPage(),
    ChatIAPage(),
    EventPage(),
    //Onglets(),
    ProfilePage(),
  ];

  int unRead = 0;
  final unreadMsg _unReadservice = unreadMsg();
  StreamSubscription? _streamSubscription;

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _streamSubscription = _unReadservice.unreadMsgStream.listen((data) {
      if (data != null) {
        setState(() {
          unRead = data['unread_count'];

          print('🚠🚠🚠🚠🚠🚠🚠🚠🚠🚠 :$unRead');
        });
      } else {
        setState(() {
          unRead = 0;
        });
      }
    });

    _unReadservice.demarrer(interval: const Duration(seconds: 20));
  }

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
            icon: Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.message),
                ),
                if (unRead >= 1)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red, //
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          unRead.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
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
              child: Icon(Icons.support_agent),
            ),
            label: 'assistance',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.event),
            ),
            label: 'evenement',
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

  /*   Widget NavigationBar() {
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
  } */

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _unReadservice.arreter();
    super.dispose();
  }
}
