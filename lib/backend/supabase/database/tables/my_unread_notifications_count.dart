import '../database.dart';

class MyUnreadNotificationsCountTable
    extends SupabaseTable<MyUnreadNotificationsCountRow> {
  @override
  String get tableName => 'my_unread_notifications_count';

  @override
  MyUnreadNotificationsCountRow createRow(Map<String, dynamic> data) =>
      MyUnreadNotificationsCountRow(data);
}

class MyUnreadNotificationsCountRow extends SupabaseDataRow {
  MyUnreadNotificationsCountRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MyUnreadNotificationsCountTable();

  int? get unreadCount => getField<int>('unread_count');
  set unreadCount(int? value) => setField<int>('unread_count', value);
}
