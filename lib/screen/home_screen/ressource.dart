import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/screen/fenetre/audio_widget.dart';
import 'package:yafintech/screen/fenetre/image_widget.dart';
import 'package:yafintech/screen/fenetre/video_widget.dart';
import 'package:yafintech/services/auth_service.dart';
import 'package:video_player/video_player.dart';

class Ressource extends StatefulWidget {
  const Ressource({super.key});

  @override
  State<Ressource> createState() => _RessourceState();
}

class _RessourceState extends State<Ressource> {
  Map<String, dynamic>? ressourcesData;

  void getRessourcesData() async {
    Map<String, dynamic>? ressources = await getRessources();
    if (mounted) {
      if (ressources != null) {
        setState(() {
          ressourcesData = ressources;
          print('🐥🐥🐥🐥🐥🐥🐥🐥');
          if (ressourcesData!['data'] != null) {
            print(ressourcesData!['data'][0]['file_url']);
          } else {
            print('pas de donne recuperer');
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getRessourcesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ressources',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
      ),
      body: Container(
        //margin: EdgeInsets.only(top: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (ressourcesData != null && ressourcesData!['data'] != null)
              for (final element in ressourcesData!['data'] as List)
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
              price: '2500',
            ),
            ImageCard(
              imagePath: 'https://picsum.photos/seed/tech/400/200',
              imageName: 'Sans titre',
              imageDescription: 'la description',
              is_free: true,
              price: '00',
            ),
            AudioCard(
              audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
              title: 'title',
              description: 'description',
              is_free: true,
              price: '00',
            ),
            AudioCard(
              audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
              title: 'title',
              description: 'description',
              is_free: false,
              price: '08',
            ),
            AudioCard(
              audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
              title: 'title',
              description: 'description',
              is_free: true,
              price: '00',
            ),
            AudioCard(
              audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
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
              price: '1000',
            ),

            //for (int i = 0; i < 16; i++) RessourceList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget RessourceList() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            print('Ressource tapped');
            setState(() {
              context.push('/audio');
            });
          },
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/image (6).jpg'),
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
                        'Titre de la ressource',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Description de la ressource',
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
