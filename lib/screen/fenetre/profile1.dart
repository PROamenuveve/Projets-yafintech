import 'package:flutter/material.dart';

class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text(
          'Mon profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PHOTO DE PROFIL
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 55, color: Colors.white),
            ),

            const SizedBox(height: 15),

            // NOM
            const Text(
              'Amenuveve NOSSI',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              '+228 90 00 00 00',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 20),

            // MODIFIER LE PROFIL
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Modifier le profil
                },
                icon: const Icon(Icons.edit),
                label: const Text('Modifier le profil'),
              ),
            ),

            const SizedBox(height: 25),

            // INFORMATIONS
            _sectionTitle('Informations'),

            _profileItem(
              icon: Icons.person_outline,
              title: 'Informations personnelles',
              onTap: () {},
            ),

            _profileItem(
              icon: Icons.phone_outlined,
              title: 'Numéro de téléphone',
              subtitle: '+228 90 00 00 00',
              onTap: () {},
            ),

            _profileItem(
              icon: Icons.email_outlined,
              title: 'Adresse e-mail',
              subtitle: 'example@email.com',
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // SECURITE
            _sectionTitle('Sécurité'),

            _profileItem(
              icon: Icons.lock_outline,
              title: 'Modifier le mot de passe',
              onTap: () {},
            ),

            _profileItem(
              icon: Icons.fingerprint,
              title: 'Authentification biométrique',
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // PREFERENCES
            _sectionTitle('Préférences'),

            _profileItem(
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () {},
            ),

            _profileItem(
              icon: Icons.language,
              title: 'Langue',
              subtitle: 'Français',
              onTap: () {},
            ),

            const SizedBox(height: 25),

            // DECONNEXION
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton.icon(
                onPressed: () {
                  // Déconnexion
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
