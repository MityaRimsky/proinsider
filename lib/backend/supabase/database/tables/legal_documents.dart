import '../database.dart';

class LegalDocumentsTable extends SupabaseTable<LegalDocumentsRow> {
  @override
  String get tableName => 'legal_documents';

  @override
  LegalDocumentsRow createRow(Map<String, dynamic> data) =>
      LegalDocumentsRow(data);
}

class LegalDocumentsRow extends SupabaseDataRow {
  LegalDocumentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LegalDocumentsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get documentKey => getField<String>('document_key')!;
  set documentKey(String value) => setField<String>('document_key', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get content => getField<String>('content')!;
  set content(String value) => setField<String>('content', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
