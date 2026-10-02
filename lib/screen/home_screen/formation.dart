import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yafintech/screen/fenetre/audio_widget.dart';
import 'package:yafintech/screen/fenetre/image_widget.dart';
import 'package:yafintech/screen/fenetre/pdf_widget.dart';
import 'package:yafintech/screen/fenetre/video_widget.dart';
import 'package:yafintech/services/auth_service.dart';
import 'package:yafintech/services/reload_service.dart';

class Formation extends StatefulWidget {
  const Formation({super.key});

  @override
  State<Formation> createState() => _FormationState();
}

class _FormationState extends State<Formation> {
  Map<String, dynamic>? formationData;
  final getFormationService _formationservice = getFormationService();
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = _formationservice.formationStream.listen((data) {
      if (!mounted) return;

      if (data != null) {
        setState(() {
          // Si l'API renvoie directement une liste, on l'emballe dans un Map
          if (data is List) {
            formationData = {'data': data};
          } else {
            formationData = data as Map<String, dynamic>;
          }
          print('📚  : formationData');
        });
      } else {
        setState(() {
          formationData = null;
        });
      }
    });

    _formationservice.demarrer(interval: const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawData = formationData?['data'];

    final List<dynamic> dataList = rawData == null
        ? []
        : (rawData is List ? rawData : [rawData]);
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          if (dataList.isEmpty)
            Container(
              margin: EdgeInsets.all(20),
              alignment: AlignmentGeometry.center,
              height: 120,
              width: double.infinity,
              child: Text(
                'aucune formation n \'est disponible ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          else
            for (final element in dataList)
              if (element is Map)
                PdfCard(
                  pdfPath: "$storageUrl/${element['file_path']}",
                  pdfCover: "$storageUrl/${element['cover_image']}",
                  pdfName: element['title'] ?? 'Sans titre',
                  pdfDescription: element['descripion'] ?? '',
                  is_free: element['is_free'] ?? true,
                  price: element['price'] ?? '00',
                  infos: element['creator'],
                ),

          // for (int i = 0; i < 16; i++) FormationList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _formationservice.arreter();
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
