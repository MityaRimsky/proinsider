import '/components/custom_bottom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'live_page_widget.dart' show LivePageWidget;
import 'package:flutter/material.dart';

class LivePageModel extends FlutterFlowModel<LivePageWidget> {
  ///  Local state fields for this page.

  String liveForecasts = 'show';

  ///  State fields for stateful widgets in this page.

  // Model for CustomBottomNavBar component.
  late CustomBottomNavBarModel customBottomNavBarModel;

  @override
  void initState(BuildContext context) {
    customBottomNavBarModel =
        createModel(context, () => CustomBottomNavBarModel());
  }

  @override
  void dispose() {
    customBottomNavBarModel.dispose();
  }
}
