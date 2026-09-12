import 'package:flutter/material.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // ============================================================
  // 📊 DONNÉES BRUTES (statiques)
  // Remplacez ces valeurs par vos propres données
  // ============================================================
  final Map<String, dynamic> _userData = {
    'fullName': 'Jean Dupont',
    'email': 'jean.dupont@email.com',
    'phone': '+33 6 12 34 56 78',
    'address': '12 Rue de Paris, 75001 Paris',
    'birthDate': '15/03/1990',
    'bio': 'Développeur Flutter passionné par les technologies mobiles.',
    'photoURL': null,
    'points': 1250,
    'level': 'Expert',
    'totalHours': 156,
    'completedCourses': 12,
    'badges': ['Flutter', 'Dart', 'Firebase'],
  };

  // Mode édition
  bool _isEditing = false;

  // Contrôleurs pour l'édition
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les données
    _nameController.text = _userData['fullName'] ?? '';
    _phoneController.text = _userData['phone'] ?? '';
    _addressController.text = _userData['address'] ?? '';
    _bioController.text = _userData['bio'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // ============================================================
  // 💾 Sauvegarder les modifications
  // ============================================================
  void _saveProfile() {
    setState(() {
      _userData['fullName'] = _nameController.text;
      _userData['phone'] = _phoneController.text;
      _userData['address'] = _addressController.text;
      _userData['bio'] = _bioController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Profil mis à jour avec succès !'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // 🔄 Annuler les modifications
  // ============================================================
  void _cancelEditing() {
    setState(() {
      _nameController.text = _userData['fullName'] ?? '';
      _phoneController.text = _userData['phone'] ?? '';
      _addressController.text = _userData['address'] ?? '';
      _bioController.text = _userData['bio'] ?? '';
      _isEditing = false;
    });
  }

  // ============================================================
  // 🚪 Déconnexion
  // ============================================================
  void _showLogoutDialog() {
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
              Navigator.pop(context);
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

  // ============================================================
  // 🏗️ BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Mon Profil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Modifier',
            ),
          if (_isEditing) ...[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveProfile,
              tooltip: 'Sauvegarder',
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _cancelEditing,
              tooltip: 'Annuler',
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 📸 PHOTO DE PROFIL
            _buildProfilePhoto(),
            SizedBox(height: 20),

            // 📋 INFORMATIONS PERSONNELLES
            _buildInfoCard(),
            SizedBox(height: 20),

            // 📊 STATISTIQUES
            _buildStatsCard(),
            SizedBox(height: 20),

            // 🏆 BADGES
            _buildBadgesCard(),
            SizedBox(height: 20),

            // 🚪 DÉCONNEXION
            _buildLogoutButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 📸 PHOTO DE PROFIL
  // ============================================================
  Widget _buildProfilePhoto() {
    return Column(
      children: [
        Container(
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
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue.shade100,
            child: _userData['photoURL'] != null
                ? ClipOval(
                    child: Image.network(
                      _userData['photoURL'],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue.shade400,
                        );
                      },
                    ),
                  )
                : Icon(Icons.person, size: 60, color: Colors.blue.shade400),
          ),
        ),
        SizedBox(height: 10),
        Text(
          _userData['level'] ?? 'Débutant',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _userData['fullName'] ?? 'Utilisateur',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          _userData['email'] ?? '',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ============================================================
  // 📋 CARTE INFORMATIONS
  // ============================================================
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Informations personnelles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Nom
            _buildInfoRow(
              icon: Icons.person,
              label: 'Nom complet',
              value: _userData['fullName'] ?? '',
              controller: _nameController,
              enabled: _isEditing,
            ),

            Divider(),

            // Email (non modifiable)
            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: _userData['email'] ?? '',
              isEditable: false,
            ),

            Divider(),

            // Téléphone
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Téléphone',
              value: _userData['phone'] ?? '',
              controller: _phoneController,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),

            Divider(),

            // Adresse
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Adresse',
              value: _userData['address'] ?? '',
              controller: _addressController,
              enabled: _isEditing,
            ),

            Divider(),

            // Date de naissance (non modifiable)
            _buildInfoRow(
              icon: Icons.cake,
              label: 'Date de naissance',
              value: _userData['birthDate'] ?? '',
              isEditable: false,
            ),

            Divider(),

            // Bio
            _buildInfoRow(
              icon: Icons.description,
              label: 'Bio',
              value: _userData['bio'] ?? '',
              controller: _bioController,
              enabled: _isEditing,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 🏷️ LIGNE D'INFORMATION
  // ============================================================
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    TextEditingController? controller,
    bool enabled = false,
    bool isEditable = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 22),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              isEditable && controller != null
                  ? TextField(
                      controller: controller,
                      enabled: enabled,
                      keyboardType: keyboardType,
                      maxLines: maxLines,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'Entrez votre $label',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                    )
                  : Text(
                      value.isNotEmpty ? value : 'Non renseigné',
                      style: TextStyle(
                        fontSize: 15,
                        color: value.isNotEmpty
                            ? Colors.black
                            : Colors.grey.shade500,
                      ),
                    ),
            ],
          ),
        ),
        if (_isEditing && isEditable)
          Icon(Icons.edit, color: Colors.blue.shade300, size: 16),
      ],
    );
  }

  // ============================================================
  // 📊 CARTE STATISTIQUES
  // ============================================================
  Widget _buildStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Statistiques',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.star,
                  color: Colors.amber,
                  value: '${_userData['points'] ?? 0}',
                  label: 'Points',
                ),
                _buildStatItem(
                  icon: Icons.school,
                  color: Colors.blue,
                  value: '${_userData['completedCourses'] ?? 0}',
                  label: 'Cours terminés',
                ),
                _buildStatItem(
                  icon: Icons.access_time,
                  color: Colors.green,
                  value: '${_userData['totalHours'] ?? 0}h',
                  label: 'Heures',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 📊 STATISTIQUE INDIVIDUELLE
  // ============================================================
  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ============================================================
  // 🏆 CARTE BADGES
  // ============================================================
  Widget _buildBadgesCard() {
    List<String> badges = _userData['badges'] ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Badges obtenus',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: badges.isNotEmpty
                  ? badges.map((badge) => _buildBadge(badge)).toList()
                  : [
                      Text(
                        'Aucun badge pour le moment',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 🏷️ BADGE INDIVIDUEL
  // ============================================================
  Widget _buildBadge(String badgeName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text(
            badgeName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🚪 BOUTON DÉCONNEXION
  // ============================================================
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showLogoutDialog,
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
