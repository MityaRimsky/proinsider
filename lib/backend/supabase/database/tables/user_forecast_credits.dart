import '../database.dart';

class UserForecastCreditsTable extends SupabaseTable<UserForecastCreditsRow> {
  @override
  String get tableName => 'user_forecast_credits';

  @override
  UserForecastCreditsRow createRow(Map<String, dynamic> data) =>
      UserForecastCreditsRow(data);
}

class UserForecastCreditsRow extends SupabaseDataRow {
  UserForecastCreditsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserForecastCreditsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get planId => getField<int>('plan_id')!;
  set planId(int value) => setField<int>('plan_id', value);

  int get optionId => getField<int>('option_id')!;
  set optionId(int value) => setField<int>('option_id', value);

  int get paymentId => getField<int>('payment_id')!;
  set paymentId(int value) => setField<int>('payment_id', value);

  int get quantityGranted => getField<int>('quantity_granted')!;
  set quantityGranted(int value) => setField<int>('quantity_granted', value);

  int get quantityUsed => getField<int>('quantity_used')!;
  set quantityUsed(int value) => setField<int>('quantity_used', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  bool get bonusUntilWin => getField<bool>('bonus_until_win')!;
  set bonusUntilWin(bool value) => setField<bool>('bonus_until_win', value);
}
