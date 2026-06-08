import '/components/custom_bottom_nav_bar_widget.dart';
import '/components/ordinar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  String selectedSport = 'all';

  ///  State fields for stateful widgets in this page.

  // Model for Ordinar component.
  late OrdinarModel ordinarModel;
  // Model for CustomBottomNavBar component.
  late CustomBottomNavBarModel customBottomNavBarModel;

  @override
  void initState(BuildContext context) {
    ordinarModel = createModel(context, () => OrdinarModel());
    customBottomNavBarModel =
        createModel(context, () => CustomBottomNavBarModel());
  }

  @override
  void dispose() {
    ordinarModel.dispose();
    customBottomNavBarModel.dispose();
  }
}
