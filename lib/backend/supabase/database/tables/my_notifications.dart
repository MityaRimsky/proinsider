import '../database.dart';

class MyNotificationsTable extends SupabaseTable<MyNotificationsRow> {
  @override
  String get tableName => 'my_notifications';

  @override
  MyNotificationsRow createRow(Map<String, dynamic> data) =>
      MyNotificationsRow(data);
}

class MyNotificationsRow extends SupabaseDataRow {
  MyNotificationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MyNotificationsTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get planType => getField<String>('plan_type');
  set planType(String? value) => setField<String>('plan_type', value);

  int? get forecastCardId => getField<int>('forecast_card_id');
  set forecastCardId(int? value) => setField<int>('forecast_card_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get matchTime => getField<DateTime>('match_time');
  set matchTime(DateTime? value) => setField<DateTime>('match_time', value);

  double? get coefficient => getField<double>('coefficient');
  set coefficient(double? value) => setField<double>('coefficient', value);
}
