import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yafintech/screen/fenetre/audio_widget.dart';
import 'package:yafintech/screen/fenetre/image_widget.dart';
import 'package:yafintech/screen/fenetre/video_widget.dart';
import 'package:yafintech/services/auth_service.dart';

class Formation extends StatefulWidget {
  const Formation({super.key});

  @override
  State<Formation> createState() => _FormationState();
}

class _FormationState extends State<Formation> {
  Map<String, dynamic>? formationData;

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
            if (formationData != null && formationData!['data'] != null)
              for (final element in formationData!['data'] as List)
                if (element is Map && element['type'] != null)
                  if (element['type'] == "video")
                    VideoCard(
                      videoUrl: element['file_url'] ?? 'https://storage.googleapis.com/exoplayer-test-media-1/mp4/android-screens-10s.mp4',
                      title: element['title'] ?? 'Sans titre',
                      description: element['description'] ?? '',
                      is_free: element['is_free'] ?? true,
                      price: element['price'] ?? 00,
                    )
                  else if (element['type'] == "image")
                    ImageCard(
                      imagePath: element['file_url'] ?? '',
                      imageName: element['title'] ?? 'Sans titre',
                      imageDescription: element['descripion'] ?? '',
                      is_free: element['is_free'] ?? true,
                      price: element['price'] ?? '00',
                    ),
            VideoCard(
              videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
              title: 'Sans titre',
              description: 'de la description',
              is_free: true,
              price: '00',
            ),
            VideoCard(
              videoUrl: 'https://storage.googleapis.com/exoplayer-test-media-1/mp4/android-screens-10s.mp4',
              title: 'Sans titre',
              description: '',
              is_free: false,
              price: '5000',
            ),
            ImageCard(
              imagePath: 'https://picsum.photos/seed/tech/400/200',
              imageName: 'Sans titre',
              imageDescription: 'la description',
              is_free: true,
              price: '00',
            ),
            AudioCard(
              audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
              title: 'title',
              description: 'description',
              is_free: true,
              price: '00',
            ),
            AudioCard(
              audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
              title: 'title',
              description: 'description',
              is_free: false,
              price: '08',
            ),
            AudioCard(
              audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
              title: 'title',
              description: 'description',
              is_free: true,
              price: '00',
            ),
            AudioCard(
              audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3',
              title: 'title',
              description: 'description',
              is_free: true,
              price: '00',
            ),
            ImageCard(
              imagePath: 'https://picsum.photos/id/10/400/200',
              imageName: 'Sans titre',
              imageDescription: 'description',
              is_free: false,
              price: '1200',
            ),

            // for (int i = 0; i < 16; i++) FormationList(),
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
