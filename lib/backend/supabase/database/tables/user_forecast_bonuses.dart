import '../database.dart';

class UserForecastBonusesTable extends SupabaseTable<UserForecastBonusesRow> {
  @override
  String get tableName => 'user_forecast_bonuses';

  @override
  UserForecastBonusesRow createRow(Map<String, dynamic> data) =>
      UserForecastBonusesRow(data);
}

class UserForecastBonusesRow extends SupabaseDataRow {
  UserForecastBonusesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserForecastBonusesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get sourceCreditId => getField<int>('source_credit_id')!;
  set sourceCreditId(int value) => setField<int>('source_credit_id', value);

  int get sourceAssignmentId => getField<int>('source_assignment_id')!;
  set sourceAssignmentId(int value) =>
      setField<int>('source_assignment_id', value);

  String get reason => getField<String>('reason')!;
  set reason(String value) => setField<String>('reason', value);

  int get quantityGranted => getField<int>('quantity_granted')!;
  set quantityGranted(int value) => setField<int>('quantity_granted', value);

  int get quantityUsed => getField<int>('quantity_used')!;
  set quantityUsed(int value) => setField<int>('quantity_used', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
