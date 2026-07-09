import '../database.dart';

class LivePredictionsTable extends SupabaseTable<LivePredictionsRow> {
  @override
  String get tableName => 'live_predictions';

  @override
  LivePredictionsRow createRow(Map<String, dynamic> data) =>
      LivePredictionsRow(data);
}

class LivePredictionsRow extends SupabaseDataRow {
  LivePredictionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LivePredictionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get predictionText => getField<String>('prediction_text')!;
  set predictionText(String value) =>
      setField<String>('prediction_text', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  DateTime get publishedAt => getField<DateTime>('published_at')!;
  set publishedAt(DateTime value) => setField<DateTime>('published_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
