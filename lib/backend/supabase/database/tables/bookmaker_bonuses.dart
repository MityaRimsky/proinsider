import '../database.dart';

class BookmakerBonusesTable extends SupabaseTable<BookmakerBonusesRow> {
  @override
  String get tableName => 'bookmaker_bonuses';

  @override
  BookmakerBonusesRow createRow(Map<String, dynamic> data) =>
      BookmakerBonusesRow(data);
}

class BookmakerBonusesRow extends SupabaseDataRow {
  BookmakerBonusesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BookmakerBonusesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get logoUrl => getField<String>('logo_url')!;
  set logoUrl(String value) => setField<String>('logo_url', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get url => getField<String>('url')!;
  set url(String value) => setField<String>('url', value);

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
