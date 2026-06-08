import '../database.dart';

class NewTable extends SupabaseTable<NewRow> {
  @override
  String get tableName => 'new';

  @override
  NewRow createRow(Map<String, dynamic> data) => NewRow(data);
}

class NewRow extends SupabaseDataRow {
  NewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NewTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
