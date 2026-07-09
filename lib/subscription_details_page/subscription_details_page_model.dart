import '/components/gold_subscription_header_widget.dart';
import '/components/live_subscription_header_widget.dart';
import '/components/premium_subscription_header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'subscription_details_page_widget.dart'
    show SubscriptionDetailsPageWidget;
import 'package:flutter/material.dart';

class SubscriptionDetailsPageModel
    extends FlutterFlowModel<SubscriptionDetailsPageWidget> {
  ///  Local state fields for this page.

  int selectedOption = 1;

  ///  State fields for stateful widgets in this page.

  // Model for PremiumSubscriptionHeader component.
  late PremiumSubscriptionHeaderModel premiumSubscriptionHeaderModel;
  // Model for GoldSubscriptionHeader component.
  late GoldSubscriptionHeaderModel goldSubscriptionHeaderModel;
  // Model for LiveSubscriptionHeader component.
  late LiveSubscriptionHeaderModel liveSubscriptionHeaderModel;

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
}
