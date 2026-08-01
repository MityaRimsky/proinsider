import '../database.dart';

class UserForecastBalancesTable extends SupabaseTable<UserForecastBalancesRow> {
  @override
  String get tableName => 'user_forecast_balances';

  @override
  UserForecastBalancesRow createRow(Map<String, dynamic> data) =>
      UserForecastBalancesRow(data);
}

class UserForecastBalancesRow extends SupabaseDataRow {
  UserForecastBalancesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserForecastBalancesTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get planId => getField<int>('plan_id');
  set planId(int? value) => setField<int>('plan_id', value);

  int? get paidRemaining => getField<int>('paid_remaining');
  set paidRemaining(int? value) => setField<int>('paid_remaining', value);

  int? get bonusRemaining => getField<int>('bonus_remaining');
  set bonusRemaining(int? value) => setField<int>('bonus_remaining', value);

  int? get totalRemaining => getField<int>('total_remaining');
  set totalRemaining(int? value) => setField<int>('total_remaining', value);
}
