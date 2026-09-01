import '../database.dart';

class SubscriptionPlanDetailsViewTable
    extends SupabaseTable<SubscriptionPlanDetailsViewRow> {
  @override
  String get tableName => 'subscription_plan_details_view';

  @override
  SubscriptionPlanDetailsViewRow createRow(Map<String, dynamic> data) =>
      SubscriptionPlanDetailsViewRow(data);
}

class SubscriptionPlanDetailsViewRow extends SupabaseDataRow {
  SubscriptionPlanDetailsViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionPlanDetailsViewTable();

  int? get planId => getField<int>('plan_id');
  set planId(int? value) => setField<int>('plan_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get subtitle => getField<String>('subtitle');
  set subtitle(String? value) => setField<String>('subtitle', value);

  String? get feature1 => getField<String>('feature_1');
  set feature1(String? value) => setField<String>('feature_1', value);

  String? get feature2 => getField<String>('feature_2');
  set feature2(String? value) => setField<String>('feature_2', value);

  String? get feature3 => getField<String>('feature_3');
  set feature3(String? value) => setField<String>('feature_3', value);

  String? get feature4 => getField<String>('feature_4');
  set feature4(String? value) => setField<String>('feature_4', value);

  String? get feature5 => getField<String>('feature_5');
  set feature5(String? value) => setField<String>('feature_5', value);

  int? get option1Id => getField<int>('option1_id');
  set option1Id(int? value) => setField<int>('option1_id', value);

  String? get option1Name => getField<String>('option1_name');
  set option1Name(String? value) => setField<String>('option1_name', value);

  double? get option1Price => getField<double>('option1_price');
  set option1Price(double? value) => setField<double>('option1_price', value);

  int? get option2Id => getField<int>('option2_id');
  set option2Id(int? value) => setField<int>('option2_id', value);

  String? get option2Name => getField<String>('option2_name');
  set option2Name(String? value) => setField<String>('option2_name', value);

  double? get option2Price => getField<double>('option2_price');
  set option2Price(double? value) => setField<double>('option2_price', value);

  int? get remainingForecasts => getField<int>('remaining_forecasts');
  set remainingForecasts(int? value) =>
      setField<int>('remaining_forecasts', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  bool? get hasAccess => getField<bool>('has_access');
  set hasAccess(bool? value) => setField<bool>('has_access', value);

  String? get liveStatus => getField<String>('live_status');
  set liveStatus(String? value) => setField<String>('live_status', value);

  String? get featureBonus => getField<String>('feature_bonus');
  set featureBonus(String? value) => setField<String>('feature_bonus', value);

  int? get currentOptionId => getField<int>('current_option_id');
  set currentOptionId(int? value) => setField<int>('current_option_id', value);

  int? get currentOption => getField<int>('current_option');
  set currentOption(int? value) => setField<int>('current_option', value);

  String? get currentOptionName => getField<String>('current_option_name');
  set currentOptionName(String? value) =>
      setField<String>('current_option_name', value);

  double? get currentOptionPrice => getField<double>('current_option_price');
  set currentOptionPrice(double? value) =>
      setField<double>('current_option_price', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);
}
