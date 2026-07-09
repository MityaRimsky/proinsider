import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'auth_page_widget.dart' show AuthPageWidget;
import 'package:flutter/material.dart';

class AuthPageModel extends FlutterFlowModel<AuthPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Field_for_email widget.
  FocusNode? fieldForEmailFocusNode;
  TextEditingController? fieldForEmailTextController;
  String? Function(BuildContext, String?)? fieldForEmailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    fieldForEmailFocusNode?.dispose();
    fieldForEmailTextController?.dispose();
  }
}
