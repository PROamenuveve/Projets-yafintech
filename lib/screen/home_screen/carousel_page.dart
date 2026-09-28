import 'dart:async';

import 'package:flutter/material.dart';

class MonCarrousel extends StatefulWidget {
  const MonCarrousel({super.key});

  @override
  State<MonCarrousel> createState() => _MonCarrouselState();
}

class _MonCarrouselState extends State<MonCarrousel> {
  final PageController _pageController = PageController();

  Timer? _timer;

  int _pageActuelle = 0;

  final List<Widget> containers = [
    InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Container 1',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    ),

    InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Container 2',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    ),
    InkWell(
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
    ),
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_pageController.hasClients) return;

      _pageActuelle++;

      if (_pageActuelle >= containers.length) {
        _pageActuelle = 0;
      }

      _pageController.animateToPage(
        _pageActuelle,
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
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
