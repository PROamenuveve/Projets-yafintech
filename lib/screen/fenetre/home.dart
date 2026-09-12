import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/screen/home_screen/acceuil.dart';
import 'package:yafintech/screen/home_screen/discussion.dart';
import 'package:yafintech/screen/home_screen/formation.dart';
import 'package:yafintech/screen/home_screen/moi.dart';
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
    Formation(),
    Ressource(),
    Moi(),
  ];

  void changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
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
            label: 'formation',
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
            label: 'formation',
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
