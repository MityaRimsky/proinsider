import '../database.dart';

class SubscriptionOptionsTable extends SupabaseTable<SubscriptionOptionsRow> {
  @override
  String get tableName => 'subscription_options';

  @override
  SubscriptionOptionsRow createRow(Map<String, dynamic> data) =>
      SubscriptionOptionsRow(data);
}

class SubscriptionOptionsRow extends SupabaseDataRow {
  SubscriptionOptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionOptionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int get planId => getField<int>('plan_id')!;
  set planId(int value) => setField<int>('plan_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  double get price => getField<double>('price')!;
  set price(double value) => setField<double>('price', value);

  int get quantity => getField<int>('quantity')!;
  set quantity(int value) => setField<int>('quantity', value);

  String get unitType => getField<String>('unit_type')!;
  set unitType(String value) => setField<String>('unit_type', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  bool get displayOnCard => getField<bool>('display_on_card')!;
  set displayOnCard(bool value) => setField<bool>('display_on_card', value);

  int get optionOrder => getField<int>('option_order')!;
  set optionOrder(int value) => setField<int>('option_order', value);
}
