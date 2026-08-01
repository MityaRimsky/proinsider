import '../database.dart';

class UserLivePredictionAssignmentsTable
    extends SupabaseTable<UserLivePredictionAssignmentsRow> {
  @override
  String get tableName => 'user_live_prediction_assignments';

  @override
  UserLivePredictionAssignmentsRow createRow(Map<String, dynamic> data) =>
      UserLivePredictionAssignmentsRow(data);
}

class UserLivePredictionAssignmentsRow extends SupabaseDataRow {
  UserLivePredictionAssignmentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserLivePredictionAssignmentsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get livePredictionId => getField<int>('live_prediction_id')!;
  set livePredictionId(int value) => setField<int>('live_prediction_id', value);

  int? get notificationId => getField<int>('notification_id');
  set notificationId(int? value) => setField<int>('notification_id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
