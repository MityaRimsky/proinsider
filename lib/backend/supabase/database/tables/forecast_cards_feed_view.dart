import '../database.dart';

class ForecastCardsFeedViewTable
    extends SupabaseTable<ForecastCardsFeedViewRow> {
  @override
  String get tableName => 'forecast_cards_feed_view';

  @override
  ForecastCardsFeedViewRow createRow(Map<String, dynamic> data) =>
      ForecastCardsFeedViewRow(data);
}

class ForecastCardsFeedViewRow extends SupabaseDataRow {
  ForecastCardsFeedViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ForecastCardsFeedViewTable();

  int? get cardId => getField<int>('card_id');
  set cardId(int? value) => setField<int>('card_id', value);

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

  String? get sportsFilter => getField<String>('sports_filter');
  set sportsFilter(String? value) => setField<String>('sports_filter', value);

  int? get eventId => getField<int>('event_id');
  set eventId(int? value) => setField<int>('event_id', value);

  String? get eventSport => getField<String>('event_sport');
  set eventSport(String? value) => setField<String>('event_sport', value);

  String? get eventLeague => getField<String>('event_league');
  set eventLeague(String? value) => setField<String>('event_league', value);

  DateTime? get eventTime => getField<DateTime>('event_time');
  set eventTime(DateTime? value) => setField<DateTime>('event_time', value);

  String? get betMarket => getField<String>('bet_market');
  set betMarket(String? value) => setField<String>('bet_market', value);

  double? get eventOdds => getField<double>('event_odds');
  set eventOdds(double? value) => setField<double>('event_odds', value);

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
