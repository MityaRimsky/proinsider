import '../database.dart';

class UserNotificationPreferencesTable
    extends SupabaseTable<UserNotificationPreferencesRow> {
  @override
  String get tableName => 'user_notification_preferences';

  @override
  UserNotificationPreferencesRow createRow(Map<String, dynamic> data) =>
      UserNotificationPreferencesRow(data);
}

class UserNotificationPreferencesRow extends SupabaseDataRow {
  UserNotificationPreferencesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserNotificationPreferencesTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  bool get pushEnabled => getField<bool>('push_enabled')!;
  set pushEnabled(bool value) => setField<bool>('push_enabled', value);

  bool get emailEnabled => getField<bool>('email_enabled')!;
  set emailEnabled(bool value) => setField<bool>('email_enabled', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
