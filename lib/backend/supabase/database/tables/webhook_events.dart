import '../database.dart';

class WebhookEventsTable extends SupabaseTable<WebhookEventsRow> {
  @override
  String get tableName => 'webhook_events';

  @override
  WebhookEventsRow createRow(Map<String, dynamic> data) =>
      WebhookEventsRow(data);
}

class WebhookEventsRow extends SupabaseDataRow {
  WebhookEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WebhookEventsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get provider => getField<String>('provider')!;
  set provider(String value) => setField<String>('provider', value);

  String get eventType => getField<String>('event_type')!;
  set eventType(String value) => setField<String>('event_type', value);

  String get idempotencyKey => getField<String>('idempotency_key')!;
  set idempotencyKey(String value) =>
      setField<String>('idempotency_key', value);

  int? get paymentId => getField<int>('payment_id');
  set paymentId(int? value) => setField<int>('payment_id', value);

  String? get invoiceId => getField<String>('invoice_id');
  set invoiceId(String? value) => setField<String>('invoice_id', value);

  int? get providerTransactionId => getField<int>('provider_transaction_id');
  set providerTransactionId(int? value) =>
      setField<int>('provider_transaction_id', value);

  String? get providerSubscriptionId =>
      getField<String>('provider_subscription_id');
  set providerSubscriptionId(String? value) =>
      setField<String>('provider_subscription_id', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  dynamic get payload => getField<dynamic>('payload')!;
  set payload(dynamic value) => setField<dynamic>('payload', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  DateTime get receivedAt => getField<DateTime>('received_at')!;
  set receivedAt(DateTime value) => setField<DateTime>('received_at', value);

  DateTime? get processedAt => getField<DateTime>('processed_at');
  set processedAt(DateTime? value) => setField<DateTime>('processed_at', value);
}
