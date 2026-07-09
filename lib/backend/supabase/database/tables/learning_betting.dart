import '../database.dart';

class LearningBettingTable extends SupabaseTable<LearningBettingRow> {
  @override
  String get tableName => 'learning_betting';

  @override
  LearningBettingRow createRow(Map<String, dynamic> data) =>
      LearningBettingRow(data);
}

class LearningBettingRow extends SupabaseDataRow {
  LearningBettingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LearningBettingTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get category => getField<String>('category')!;
  set category(String value) => setField<String>('category', value);

  String get badge => getField<String>('badge')!;
  set badge(String value) => setField<String>('badge', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
