import '../database.dart';

class SubscriptionCardsViewTable
    extends SupabaseTable<SubscriptionCardsViewRow> {
  @override
  String get tableName => 'subscription_cards_view';

  @override
  SubscriptionCardsViewRow createRow(Map<String, dynamic> data) =>
      SubscriptionCardsViewRow(data);
}

class SubscriptionCardsViewRow extends SupabaseDataRow {
  SubscriptionCardsViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionCardsViewTable();

  int? get planId => getField<int>('plan_id');
  set planId(int? value) => setField<int>('plan_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get subtitle => getField<String>('subtitle');
  set subtitle(String? value) => setField<String>('subtitle', value);

  String? get displayOptionName => getField<String>('display_option_name');
  set displayOptionName(String? value) =>
      setField<String>('display_option_name', value);

  double? get displayOptionPrice => getField<double>('display_option_price');
  set displayOptionPrice(double? value) =>
      setField<double>('display_option_price', value);
}
