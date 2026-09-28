import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'base_service.g.dart';

// ============================================================================
// TABLE : Contacts (les utilisateurs avec qui on discute)
// ============================================================================
class Contacts extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get initiales => text().nullable()();
  IntColumn get roleId => integer().nullable()();
  TextColumn get roleName => text().nullable()();
  IntColumn get churchId => integer().nullable()();
  TextColumn get churchName => text().nullable()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();

  /// Durée d'éphémérité de la conversation (ex: 24h), null = permanent
  IntColumn get ephemeralDuration => integer().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================================
// TABLE : Messages (tous les messages échangés)
// ============================================================================
class Messages extends Table {
  IntColumn get id => integer()();
  IntColumn get contactId =>
      integer().references(Contacts, #id, onDelete: KeyAction.cascade)();
  IntColumn get senderId => integer().nullable()();
  IntColumn get recipientId => integer().nullable()();
  TextColumn get contenu => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  BoolColumn get isMine => boolean().withDefault(const Constant(false))();
  BoolColumn get lu => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================================
// DATABASE
// ============================================================================
@DriftDatabase(tables: [Contacts, Messages])
class ConversationsDatabase extends _$ConversationsDatabase {
  ConversationsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // -------------------------------------------------------------------------
  // UPSERT : Contact
  // -------------------------------------------------------------------------
  Future<void> upsertContact({
    required int id,
    required String name,
    String? email,
    String? phone,
    String? initiales,
    int? roleId,
    String? roleName,
    int? churchId,
    String? churchName,
    int unreadCount = 0,
    int? ephemeralDuration,
  }) async {
    await into(contacts).insertOnConflictUpdate(
      ContactsCompanion.insert(
        id: Value(id),
        name: name,
        email: Value(email),
        phone: Value(phone),
        initiales: Value(initiales),
        roleId: Value(roleId),
        roleName: Value(roleName),
        churchId: Value(churchId),
        churchName: Value(churchName),
        unreadCount: Value(unreadCount),
        ephemeralDuration: Value(ephemeralDuration),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // UPSERT : Message
  // -------------------------------------------------------------------------
  Future<void> upsertMessage({
    required int id,
    required int contactId,
    required String contenu,
    required DateTime createdAt,
    int? senderId,
    int? recipientId,
    DateTime? expiresAt,
    bool isMine = false,
    bool lu = false,
  }) async {
    await into(messages).insertOnConflictUpdate(
      MessagesCompanion.insert(
        id: Value(id),
        contactId: contactId,
        contenu: contenu,
        createdAt: createdAt,
        senderId: Value(senderId),
        recipientId: Value(recipientId),
        expiresAt: Value(expiresAt),
        isMine: Value(isMine),
        lu: Value(lu),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // IMPORT : Liste des conversations (format #1)
  // -------------------------------------------------------------------------
  Future<void> importConversationsList(List<dynamic> jsonList) async {
    await transaction(() async {
      for (final item in jsonList) {
        final map = item as Map<String, dynamic>;

        await upsertContact(
          id: map['id'] as int,
          name: map['name'] as String? ?? '',
          email: map['email'] as String?,
          phone: map['phone'] as String?,
          initiales: map['initiales'] as String?,
          roleId: map['role_id'] as int?,
          roleName: map['role_name'] as String?,
          churchId: map['church_id'] as int?,
          churchName: map['church_name'] as String?,
          unreadCount: map['unread_count'] as int? ?? 0,
        );

        final last = map['last_message'];
        if (last is Map<String, dynamic>) {
          final createdAt = DateTime.tryParse(
            last['created_at']?.toString() ?? '',
          );
          if (createdAt != null) {
            await upsertMessage(
              id: last['id'] as int,
              contactId: map['id'] as int,
              contenu: last['contenu'] as String? ?? '',
              createdAt: createdAt,
              isMine: last['is_mine'] as bool? ?? false,
            );
          }
        }
      }
    });
  }

  // -------------------------------------------------------------------------
  // IMPORT : Détail d'une conversation (format #2)
  // -------------------------------------------------------------------------
  Future<void> importConversationDetail(Map<String, dynamic> json) async {
    await transaction(() async {
      // 1. Le contact
      final contact = json['contact'] as Map<String, dynamic>?;
      if (contact == null) return;

      final contactId = contact['id'] as int;
      final ephemeralDuration = json['ephemeral_duration'] as int?;

      await upsertContact(
        id: contactId,
        name: contact['name'] as String? ?? '',
        email: contact['email'] as String?,
        phone: contact['phone'] as String?,
        initiales: contact['initiales'] as String?,
        roleName: contact['role_name'] as String?,
        churchName: contact['church_name'] as String?,
        ephemeralDuration: ephemeralDuration,
      );

      // 2. Les messages
      final messagesList = json['messages'] as List<dynamic>? ?? [];
      for (final m in messagesList) {
        final msg = m as Map<String, dynamic>;
        final createdAt = DateTime.tryParse(
          msg['created_at']?.toString() ?? '',
        );
        if (createdAt == null) continue;

        final expiresAt = msg['expires_at'] == null
            ? null
            : DateTime.tryParse(msg['expires_at'].toString());

        await upsertMessage(
          id: msg['id'] as int,
          contactId: contactId,
          contenu: msg['contenu'] as String? ?? '',
          createdAt: createdAt,
          senderId: msg['sender_id'] as int?,
          recipientId: msg['recipient_id'] as int?,
          expiresAt: expiresAt,
          isMine: msg['is_mine'] as bool? ?? false,
          lu: msg['lu'] as bool? ?? false,
        );
      }
    });
  }

  // -------------------------------------------------------------------------
  // LECTURE : Liste des conversations avec leur dernier message
  // -------------------------------------------------------------------------
  Future<List<ConversationWithLastMessage>> getConversations() async {
    final query = select(contacts).join([
      leftOuterJoin(messages, messages.contactId.equalsExp(contacts.id)),
    ])..orderBy([OrderingTerm.desc(messages.createdAt)]);

    final rows = await query.get();
    final result = <ConversationWithLastMessage>[];
    final seen = <int>{};

    for (final row in rows) {
      final contact = row.readTable(contacts);
      if (seen.contains(contact.id)) continue;
      seen.add(contact.id);
      result.add(
        ConversationWithLastMessage(contact, row.readTableOrNull(messages)),
      );
    }
    return result;
  }

  // -------------------------------------------------------------------------
  // LECTURE : Stream réactif de la liste des conversations
  // -------------------------------------------------------------------------
  Stream<List<ConversationWithLastMessage>> watchConversations() {
    final query = select(contacts).join([
      leftOuterJoin(messages, messages.contactId.equalsExp(contacts.id)),
    ])..orderBy([OrderingTerm.desc(messages.createdAt)]);

    return query.watch().map((rows) {
      final seen = <int>{};
      final list = <ConversationWithLastMessage>[];
      for (final row in rows) {
        final contact = row.readTable(contacts);
        if (seen.contains(contact.id)) continue;
        seen.add(contact.id);
        list.add(
          ConversationWithLastMessage(contact, row.readTableOrNull(messages)),
        );
      }
      return list;
    });
  }

  // -------------------------------------------------------------------------
  // LECTURE : Tous les messages d'un contact (triés)
  // -------------------------------------------------------------------------
  Future<List<Message>> getMessagesForContact(int contactId) {
    return (select(messages)
          ..where((m) => m.contactId.equals(contactId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
  }

  // -------------------------------------------------------------------------
  // LECTURE : Stream réactif des messages d'un contact
  // -------------------------------------------------------------------------
  Stream<List<Message>> watchMessagesForContact(int contactId) {
    return (select(messages)
          ..where((m) => m.contactId.equals(contactId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }

  // -------------------------------------------------------------------------
  // SUPPRESSION : vider un contact et ses messages
  // -------------------------------------------------------------------------
  Future<void> deleteContact(int contactId) async {
    await (delete(messages)..where((m) => m.contactId.equals(contactId))).go();
    await (delete(contacts)..where((c) => c.id.equals(contactId))).go();
  }
}

// ============================================================================
// Wrapper de retour pour la liste des conversations
// ============================================================================
class ConversationWithLastMessage {
  final Contact contact;
  final Message? lastMessage;

  ConversationWithLastMessage(this.contact, this.lastMessage);
}

// ============================================================================
// CONNEXION
// ============================================================================
QueryExecutor _openConnection() {
  return driftDatabase(name: 'conversations_db');
}
