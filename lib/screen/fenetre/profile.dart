import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:yafintech/core/outils/outils.dart';
import 'package:yafintech/services/auth_service.dart';

// ⚠️ Décommente / adapte si baseurl n'est pas dans auth_service.dart
// import 'package:yafintech/core/config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilePage> {
  Map<String, dynamic> jsUser = {};
  Map<String, dynamic> newUser = {};
  File? _profileImage;

  bool _saving = false;
  bool profilEdit = false;

  // ---------------------------------------------------------------------------
  // CHARGEMENT DU PROFIL
  // ---------------------------------------------------------------------------
  void userGet() async {
    final data = await getUser();
    if (!mounted) return;
    setState(() {
      jsUser = Map<String, dynamic>.from(data);
      if (!profilEdit) {
        newUser = jsUser;
      }
      //print(jsUser);
    });
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

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (!profilEdit)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  profilEdit = true;
                });
              },
            ),
          if (profilEdit)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                setState(() {
                  profilEdit = false;
                  userGet();
                });
              },
            ),
          if (profilEdit)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  profilEdit = false;
                  userGet();
                });
              },
            ),
          if (!profilEdit)
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () {
                context.push('/qrPage');
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                _ProfilePhoto(),
                AppOutils.espace20,
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(4),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      children: [
                        // ---------------- Champs modifiables ----------------
                        _information(
                          icon: Icons.person,
                          title: 'Nom complet',
                          subtitle:
                              newUser['member']?['first_name'] == null &&
                                  newUser['member']?['last_name'] == null
                              ? 'utilisateur'
                              : "${newUser['member']?['first_name'] ?? ''}  ${newUser['member']?['last_name'] ?? ''}",
                          editable: true,
                          onTap: () => _editerName(label: 'Nom complet'),
                        ),
                        _divider(),

                        _information(
                          icon: Icons.phone,
                          title: 'Téléphone',
                          subtitle: newUser['member']?['phone'] ?? 'non defini',
                          editable: true,
                          onTap: () => _editerTexte(
                            key: 'phone',
                            label: 'Téléphone',
                            valeurActuelle:
                                newUser['member']?['phone']?.toString() ?? '',
                            clavier: TextInputType.phone,
                          ),
                        ),
                        _divider(),

                        _information(
                          icon: Icons.location_on,
                          title: 'Adresse',
                          subtitle:
                              newUser['member']?['address'] ?? 'non defini',
                          editable: true,
                          onTap: () => _editerTexte(
                            key: 'address',
                            label: 'Adresse',
                            valeurActuelle:
                                newUser['member']?['address']?.toString() ?? '',
                          ),
                        ),
                        _divider(),

                        _information(
                          icon: Icons.location_on,
                          title: 'Ville',
                          subtitle: newUser['member']?['city'] ?? 'non defini',
                          editable: true,
                          onTap: () => _editerTexte(
                            key: 'city',
                            label: 'Ville',
                            valeurActuelle:
                                newUser['member']?['city']?.toString() ?? '',
                          ),
                        ),
                        _divider(),

                        _information(
                          icon: Icons.location_on,
                          title: 'Pays',
                          subtitle:
                              newUser['member']?['country'] ?? 'non defini',
                          editable: true,
                          onTap: () => _editerTexte(
                            key: 'country',
                            label: 'Pays',
                            valeurActuelle:
                                newUser['member']?['country']?.toString() ?? '',
                          ),
                        ),
                        _divider(),

                        _information(
                          icon: Icons.calendar_today,
                          title: 'Date de naissance',
                          subtitle:
                              newUser['member']?['birth_date'] ?? 'non defini',
                          editable: true,
                          onTap: _editerDate,
                        ),
                        _divider(),

                        _information(
                          icon: Icons.person_outline,
                          title: 'Genre',
                          subtitle:
                              newUser['member']?['gender'] ?? 'non defini',
                          editable: true,
                          onTap: _editerGenre,
                        ),
                        _divider(),

                        // ---------------- Champs en lecture seule ----------------
                        _information(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: newUser['email'] ?? 'non defini',
                        ),
                        _divider(),

                        _information(
                          icon: Icons.work,
                          title: 'Statut',
                          subtitle:
                              newUser['status']?.toString() ?? 'non defini',
                        ),
                        _divider(),

                        _information(
                          icon: Icons.church,
                          title: 'Nom de l\'eglise',
                          subtitle: newUser['church_name'] ?? 'non defini',
                        ),
                        _divider(),

                        _information(
                          icon: Icons.work,
                          title: 'fonction',
                          subtitle:
                              newUser['fonction']?['name'] ?? 'non defini',
                        ),
                        _divider(),

                        _information(
                          icon: Icons.info_outline,
                          title: 'Rôle',
                          subtitle: newUser['role']?['name'] ?? 'non defini',
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

          // --------- Overlay de sauvegarde ---------
          if (_saving)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade400, thickness: 1);

  // ---------------------------------------------------------------------------
  // LIGNE D'INFORMATION
  // ---------------------------------------------------------------------------
  Widget _information({
    required IconData icon,
    required String title,
    required String subtitle,
    bool editable = false,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: editable && profilEdit ? onTap : null,
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          /* trailing: editable
              ? const Icon(Icons.edit, size: 18, color: Colors.blue)
              : null, */
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PHOTO DE PROFIL
  // ---------------------------------------------------------------------------
  Widget _ProfilePhoto() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 5),
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
        const SizedBox(height: 10),
        Text(
          "${newUser['member']?['first_name'] ?? ''}  ${newUser['member']?['last_name'] ?? ''}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          newUser['email'] ?? '',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // CHOIX DE LA PHOTO
  // ---------------------------------------------------------------------------
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
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir dans la galerie'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
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
      // TODO: uploader l'image au backend ici si besoin
    }
  }

  // ---------------------------------------------------------------------------
  // ÉDITION : TEXTE
  // ---------------------------------------------------------------------------
  Future<void> _editerTexte({
    required String key,
    required String label,
    required String valeurActuelle,
    TextInputType clavier = TextInputType.text,
  }) async {
    final controller = TextEditingController(text: valeurActuelle);

    final nouvelleValeur = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modifier $label',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: clavier,
              decoration: InputDecoration(
                hintText: label,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                    child: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (nouvelleValeur == null || nouvelleValeur.isEmpty) return;
    if (nouvelleValeur == valeurActuelle) return;
    setState(() {
      newUser['member'][key] = nouvelleValeur;
    });
  }

  Future<void> _editerName({
    required String label,
    TextInputType clavier = TextInputType.text,
  }) async {
    final controller = TextEditingController(
      text: newUser['member']?['first_name'],
    );
    final controllerlast = TextEditingController(
      text: newUser['member']?['last_name'],
    );

    final nouvelleValeur = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modifier $label',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: clavier,
              decoration: InputDecoration(
                hintText: 'Nom',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controllerlast,
              autofocus: true,
              keyboardType: clavier,
              decoration: InputDecoration(
                hintText: 'Prenom',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(ctx, controller.text.trim());
                      });
                    },
                    child: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (controller.text == null || controller.text.isEmpty) return;

    if (controllerlast.text == null || controllerlast.text.isEmpty) return;
    setState(() {
      newUser['member']?['first_name'] = controller.text;
      newUser['member']?['last_name'] = controllerlast.text;
      print('🏈 ');
    });
  }

  // ---------------------------------------------------------------------------
  // ÉDITION : DATE DE NAISSANCE
  // ---------------------------------------------------------------------------
  Future<void> _editerDate() async {
    final initial = jsUser['member']?['birth_date'] != null
        ? DateTime.tryParse(jsUser['member']['birth_date'].toString())
        : null;

    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Choisir la date de naissance',
    );

    if (date == null) return;

    final iso = date.toIso8601String().split('T').first; // YYYY-MM-DD
    setState(() {
      jsUser['member']['birth_date'] = iso;
    });
  }

  // ---------------------------------------------------------------------------
  // ÉDITION : GENRE
  // ---------------------------------------------------------------------------
  Future<void> _editerGenre() async {
    final choix = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Choisir le genre',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.male),
              title: const Text('Homme'),
              onTap: () => Navigator.pop(ctx, 'homme'),
            ),
            ListTile(
              leading: const Icon(Icons.female),
              title: const Text('Femme'),
              onTap: () => Navigator.pop(ctx, 'femme'),
            ),
          ],
        ),
      ),
    );

    if (choix == null) return;
    if (choix == newUser['member']?['gender']) return;
    setState(() {
      newUser['member']?['gender'] = choix;
    });
  }

  void _afficherErreur(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ $msg'), backgroundColor: Colors.red),
    );
  }

  // ---------------------------------------------------------------------------
  // DÉCONNEXION
  // ---------------------------------------------------------------------------
  void _deconexionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 10),
            Text('Déconnexion'),
          ],
        ),
        content: const Text(
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
                const SnackBar(
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
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _deconexionDialog,
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          'Se déconnecter',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
