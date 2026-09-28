import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  // ✅ Liste de plusieurs événements
  final List<Map<String, dynamic>> _events = [
    {
      'id': 3,
      'title': 'Grande Nuit de Traversée & Miracles',
      'description':
          'Temps de louange, d\'intercession et de prière prophétique.',
      'type': 'veillee',
      'event_date': '2026-12-31',
      'start_time': '21:00',
      'end_time': '05:00',
      'location': 'Temple Principal - Siège',
      'is_featured': true,
      'status': 'published',
    },
    {
      'id': 4,
      'title': 'Culte de Résurrection',
      'description': 'Célébration de la Pâque avec toute la communauté.',
      'type': 'culte',
      'event_date': '2026-04-05',
      'start_time': '09:00',
      'end_time': '12:00',
      'location': 'Temple Principal - Siège',
      'is_featured': false,
      'status': 'published',
    },
    {
      'id': 5,
      'title': 'Conférence des Leaders',
      'description': 'Formation et équipement pour les responsables.',
      'type': 'conference',
      'event_date': '2026-06-15',
      'start_time': '14:00',
      'end_time': '18:00',
      'location': 'Salle Annexe - 1er étage',
      'is_featured': false,
      'status': 'published',
    },
    {
      'id': 6,
      'title': 'Concert de Louange',
      'description': 'Soirée musicale avec la chorale et les musiciens.',
      'type': 'concert',
      'event_date': '2026-08-20',
      'start_time': '19:00',
      'end_time': '22:00',
      'location': 'Parvis Extérieur',
      'is_featured': true,
      'status': 'published',
    },
    {
      'id': 7,
      'title': 'Séminaire sur le Mariage',
      'description': 'Enseignements sur la vie de couple selon la Bible.',
      'type': 'seminaire',
      'event_date': '2026-10-10',
      'start_time': '10:00',
      'end_time': '16:00',
      'location': 'Salle de Conférence',
      'is_featured': false,
      'status': 'published',
    },
  ];

  // ✅ Filtre actif (tous / par type)
  String _filterType = 'all';

  // ------------------------------------------------------------
  // HELPERS
  // ------------------------------------------------------------

  DateTime _parseDate(String dateStr) => DateTime.parse(dateStr);

  String _jourMois(DateTime date) {
    const mois = [
      'JANV',
      'FÉVR',
      'MARS',
      'AVR',
      'MAI',
      'JUIN',
      'JUIL',
      'AOÛT',
      'SEPT',
      'OCT',
      'NOV',
      'DÉC',
    ];
    return mois[date.month - 1];
  }

  String _nomJour(DateTime date) {
    const jours = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    return jours[date.weekday - 1];
  }

  String _getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'veillee':
        return '🌙 Veillée';
      case 'culte':
        return '⛪ Culte';
      case 'conference':
        return '🎤 Conférence';
      case 'concert':
        return '🎵 Concert';
      case 'seminaire':
        return '📚 Séminaire';
      default:
        return '📅 Événement';
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'veillee':
        return const Color(0xFF6C63FF);
      case 'culte':
        return const Color(0xFF4CAF50);
      case 'conference':
        return const Color(0xFF2196F3);
      case 'concert':
        return const Color(0xFFE91E63);
      case 'seminaire':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  // ✅ Filtrer les événements
  List<Map<String, dynamic>> get _filteredEvents {
    if (_filterType == 'all') return _events;
    return _events.where((e) => e['type'] == _filterType).toList();
  }

  // ✅ Trier par date (à venir d'abord)
  List<Map<String, dynamic>> get _sortedEvents {
    final list = List<Map<String, dynamic>>.from(_filteredEvents);
    list.sort((a, b) {
      final dateA = DateTime.parse(a['event_date']);
      final dateB = DateTime.parse(b['event_date']);
      return dateA.compareTo(dateB);
    });
    return list;
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final events = _sortedEvents;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Événements',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('🔍 Recherche');
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Barre de filtres
          _buildFilterBar(),

          // ✅ Liste des événements
          Expanded(
            child: events.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return _buildEventCard(events[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BARRE DE FILTRES
  // ------------------------------------------------------------

  Widget _buildFilterBar() {
    final filters = [
      {'key': 'all', 'label': 'Tous', 'icon': Icons.apps},
      {'key': 'veillee', 'label': 'Veillées', 'icon': Icons.nightlight_round},
      {'key': 'culte', 'label': 'Cultes', 'icon': Icons.church},
      {'key': 'conference', 'label': 'Conférences', 'icon': Icons.mic},
      {'key': 'concert', 'label': 'Concerts', 'icon': Icons.music_note},
    ];

    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = _filterType == filter['key'];
          final color = filter['key'] == 'all'
              ? const Color(0xFF6C63FF)
              : _getTypeColor(filter['key'] as String);

          return GestureDetector(
            onTap: () {
              setState(() {
                _filterType = filter['key'] as String;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? color : color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16,
                    color: isActive ? Colors.white : color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // ÉTAT VIDE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Aucun événement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Aucun événement ne correspond à ce filtre',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CARTE D'ÉVÉNEMENT
  // ------------------------------------------------------------

  Widget _buildEventCard(Map<String, dynamic> event) {
    final date = _parseDate(event['event_date']);
    final isFeatured = event['is_featured'] == true;
    final typeColor = _getTypeColor(event['type']);
    final isPast = date.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: () => _onEventTap(event),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isFeatured ? Border.all(color: typeColor, width: 2) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // EN-TÊTE
                // ==================================================
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isPast
                          ? [Colors.grey[400]!, Colors.grey[300]!]
                          : [typeColor, typeColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Bloc date
                      Container(
                        width: 65,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _jourMois(date),
                              style: TextStyle(
                                color: isPast ? Colors.grey : typeColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              '${date.day}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Titre + badge
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getTypeLabel(event['type']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Badge "À LA UNE"
                      if (isFeatured)
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                    ],
                  ),
                ),

                // ==================================================
                // CONTENU
                // ==================================================
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        event['description'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Horaire
                      _buildInfoRow(
                        icon: Icons.access_time,
                        iconColor: typeColor,
                        value:
                            '${event['start_time']} → '
                            '${event['end_time']}',
                      ),

                      const SizedBox(height: 8),

                      // Lieu
                      _buildInfoRow(
                        icon: Icons.location_on,
                        iconColor: typeColor,
                        value: event['location'],
                      ),

                      const SizedBox(height: 12),

                      // Pied : date complète + boutons
                      Row(
                        children: [
                          // Date courte
                          Expanded(
                            child: Text(
                              '${_nomJour(date)} ${date.day} '
                              '${_jourMois(date).toLowerCase()} '
                              '${date.year}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Statut "Passé"
                          if (isPast)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Passé',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            // Bouton "Participer"
                            ElevatedButton.icon(
                              onPressed: () => _onParticipate(event),
                              icon: const Icon(Icons.check, size: 14),
                              label: const Text(
                                'Participer',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: typeColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // LIGNE D'INFO
  // ------------------------------------------------------------

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ACTIONS
  // ------------------------------------------------------------

  void _onEventTap(Map<String, dynamic> event) {
    debugPrint('📅 Événement cliqué : ${event['title']}');
    // Navigator.push(...);
  }

  void _onParticipate(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Inscription'),
          ],
        ),
        content: Text('Voulez-vous participer à "${event['title']}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Inscrit à "${event['title']}"'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
