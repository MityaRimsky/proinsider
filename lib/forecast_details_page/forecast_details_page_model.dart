import '/components/analytics_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'forecast_details_page_widget.dart' show ForecastDetailsPageWidget;
import 'package:flutter/material.dart';

class ForecastDetailsPageModel
    extends FlutterFlowModel<ForecastDetailsPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Analytics component.
  late AnalyticsModel analyticsModel;

  @override
  void initState(BuildContext context) {
    analyticsModel = createModel(context, () => AnalyticsModel());
  }

  @override
  void dispose() {
    analyticsModel.dispose();
  }
}
