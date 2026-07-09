import '../database.dart';

class ForecastDetailsViewTable extends SupabaseTable<ForecastDetailsViewRow> {
  @override
  String get tableName => 'forecast_details_view';

  @override
  ForecastDetailsViewRow createRow(Map<String, dynamic> data) =>
      ForecastDetailsViewRow(data);
}

class ForecastDetailsViewRow extends SupabaseDataRow {
  ForecastDetailsViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ForecastDetailsViewTable();

  int? get eventId => getField<int>('event_id');
  set eventId(int? value) => setField<int>('event_id', value);

  int? get forecastCardId => getField<int>('forecast_card_id');
  set forecastCardId(int? value) => setField<int>('forecast_card_id', value);

  String? get sport => getField<String>('sport');
  set sport(String? value) => setField<String>('sport', value);

  String? get league => getField<String>('league');
  set league(String? value) => setField<String>('league', value);

  String? get betMarket => getField<String>('bet_market');
  set betMarket(String? value) => setField<String>('bet_market', value);

  double? get odds => getField<double>('odds');
  set odds(double? value) => setField<double>('odds', value);

  String? get predictionText => getField<String>('prediction_text');
  set predictionText(String? value) =>
      setField<String>('prediction_text', value);

  String? get homeScore => getField<String>('home_score');
  set homeScore(String? value) => setField<String>('home_score', value);

  String? get awayScore => getField<String>('away_score');
  set awayScore(String? value) => setField<String>('away_score', value);

  int? get winnerTeamId => getField<int>('winner_team_id');
  set winnerTeamId(int? value) => setField<int>('winner_team_id', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  int? get homeTeamId => getField<int>('home_team_id');
  set homeTeamId(int? value) => setField<int>('home_team_id', value);

  String? get homeTeamName => getField<String>('home_team_name');
  set homeTeamName(String? value) => setField<String>('home_team_name', value);

  String? get homeTeamLogoUrl => getField<String>('home_team_logo_url');
  set homeTeamLogoUrl(String? value) =>
      setField<String>('home_team_logo_url', value);

  int? get awayTeamId => getField<int>('away_team_id');
  set awayTeamId(int? value) => setField<int>('away_team_id', value);

  String? get awayTeamName => getField<String>('away_team_name');
  set awayTeamName(String? value) => setField<String>('away_team_name', value);

  String? get awayTeamLogoUrl => getField<String>('away_team_logo_url');
  set awayTeamLogoUrl(String? value) =>
      setField<String>('away_team_logo_url', value);
}
