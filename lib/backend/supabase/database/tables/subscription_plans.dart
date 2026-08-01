import '../database.dart';

class SubscriptionPlansTable extends SupabaseTable<SubscriptionPlansRow> {
  @override
  String get tableName => 'subscription_plans';

  @override
  SubscriptionPlansRow createRow(Map<String, dynamic> data) =>
      SubscriptionPlansRow(data);
}

class SubscriptionPlansRow extends SupabaseDataRow {
  SubscriptionPlansRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionPlansTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

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

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get featureBonus => getField<String>('feature_bonus');
  set featureBonus(String? value) => setField<String>('feature_bonus', value);
}
