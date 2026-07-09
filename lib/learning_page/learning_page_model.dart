import '/components/custom_bottom_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'learning_page_widget.dart' show LearningPageWidget;
import 'package:flutter/material.dart';

class LearningPageModel extends FlutterFlowModel<LearningPageWidget> {
  ///  Local state fields for this page.

  String selectedCategory = 'basics';

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
