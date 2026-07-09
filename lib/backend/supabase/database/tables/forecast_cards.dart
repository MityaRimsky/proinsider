import '../database.dart';

class ForecastCardsTable extends SupabaseTable<ForecastCardsRow> {
  @override
  String get tableName => 'forecast_cards';

  @override
  ForecastCardsRow createRow(Map<String, dynamic> data) =>
      ForecastCardsRow(data);
}

class ForecastCardsRow extends SupabaseDataRow {
  ForecastCardsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ForecastCardsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  double get totalOdds => getField<double>('total_odds')!;
  set totalOdds(double value) => setField<double>('total_odds', value);

  DateTime get startTime => getField<DateTime>('start_time')!;
  set startTime(DateTime value) => setField<DateTime>('start_time', value);

  String get resultStatus => getField<String>('result_status')!;
  set resultStatus(String value) => setField<String>('result_status', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get analyticsTitle => getField<String>('analytics_title');
  set analyticsTitle(String? value) =>
      setField<String>('analytics_title', value);

  String? get analyticsText => getField<String>('analytics_text');
  set analyticsText(String? value) => setField<String>('analytics_text', value);

  String? get analyticsSummary => getField<String>('analytics_summary');
  set analyticsSummary(String? value) =>
      setField<String>('analytics_summary', value);
}
