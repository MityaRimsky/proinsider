import '../database.dart';

class ForecastCardsDetailsViewTable
    extends SupabaseTable<ForecastCardsDetailsViewRow> {
  @override
  String get tableName => 'forecast_cards_details_view';

  @override
  ForecastCardsDetailsViewRow createRow(Map<String, dynamic> data) =>
      ForecastCardsDetailsViewRow(data);
}

class ForecastCardsDetailsViewRow extends SupabaseDataRow {
  ForecastCardsDetailsViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ForecastCardsDetailsViewTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  double? get totalOdds => getField<double>('total_odds');
  set totalOdds(double? value) => setField<double>('total_odds', value);

  DateTime? get startTime => getField<DateTime>('start_time');
  set startTime(DateTime? value) => setField<DateTime>('start_time', value);

  String? get resultStatus => getField<String>('result_status');
  set resultStatus(String? value) => setField<String>('result_status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get analyticsTitle => getField<String>('analytics_title');
  set analyticsTitle(String? value) =>
      setField<String>('analytics_title', value);

  String? get analyticsText => getField<String>('analytics_text');
  set analyticsText(String? value) => setField<String>('analytics_text', value);

  String? get analyticsSummary => getField<String>('analytics_summary');
  set analyticsSummary(String? value) =>
      setField<String>('analytics_summary', value);

  int? get eventsCount => getField<int>('events_count');
  set eventsCount(int? value) => setField<int>('events_count', value);

  String? get betFormat => getField<String>('bet_format');
  set betFormat(String? value) => setField<String>('bet_format', value);
}
