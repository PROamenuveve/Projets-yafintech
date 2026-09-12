import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yafintech/services/auth_service.dart';

class Formation extends StatefulWidget {
  const Formation({super.key});

  @override
  State<Formation> createState() => _FormationState();
}

class _FormationState extends State<Formation> {
  Map<String, dynamic>? formationData;
  Map<String, dynamic>? ressourcesData;

  void getEventeData() async {
    Map<String, dynamic>? formation = await getEvent();
    if (mounted) {
      setState(() {
        formationData = formation;
        print('Formation data: 📚📚📚📚📚📚📚📚📚📚📚📚 $formationData');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Formation',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            /* formationData != null
                  ? buildFormationList()
                  : Center(child : CircularProgressIndicator()),*/

            for (int i = 0; i < 16; i++) FormationList(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getEventeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget FormationList() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            print('Ressource tapped');
          },
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/image (9).jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Titre de la formation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Description de la formation' * 3,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'gratuite',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '12/12/2023',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
