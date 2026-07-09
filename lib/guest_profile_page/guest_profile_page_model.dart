import '/components/custom_bottom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'guest_profile_page_widget.dart' show GuestProfilePageWidget;
import 'package:flutter/material.dart';

class GuestProfilePageModel extends FlutterFlowModel<GuestProfilePageWidget> {
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
