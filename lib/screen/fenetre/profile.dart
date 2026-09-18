import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yafintech/core/outils/outils.dart';
import 'package:yafintech/services/auth_service.dart';
import 'package:yafintech/services/secure_storage.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilePage> {
  Map<String, dynamic> jsUser = {};
  Map<String, dynamic> newUser = {};
  File? _profileImage;

  void userGet() async {
    final data = await getUser();
    setState(() {
      jsUser = Map<String, dynamic>.from(data);
    });

    print("🖇️🖇️🖇️🖇️🖇️🖇️🖇️🖇️🖇️🖇️🖇️🖇️🖇️: $jsUser");
  }

  @override
  void initState() {
    super.initState();
    userGet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Profil'),
        //backgroundColor: Colors.blue,
        //foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop('/');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              context.push('/qrPage');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(2),
        child: Column(
          children: [
            _ProfilePhoto(),
            AppOutils.espace20,
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color.fromARGB(255, 108, 91, 91),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    _information(
                      icon: Icons.person,
                      title: 'Nom complet',
                      subtitle: jsUser['name'] ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: jsUser['email'] ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.phone,
                      title: 'Téléphone',
                      subtitle: jsUser['phone'] ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.location_on,
                      title: 'Adresse',
                      subtitle: jsUser['address'] ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.work,
                      title: 'Statut',
                      subtitle: jsUser['status']?.toString() ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.calendar_today,
                      title: 'Date de naissance',
                      subtitle: jsUser['birth_date'] ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.person_outline,
                      title: 'Genre',
                      subtitle: jsUser['gender'] ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.church,
                      title: 'Nom de l\'eglise',
                      subtitle: jsUser['church_name'] ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.work,
                      title: 'fonction',
                      subtitle: jsUser['fonction']?['name'] ?? 'non defini',
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    _information(
                      icon: Icons.info_outline,
                      title: 'Rôle',
                      subtitle: jsUser['role']?['name'] ?? 'non defini',
                    ),
                  ],
                ),
              ),
            ),
            AppOutils.espace20,
            _LogoutButton(),
            AppOutils.espace50,
          ],
        ),
      ),
    );
  }

  Widget _information({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: InkWell(
            onTap: () {
              setState(() {});
            },
            child: ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(title, style: TextStyle(color: Colors.white)),
              subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ProfilePhoto() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              InkWell(
                onTap: _changeProfile,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade100,
                  child: _profileImage != null
                      ? ClipOval(
                          child: Image.file(
                            _profileImage!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue.shade400,
                        ),
                ),
              ),

              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          jsUser['name'] ?? 'Utilisateur',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          jsUser['email'] ?? '',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Future<void> _changeProfile() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir dans la galerie'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _deconexionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 10),
            Text('Déconnexion'),
          ],
        ),
        content: Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          TextButton(
            onPressed: () {
              context.go('/connexion');
              logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('👋 Déconnecté avec succès'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: Text(
              'Déconnecter',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _LogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _deconexionDialog,
        icon: Icon(Icons.logout, size: 20),
        label: Text(
          'Se déconnecter',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
