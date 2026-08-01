import '../database.dart';

class PaymentsTable extends SupabaseTable<PaymentsRow> {
  @override
  String get tableName => 'payments';

  @override
  PaymentsRow createRow(Map<String, dynamic> data) => PaymentsRow(data);
}

class PaymentsRow extends SupabaseDataRow {
  PaymentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PaymentsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get optionId => getField<int>('option_id')!;
  set optionId(int value) => setField<int>('option_id', value);

  String get provider => getField<String>('provider')!;
  set provider(String value) => setField<String>('provider', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  double get amount => getField<double>('amount')!;
  set amount(double value) => setField<double>('amount', value);

  String get currency => getField<String>('currency')!;
  set currency(String value) => setField<String>('currency', value);

  String get invoiceId => getField<String>('invoice_id')!;
  set invoiceId(String value) => setField<String>('invoice_id', value);

  int? get providerTransactionId => getField<int>('provider_transaction_id');
  set providerTransactionId(int? value) =>
      setField<int>('provider_transaction_id', value);

  String get paymentType => getField<String>('payment_type')!;
  set paymentType(String value) => setField<String>('payment_type', value);

  int? get parentPaymentId => getField<int>('parent_payment_id');
  set parentPaymentId(int? value) => setField<int>('parent_payment_id', value);

  String? get failureCode => getField<String>('failure_code');
  set failureCode(String? value) => setField<String>('failure_code', value);

  String? get failureMessage => getField<String>('failure_message');
  set failureMessage(String? value) =>
      setField<String>('failure_message', value);

  dynamic get providerPayload => getField<dynamic>('provider_payload');
  set providerPayload(dynamic value) =>
      setField<dynamic>('provider_payload', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);

  DateTime? get failedAt => getField<DateTime>('failed_at');
  set failedAt(DateTime? value) => setField<DateTime>('failed_at', value);

  DateTime? get refundedAt => getField<DateTime>('refunded_at');
  set refundedAt(DateTime? value) => setField<DateTime>('refunded_at', value);
}
