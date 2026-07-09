import '../database.dart';

class LearningBasicsTable extends SupabaseTable<LearningBasicsRow> {
  @override
  String get tableName => 'learning_basics';

  @override
  LearningBasicsRow createRow(Map<String, dynamic> data) =>
      LearningBasicsRow(data);
}

class LearningBasicsRow extends SupabaseDataRow {
  LearningBasicsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LearningBasicsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get description => getField<String>('description')!;
  set description(String value) => setField<String>('description', value);

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
