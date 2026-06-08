import '/components/custom_bottom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'subscribes_widget.dart' show SubscribesWidget;
import 'package:flutter/material.dart';

class SubscribesModel extends FlutterFlowModel<SubscribesWidget> {
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
