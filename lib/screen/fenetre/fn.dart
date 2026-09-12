import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yafintech/core/outils/outils.dart';
import 'package:yafintech/core/theme/app_color.dart';

class Fn extends StatefulWidget {
  const Fn({super.key});

  @override
  State<Fn> createState() => _Fn();
}

bool cherche = false;

class _Fn extends State<Fn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 133, 131, 145),
      appBar: AppBar(
        backgroundColor: AppColors.couleur2,
        automaticallyImplyLeading: false,
        leading: null,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                cherche = !cherche;
                print('object');
              });
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.camera_alt, color: Colors.white),
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
        //title: Text(' le nom'),
      ),
      body: Column(
        children: [
          Visibility(
            visible: cherche,
            child: Container(
              color: const Color.fromARGB(255, 133, 131, 145),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                decoration: AppOutils.inputDecoration(hintText: 'recherche'),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int d = 0; d < 16; d++)
                    InkWell(
                      onTap: () {
                        print('cliké ');
                      },
                      child: Container(
                        height: 75,
                        margin: EdgeInsets.only(top: .5),
                        padding: EdgeInsets.all(1),
                        color: const Color.fromARGB(255, 133, 131, 145),
                        child: Row(
                          children: [
                            Container(
                              height: 74,
                              width: 74,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: const AssetImage(
                                  'assets/images/image (2).jpg',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'nom ${d + 1}',
                                      style: GoogleFonts.abel(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      ' message',
                                      style: GoogleFonts.abel(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.blue,
                                    child: const Text(
                                      '8',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '11:00',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
