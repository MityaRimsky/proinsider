import '../database.dart';

class ForecastEventsTable extends SupabaseTable<ForecastEventsRow> {
  @override
  String get tableName => 'forecast_events';

  @override
  ForecastEventsRow createRow(Map<String, dynamic> data) =>
      ForecastEventsRow(data);
}

class ForecastEventsRow extends SupabaseDataRow {
  ForecastEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ForecastEventsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int get forecastCardId => getField<int>('forecast_card_id')!;
  set forecastCardId(int value) => setField<int>('forecast_card_id', value);

  String get sport => getField<String>('sport')!;
  set sport(String value) => setField<String>('sport', value);

  String get league => getField<String>('league')!;
  set league(String value) => setField<String>('league', value);

  int get homeTeamId => getField<int>('home_team_id')!;
  set homeTeamId(int value) => setField<int>('home_team_id', value);

  int get awayTeamId => getField<int>('away_team_id')!;
  set awayTeamId(int value) => setField<int>('away_team_id', value);

  DateTime? get eventTime => getField<DateTime>('event_time');
  set eventTime(DateTime? value) => setField<DateTime>('event_time', value);

  String? get betMarket => getField<String>('bet_market');
  set betMarket(String? value) => setField<String>('bet_market', value);

  double get odds => getField<double>('odds')!;
  set odds(double value) => setField<double>('odds', value);

  String get resultStatus => getField<String>('result_status')!;
  set resultStatus(String value) => setField<String>('result_status', value);

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get predictionText => getField<String>('prediction_text');
  set predictionText(String? value) =>
      setField<String>('prediction_text', value);

  String? get homeScore => getField<String>('home_score');
  set homeScore(String? value) => setField<String>('home_score', value);

  String? get awayScore => getField<String>('away_score');
  set awayScore(String? value) => setField<String>('away_score', value);

  int? get winnerTeamId => getField<int>('winner_team_id');
  set winnerTeamId(int? value) => setField<int>('winner_team_id', value);
}
