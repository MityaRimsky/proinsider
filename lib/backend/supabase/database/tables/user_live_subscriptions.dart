import '../database.dart';

class UserLiveSubscriptionsTable
    extends SupabaseTable<UserLiveSubscriptionsRow> {
  @override
  String get tableName => 'user_live_subscriptions';

  @override
  UserLiveSubscriptionsRow createRow(Map<String, dynamic> data) =>
      UserLiveSubscriptionsRow(data);
}

class UserLiveSubscriptionsRow extends SupabaseDataRow {
  UserLiveSubscriptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserLiveSubscriptionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get planId => getField<int>('plan_id')!;
  set planId(int value) => setField<int>('plan_id', value);

  int get optionId => getField<int>('option_id')!;
  set optionId(int value) => setField<int>('option_id', value);

  int get paymentId => getField<int>('payment_id')!;
  set paymentId(int value) => setField<int>('payment_id', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  DateTime get startsAt => getField<DateTime>('starts_at')!;
  set startsAt(DateTime value) => setField<DateTime>('starts_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  String get provider => getField<String>('provider')!;
  set provider(String value) => setField<String>('provider', value);

  String? get providerSubscriptionId =>
      getField<String>('provider_subscription_id');
  set providerSubscriptionId(String? value) =>
      setField<String>('provider_subscription_id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
