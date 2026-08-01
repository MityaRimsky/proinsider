import '../database.dart';

class UserNotificationStateTable
    extends SupabaseTable<UserNotificationStateRow> {
  @override
  String get tableName => 'user_notification_state';

  @override
  UserNotificationStateRow createRow(Map<String, dynamic> data) =>
      UserNotificationStateRow(data);
}

class UserNotificationStateRow extends SupabaseDataRow {
  UserNotificationStateRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserNotificationStateTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime get lastSeenAt => getField<DateTime>('last_seen_at')!;
  set lastSeenAt(DateTime value) => setField<DateTime>('last_seen_at', value);
}
