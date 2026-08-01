import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/gold_subscription_header_widget.dart';
import '/components/live_subscription_header_widget.dart';
import '/components/premium_subscription_header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dart:async';
import 'subscription_details_page_widget.dart'
    show SubscriptionDetailsPageWidget;
import 'package:flutter/material.dart';

class SubscriptionDetailsPageModel
    extends FlutterFlowModel<SubscriptionDetailsPageWidget> {
  ///  Local state fields for this page.

  int selectedOption = 1;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in SubscriptionDetailsPage widget.
  List<SubscriptionPlanDetailsViewRow>? currentOptionns;
  // Model for PremiumSubscriptionHeader component.
  late PremiumSubscriptionHeaderModel premiumSubscriptionHeaderModel;
  // Model for GoldSubscriptionHeader component.
  late GoldSubscriptionHeaderModel goldSubscriptionHeaderModel;
  // Model for LiveSubscriptionHeader component.
  late LiveSubscriptionHeaderModel liveSubscriptionHeaderModel;
  // Stores action output result for [Backend Call - API (CreatePayment)] action in Button widget.
  ApiCallResponse? createPaymentResult;
  // Stores action output result for [Bottom Sheet - CancelSubscriptionSheet] action in Button widget.
  bool? cancelResult;
  Completer<List<SubscriptionPlanDetailsViewRow>>? requestCompleter;

  @override
  void initState(BuildContext context) {
    premiumSubscriptionHeaderModel =
        createModel(context, () => PremiumSubscriptionHeaderModel());
    goldSubscriptionHeaderModel =
        createModel(context, () => GoldSubscriptionHeaderModel());
    liveSubscriptionHeaderModel =
        createModel(context, () => LiveSubscriptionHeaderModel());
  }

  @override
  void dispose() {
    premiumSubscriptionHeaderModel.dispose();
    goldSubscriptionHeaderModel.dispose();
    liveSubscriptionHeaderModel.dispose();
  }

  /// Additional helper methods.
  Future waitForRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
