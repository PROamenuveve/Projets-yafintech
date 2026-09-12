import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:yafintech/services/auth_service.dart';

class ImageCard extends StatefulWidget {
  final String imagePath;
  final String imageName;
  final String imageDescription;
  final bool is_free;
  final String price;

  ImageCard({
    super.key,
    required this.imagePath,
    required this.imageName,
    required this.imageDescription,
    required this.is_free,
    required this.price,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool visible = false;
  bool connected = false;

  void changeVisible() {
    visible = !visible;
  }

  /*   Future<void> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    setState(() {
      connected =
          connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);
    });
  } */
  Future<void> checkConnection() async {
    final result = await checkconnecte();

    if (!mounted) return;

    setState(() {
      connected = result;
    });
  }

  @override
  void initState() {
    super.initState();

    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    //final connected = hasInternetConnection();
    return Card(
      //margin: const EdgeInsets.all(10),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: !connected
                ? SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.wifi_off),
                        Text('pas de connexion'),
                      ],
                    ),
                  )
                : Image.network(
                    widget.imagePath,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: const Color.fromARGB(255, 117, 19, 118),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Chargement ...',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 117, 19, 118),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },

                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      );
                    },
                  ),
          ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    changeVisible();
                  });
                },
                child: Visibility(
                  visible: visible,
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentGeometry.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.imageName,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.imageDescription,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentGeometry.topRight,
                        child: widget.is_free
                            ? IconButton(
                                onPressed: () {},

                                icon: const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              )
                            : TextButton(
                                onPressed: () {},
                                child: Text(
                                  '${widget.price} FCFA',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
