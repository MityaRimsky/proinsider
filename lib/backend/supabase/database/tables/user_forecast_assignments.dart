import '../database.dart';

class UserForecastAssignmentsTable
    extends SupabaseTable<UserForecastAssignmentsRow> {
  @override
  String get tableName => 'user_forecast_assignments';

  @override
  UserForecastAssignmentsRow createRow(Map<String, dynamic> data) =>
      UserForecastAssignmentsRow(data);
}

class UserForecastAssignmentsRow extends SupabaseDataRow {
  UserForecastAssignmentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserForecastAssignmentsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get forecastCardId => getField<int>('forecast_card_id')!;
  set forecastCardId(int value) => setField<int>('forecast_card_id', value);

  int? get creditId => getField<int>('credit_id');
  set creditId(int? value) => setField<int>('credit_id', value);

  int? get bonusId => getField<int>('bonus_id');
  set bonusId(int? value) => setField<int>('bonus_id', value);

  bool get bonusGranted => getField<bool>('bonus_granted')!;
  set bonusGranted(bool value) => setField<bool>('bonus_granted', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
